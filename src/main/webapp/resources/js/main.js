var SF_NAME_SPACE = "http://sfweb.is.k.u-tokyo.ac.jp/";
var KASHIWADE_BASE_URL = 'http://heineken.is.k.u-tokyo.ac.jp/forest3/';
var GROUP_NAME = 'forest3';

var paper, graph;
var scale = 1;
var projectName = null;
var selectedCell = null;

//ワークフローに関連するドキュメント
var documents = new Object();

$(function() {
    var sfProjectUri = $('#project_uri').text();
    var sfProjectName = '';
    var sfProjectId = sfProjectUri.split('#')[1];

    // get project name
    var query = 'SELECT DISTINCT ?name WHERE { ';
    query += '<' + sfProjectUri + '> ';
    query += '<http://sfweb.is.k.u-tokyo.ac.jp/projectName> ';
    query += '?name }';
    $.ajax({
        type : 'POST',
        url : KASHIWADE_BASE_URL + 'sparql',
        data : { query : query, },
        success : function(data) {
            var result = data.results.bindings[0];
            if (result) {
                sfProjectName = result.name.value;
                $('#project_name').text(sfProjectName);
            } else {
                console.log('[ERROR] cannot find resource: ' + sfProjectUri);
            }
        },
    });

    // graph
    graph = new joint.dia.Graph;

    // release selected state when removed
    graph.on('remove', function(cell) {
        if (cell === selectedCell) {
            selectedCell = null;
        }
    });

    // paper
    paper = new joint.dia.Paper({
        el: $('#holder'),
        width: 2000,
        height: 2000,
        model: graph,
        gridSize: 1,
        snapLinks: true,
        perpendicularLinks: true,
        linkView: joint.dia.LinkView.extend({
            pointerdblclick: function(evt, x, y) {
                if (V(evt.target).hasClass('connection') || V(evt.target).hasClass('connection-wrap')) {
                    this.addVertex({ x: x, y: y });
                }
            }
        }),
        interactive: function(cellView) {
            if (cellView.model instanceof joint.dia.Link) {
                return { vertexAdd: false };
            }
            return true;
        },
    });

    // zoom with mouse wheel
    // paper.$el.on('mousewheel', onMouseWheel);
    paper.on('blank:pointerclick', function(evt, x, y) {
        if ($('#rect_btn').hasClass('active')) {
            // add rect when clicked
            var rect = new joint.shapes.basic.Rect({
                position: { x: x, y: y },
                size: { width: 150, height: 60 },
                attrs: { rect: { fill: 'blue', }, text: { text: 'New task', fill: 'white' } },
            });
            graph.addCell(rect);

            // set default property
            rect.sfProp = {
                id: rect.id,
                type: 'node',
                taskName: 'New task',
                workload: '',
                worker: '',
                location: '',
                comment: '',
            };
        } else if ($('#circle_btn').hasClass('active')) {
            // add circle when clicked
            var circle = new joint.shapes.basic.Circle({
                position: { x: x, y: y },
                size: { width: 150, height: 60 },
                attrs: { circle: { fill: 'blue', }, text: { text: 'New task', fill: 'white' } },
            });
            graph.addCell(circle);

            // set default property
            circle.sfProp = {
                id: circle.id,
                type: 'node',
                taskName: 'New task',
                workload: '',
                worker: '',
                location: '',
                comment: '',
            };
        } else if ($('#edge_btn').hasClass('active')) {
            // add link when clicked
            var link = new joint.dia.Link({
                source: { x: x - 100, y: y },
                target: { x: x + 100, y: y },
                attrs: {
                    '.connection': {
                        'stroke-width': 3, stroke: 'black'
                    },
                    '.marker-target': { stroke: 'black', fill: 'black', d: 'M 12 0 L 0 6 L 12 12 z' },
                }
            });
            graph.addCell(link);
        }
    });

    // show property icon when mouseovered
    paper.on('cell:pointerclick', function(cellView, evt, x, y) {
        // change color
        var cell = cellView.model;
        if (isRect(selectedCell) || isCircle(selectedCell)) {
            setCellColor(selectedCell, 'blue');
        } else if (isLink(selectedCell)) {
            setCellColor(selectedCell, 'black');
        }
        if (cell === selectedCell) {
            selectedCell = null;
        } else {
            selectedCell = cell;
            setCellColor(selectedCell, 'red');
        }

        // show properties
        if (isRect(cell) || isCircle(cell)) {
            showSfProps(cell.sfProp);
        } else {
            $('.sf-prop-field').val('');
        }
    });

    // reflect properties modification
    $('.sf-prop-field').change(function() {
        if (isRect(selectedCell) || isCircle(selectedCell)) {
            updateSfProps(selectedCell);
            selectedCell.attr({
                text: { text: selectedCell.sfProp.taskName },
            });
        }
    });

    // remove cell when remove button clicked
    $('#remove_btn').click(function() {
        if (selectedCell !== null) {
            selectedCell.remove();
            selectedCell = null;
        }
    });

    // clear graph when clear button clicked
    $('#clear_btn').click(function() {
        graph.clear();
        selectedCell = null;
    });

    // auto layout
    $('#layout_btn').click(function() {
        var elements = graph.getElements();
        var links = graph.getLinks();
        var cells = elements.concat(links);
        graph.clear();
        graph.addCells(cells);
        joint.layout.DirectedGraph.layout(graph, {
            setLinkVertices: false,
        });
        centerGraph(paper);
    });

    // center
    // $('#center_btn').click(function() {
    //     centerGraph(paper);
    // });

    // zoom in
    $('#zoom_in_btn').click(function() {
        scale *= 1.1;
        paper.scale(scale, scale);
    });

    // zoom out
    $('#zoom_out_btn').click(function() {
        scale *= 0.9;
        paper.scale(scale, scale);
    });

    // import
    $('#import_btn').click(function() {
        clearSelect();

        $.ajax({
            url: '/sfweb/getWorkflow',
            type: 'POST',
            dataType: 'text',
            data: { 'projectID': sfProjectId },
            success: function(data) {
                selectedCell = null;
                $('.sf-prop-field').val('');

                // create graph
                var graphJson = { 'cells': [] };
                var propsJson = { 'props': [] };
                var resultJson = $.parseJSON(data).results.bindings;

                // console.log(resultJson);

                var dataJson = {};
                $.each(resultJson, function(i, result) {
                    var uri = result.childURI.value;
                    var property = result.v.value;
                    var value = result.o.value;
                    if (dataJson[uri] == null){
                        dataJson[uri] = {};
                    }
                    dataJson[uri][property] = value;
                });

                // console.log(dataJson);

                $.each(dataJson, function(i, data) {
                    var cell = createCellFromURIValuePair(data);
                    graphJson.cells.push(cell);
                    var prop = createSfPropFromURIValuePair(data);
                    propsJson.props.push(prop);
                });

                // console.log(graphJson);
                // console.log(propsJson);

                graph.fromJSON(graphJson);
                importSfPropFromJSON(graph, propsJson);

                console.log('Import succeeded');
            }
        });
    });

    // export
    $('#export_btn').click(function() {
        clearSelect();

        var sfPropAry = $.map(graph.getElements(), function(val, idx) {
            return val.sfProp;
        });
        var workflowJSON = JSON.stringify(graph.toJSON());
        var properties = JSON.stringify({ props: sfPropAry });
        $.ajax({
            url: '/sfweb/addWorkflow',
            type: 'POST',
            dataType: 'text',
            data: {
                'projectID': sfProjectId,
                'workflowJSON': workflowJSON,
                'properties': properties
            },
            success: function(data) {
                console.log('Export succeeded: ' + data);
            }
        });
    });

    // file upload
    $('#file_upload_btn').click(function() {
        $('#file_upload_input').click();
    });

    $('#file_upload_input').change(function() {
        var files = $(file_upload_input)[0].files;

        $("#uploading-file").append('<img src="resources/img/gif-load.gif">');

        for(var i = 0; i < files.length; i++){
            var fd = new FormData();
            fd.append("files", files[i]);

            fd.append('group', GROUP_NAME);

            var fields = new Array();
            var values = new Array();
            var literalFlags = new Array();

          //ProjectUriとドキュメントの紐づけ
            fields.push(SF_NAME_SPACE+"relatedFlow");
            values.push(sfProjectUri);
            literalFlags.push("false");

            //NodeUriとドキュメントの紐づけ
            var nodeId = $("#task_id").val();
            var nodeUri = SF_NAME_SPACE+"node#"+nodeId;//NodeUri -- SPARQL検索に変更したほうがよいか？
            fields.push(SF_NAME_SPACE+"relatedNode");
            values.push(nodeUri);
            literalFlags.push("false");

            fd.append('fields', fields);
            fd.append('values', values);
            fd.append('literalFlags', literalFlags);

            $.ajax({
                url: KASHIWADE_BASE_URL + 'resource/add',
                type: 'POST',
                data: fd,
                processData: false,
                contentType: false,
                dataType: 'json',
                async : false,
                success: function(data) {
                    //console.log('File upload succeeded: ');
                    //console.log(data);
                    //console.log("------");

                }
            });
        }
        $("#uploading-file").empty();
        alert("Uploaded.");

        return false;
    });

    // resize paper object
    $(window).resize(function() {
        paper.setDimensions($('#holder').width(), $('#holder').height());
    });

    // tooltip
    $('[data-toggle="tooltip"]').tooltip();

    // import project
    $('#import_btn').click();


    //ワークフローに関連するすべての文書を表示
    $('#file_list_all_btn').click(function() {
        getDocumentList(sfProjectUri);
    });

    //getDocumentList(sfProjectUri);

    //指定したワークフローに関連する文書の表示
    $('#file_list_btn').click(function() {

        var nodeId = $("#task_id").val();
        var nodeUri = SF_NAME_SPACE+"node#"+nodeId;

        getDocumentList(sfProjectUri, nodeUri);
    });

    //loading-iconの削除
    $("#load-data").empty();
});

var isRect = function(cell) {
    return ((selectedCell !== null) && (cell instanceof joint.shapes.basic.Rect));
};

var isCircle = function(cell) {
    return ((selectedCell !== null) && (cell instanceof joint.shapes.basic.Circle));
};

var isLink = function(cell) {
    return ((selectedCell !== null) && (cell instanceof joint.dia.Link));
};

var setCellColor = function(cell, color) {
    if (isRect(cell)) {
        cell.attr({
            rect: { fill: color },
        });
    } else if (isCircle(cell)) {
        cell.attr({
            circle: { fill: color },
        });
    } else if (isLink(cell)) {
        cell.attr({
            '.connection': { stroke: color },
            '.marker-target': { stroke: color, fill: color },
        });
    }
};

var showSfProps = function(prop) {
    $('#task_id').val(prop.id);
    $('#task_name').val(prop.taskName);
    $('#workload').val(prop.workload);
    $('#worker').val(prop.worker);
    $('#location').val(prop.location);
    $('#comment').val(prop.comment);
};

var updateSfProps = function(cell) {
    if (cell !== null) {
        cell.sfProp = {
            id: cell.id,
            type: cell.sfProp.type,
            taskName: $('#task_name').val(),
            workload: $('#workload').val(),
            worker: $('#worker').val(),
            location: $('#location').val(),
            comment: $('#comment').val(),
        };
        $("#doc-list").empty();
    }
};

var createCellFromURIValuePair = function(data) {
    var cell = {};
    cell.type = data[SF_NAME_SPACE+'shape'];
    cell.id = data[SF_NAME_SPACE+'id'];
    cell.z = parseInt(data[SF_NAME_SPACE+'z']);

    if (data[SF_NAME_SPACE+'type'] == 'Node') {
        cell.angle = parseInt(data[SF_NAME_SPACE+'angle']);
        cell.attrs = {'rect':{},'text':{}};
        cell.attrs.rect.fill = data[SF_NAME_SPACE+'fill_color'];
        cell.attrs.text.fill = data[SF_NAME_SPACE+'text_color'];
        cell.attrs.text.text = data[SF_NAME_SPACE+'text'];
        cell.position = {};
        cell.position.x = parseInt(data[SF_NAME_SPACE+'position_x']);
        cell.position.y = parseInt(data[SF_NAME_SPACE+'position_y']);
        cell.size = {};
        cell.size.height = parseInt(data[SF_NAME_SPACE+'height']);
        cell.size.width = parseInt(data[SF_NAME_SPACE+'width']);
    } else if (data[SF_NAME_SPACE+'type'] == 'Link') {
        cell.attrs = {'.connection':{},'.marker-target':{}};
        cell.attrs['.connection'].stroke = data[SF_NAME_SPACE+'stroke'];
        cell.attrs['.connection']['stroke-width'] = data[SF_NAME_SPACE+'stroke_width'];
        cell.attrs['.marker-target'].d = data[SF_NAME_SPACE+'d'];
        cell.attrs['.marker-target'].fill = data[SF_NAME_SPACE+'fill'];
        cell.attrs['.marker-target'].stroke = data[SF_NAME_SPACE+'stroke'];
        cell.source = {};
        cell.source.id = data[SF_NAME_SPACE+'source'].split('#')[1];
        cell.target = {};
        cell.target.id = data[SF_NAME_SPACE+'target'].split('#')[1];
    }

    return cell;
};

var createSfPropFromURIValuePair =  function(data) {
    var prop = {};
    prop.comment = data[SF_NAME_SPACE+'comment'];
    prop.id = data[SF_NAME_SPACE+'id'];
    prop.location = data[SF_NAME_SPACE+'location'];
    prop.taskName = data[SF_NAME_SPACE+'task_name'];
    prop.type = data[SF_NAME_SPACE+'type'].toLowerCase();
    prop.worker = data[SF_NAME_SPACE+'worker'];
    prop.workload = data[SF_NAME_SPACE+'workload'];
    return prop;
};

var importSfPropFromJSON = function(graph, json) {
    $.each(graph.getElements(), function(i, node) {
        var prop = json.props.filter(function(prop, j) {
            if (node.id === prop.id) {
                return prop;
            }
        })[0];
        node.sfProp = prop;
    });
};

var centerGraph = function(paper) {
    var $holder = $('#holder');
    var box = paper.getContentBBox();
    paper.setOrigin(($holder.width() - box.width) / 2, ($holder.height() - box.height) / 2);
};

var clearSelect = function() {
    if (isRect(selectedCell) || isCircle(selectedCell)) {
        setCellColor(selectedCell, 'blue');
    } else if (isLink(selectedCell)) {
        setCellColor(selectedCell, 'black');
    }
    selectedCell = null;
    $('.sf-prop-field').val('');
};

//プロジェクトに関連するドキュメントの取得
function getDocumentList(resourceUri, nodeUri){

    //console.log(resourceUri+"\t"+nodeUri);

    //ノード指定がない場合
    if(nodeUri == "http://sfweb.is.k.u-tokyo.ac.jp/node#"){
        nodeUri = null;
    }

    var query = 'SELECT DISTINCT * WHERE { ';
    query += '?s <http://sfweb.is.k.u-tokyo.ac.jp/relatedFlow> <' + resourceUri + '> . ';
    query += '?s <http://sfweb.is.k.u-tokyo.ac.jp/relatedNode> ?nodeUri . ';
    if(nodeUri != null){//ノードの指定がある場合
        query += 'filter (?nodeUri = <'+nodeUri+'> ) . ';
    }
    query += '?nodeUri <http://sfweb.is.k.u-tokyo.ac.jp/task_name> ?nodeName . ';
    query += '?s <http://purl.org/dc/elements/1.1/title> ?title . ';
    query += '?s <http://purl.org/dc/elements/1.1/date> ?date . ';
    query += '}';

    var tbody = $("#tbody");
    tbody.empty();

    $.ajax({
        type : 'POST',
        url : KASHIWADE_BASE_URL + 'sparql',
        data : { query : query, },
        success : function(data) {
            var result = data.results.bindings;

            for(var i = 0; i < result.length; i++){
                var obj = result[i];

                //表に挿入
                var tr = $("<tr>");
                tbody.append(tr);

                var td = $("<td>");
                tr.append(td);
                td.append(obj.title.value);

                td = $("<td>");
                tr.append(td);
                td.append(obj.date.value);

                td = $("<td>");
                tr.append(td);
                td.append(obj.nodeName.value);

                td = $("<td>");
                tr.append(td);

                var a = $("<a>");
                td.append(a);
                a.attr("href", KASHIWADE_BASE_URL+"common/metadata?resourceUri="+encodeURIComponent(obj.s.value));
                a.attr("class", "btn btn-primary")
                a.append("View Detail&nbsp;&raquo;");
            }

            $.magnificPopup.open({
                items: {
                    src: $('#file-list')
                },
                type: 'inline'
            });
        },
    });
}

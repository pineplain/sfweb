var GRAPH_JSON_STR = '{"cells":[{"type":"basic.Rect","position":{"x":75,"y":110},"size":{"width":150,"height":60},"angle":0,"id":"94c31334-2d2f-4dd8-913b-02447e47ee08","z":1,"attrs":{"rect":{"fill":"blue"},"text":{"text":"うそです","fill":"white"}}},{"type":"basic.Rect","position":{"x":550,"y":115},"size":{"width":150,"height":60},"angle":0,"id":"128b02ae-20a4-4c36-a6bb-4bea248be176","z":2,"attrs":{"rect":{"fill":"blue"},"text":{"text":"たすくですよ","fill":"white"}}},{"type":"link","source":{"id":"94c31334-2d2f-4dd8-913b-02447e47ee08"},"target":{"id":"128b02ae-20a4-4c36-a6bb-4bea248be176"},"id":"6821aafe-64fa-46b9-b145-d8931f22ec02","z":3,"attrs":{".connection":{"stroke-width":3,"stroke":"black"},".marker-target":{"stroke":"black","fill":"black","d":"M 12 0 L 0 6 L 12 12 z"}}},{"type":"basic.Rect","position":{"x":75,"y":345},"size":{"width":150,"height":60},"angle":0,"id":"7c06af00-8dd1-4d66-b3df-18755a02096a","z":4,"attrs":{"rect":{"fill":"blue"},"text":{"text":"タスク２","fill":"white"}}},{"type":"link","source":{"id":"94c31334-2d2f-4dd8-913b-02447e47ee08"},"target":{"id":"7c06af00-8dd1-4d66-b3df-18755a02096a"},"id":"01f843ca-57e3-4ed7-b9f9-db8cb0a6e036","z":5,"attrs":{".connection":{"stroke-width":3,"stroke":"black"},".marker-target":{"stroke":"black","fill":"black","d":"M 12 0 L 0 6 L 12 12 z"}}},{"type":"link","source":{"id":"7c06af00-8dd1-4d66-b3df-18755a02096a"},"target":{"id":"128b02ae-20a4-4c36-a6bb-4bea248be176"},"id":"fb22ff08-b483-43bf-a3bf-a694995ab986","z":6,"attrs":{".connection":{"stroke-width":3,"stroke":"black"},".marker-target":{"stroke":"black","fill":"black","d":"M 12 0 L 0 6 L 12 12 z"}}}]}';
var SF_PROPS_JSON_STR = '{"props":[{"id":"94c31334-2d2f-4dd8-913b-02447e47ee08","type":"node","taskName":"うそです","workload":"あああ","worker":"いい意味で","location":"ううう～","comment":"コメント"},{"id":"128b02ae-20a4-4c36-a6bb-4bea248be176","type":"node","taskName":"たすくですよ","workload":"","worker":"","location":"","comment":"ほげほげ"},{"id":"7c06af00-8dd1-4d66-b3df-18755a02096a","type":"node","taskName":"タスク２","workload":"","worker":"","location":"","comment":"コメントです。"}]}';
var SF_PROJECT_NAME='Experiment Forest';
var SF_PROJECT_ID='86714dd1-f276-4ab3-9413-beee8f200f';

var KASHIWADE_BASE_URL = 'http://heineken.is.k.u-tokyo.ac.jp/forest3/';
var GROUP_NAME = 'forest3';

var selectedCell = null;
var graph, paper;

$(function() {
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
        width: $('#holder').width(),
        height: $('#holder').height(),
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

    // file import
    $('#import_btn').click(function() {
        // $('#import_file').click();
        var NAME_SPACE = "http://sfweb.is.k.u-tokyo.ac.jp/";
        var graph_json={"cells":[]};
        var props_json={"props":[]};
        $.ajax({
                url:'/sfweb/getWorkflow',
                type:'POST',
                dataType:'text',
                data:{'projectID':SF_PROJECT_ID},
                success: function(data) {
                    result_json = $.parseJSON(data).results.bindings;
                    data_json = {}
                    $.each(result_json, function(i,result){
                        //console.log(result.childURI);
                        uri = result.childURI.value;
                        property = result.v.value;
                        value = result.o.value;
                        if (data_json[uri] == null){
                            data_json[uri]={};
                        }
                        data_json[uri][property] = value;
                    });
                    console.log(data_json);
                    $.each(data_json, function(i,data){
                        if (data[NAME_SPACE+'type'] == 'Node'){
                            cell ={};
                            cell.angle = data[NAME_SPACE+'angle'];
                            cell.attrs={'rect':{},'text':{}};
                            cell.attrs.rect.fill=data[NAME_SPACE+'fill_color'];
                            cell.attrs.text.fill=data[NAME_SPACE+'text_color'];
                            cell.attrs.text.text=data[NAME_SPACE+'text'];
                            cell.id=data[NAME_SPACE+'id'];
                            cell.position={};
                            cell.position.x=data[NAME_SPACE+'position_x'];
                            cell.position.y=data[NAME_SPACE+'position_y'];
                            cell.size={}
                            cell.size.height= +data[NAME_SPACE+'height'];
                            cell.size.width = +data[NAME_SPACE+'width'];
                            cell.type = data[NAME_SPACE+'shape'];
                            cell.z = data[NAME_SPACE+'z'];
                            graph_json.cells.push(cell);
                        }else if (data[NAME_SPACE+'type'] == 'Link'){
                            cell ={};
                            cell.attrs={'.connection':{},'.marker-target':{}};
                            cell.attrs['.connection'].stroke=data[NAME_SPACE+'stroke'];
                            cell.attrs['.connection']['stroke-width']=data[NAME_SPACE+'stroke_width'];
                            cell.attrs['.marker-target'].d=data[NAME_SPACE+'d'];
                            cell.attrs['.marker-target'].fill=data[NAME_SPACE+'fill'];
                            cell.attrs['.marker-target'].stroke=data[NAME_SPACE+'stroke'];
                            cell.id=data[NAME_SPACE+'id'];
                            cell.source = {};
                            cell.source.id = data[NAME_SPACE+'source'].split('#')[1];
                            cell.target = {};
                            cell.target.id = data[NAME_SPACE+'target'].split('#')[1];
                            cell.type = data[NAME_SPACE+'shape'];
                            cell.z = data[NAME_SPACE+'z'];
                            graph_json.cells.push(cell);
                        }
                        if(data[NAME_SPACE+'comment']!=null){
                            prop = {};
                            prop.comment = data[NAME_SPACE+'comment'];
                            prop.id = data[NAME_SPACE+'id'];
                            prop.location = data[NAME_SPACE+'location'];
                            prop.taskName = data[NAME_SPACE+'taskName'];
                            prop.type = data[NAME_SPACE+'type'].toLowerCase();
                            prop.worker = data[NAME_SPACE+'worker'];
                            prop.workload = data[NAME_SPACE+'workload'];
                            props_json.props.push(prop);
                        }

                    });
                    console.log(graph_json);
                    console.log(props_json);
                    graph.fromJSON(graph_json);
                    importSfPropFromJSON(graph, props_json);
                }
        });

        //graph.fromJSON(JSON.parse(GRAPH_JSON_STR));
        //importSfPropFromJSON(graph, JSON.parse(SF_PROPS_JSON_STR));
    });
    $('#import_file').change(function() {
        var file = $(this)[0].files[0];
        console.log(file);
    });

    // file export
    $('#export_btn').click(function() {
        if (isRect(selectedCell) || isCircle(selectedCell)) {
            setCellColor(selectedCell, 'blue');
        } else if (isLink(selectedCell)) {
            setCellColor(selectedCell, 'black');
        }
        selectedCell = null;

        var sfPropAry = $.map(graph.getElements(), function(val, idx) {
            return val.sfProp;
        });
        var workflowJSON = JSON.stringify(graph.toJSON());
        var properties = JSON.stringify({ props: sfPropAry });
        $.ajax({
                url:'/sfweb/addWorkflow',
                type:'POST',
                dataType:'text',
                data:{'projectID':SF_PROJECT_ID,'workflowJSON':workflowJSON,'properties':properties},
                success: function(data) {
                    console.log("export success");
                }
        });
        console.log(JSON.stringify(graph.toJSON()));
        console.log(JSON.stringify({ props: sfPropAry }));
    });

    // file upload
    $('#file_upload_btn').click(function() {
        $('#file_upload_input').click();
    });
    $('#file_upload_input').change(function() {
        var fd = new FormData($(file_upload_form)[0]);
        fd.append('group', GROUP_NAME);

        $.ajax({
            url: KASHIWADE_BASE_URL + 'resource/add',
            type: 'POST',
            data: fd,
            processData: false,
            contentType: false,
            dataType: 'text',
            success: function(data) {
                console.log('File upload succeeded: ' + data);
            },
        });

        return false;
    });

    // resize paper object
    $(window).resize(function() {
        paper.setDimensions($('#holder').width(), $('#holder').height());
    });

    // tooltip
    $('[data-toggle="tooltip"]').tooltip();
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
    $('#task_name').val(prop.taskName);
    $('#workload').val(prop.workload);
    $('#worker').val(prop.worker);
    $('#location').val(prop.location);
    $('#comment').val(prop.comment);
};

var updateSfProps = function(cell) {
    cell.sfProp = {
        id: cell.id,
        type: cell.sfProp.type,
        taskName: $('#task_name').val(),
        workload: $('#workload').val(),
        worker: $('#worker').val(),
        location: $('#location').val(),
        comment: $('#comment').val(),
    };
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
}

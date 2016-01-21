var SF_NAME_SPACE = prefixes.sf;

var sfProjectUri, sfProjectId, sfProjectName;
var paper, graph;
var scale = 1;
var projectName = null;
var selectedCell = null;

var isRect = function(cell) {
	return ((selectedCell !== null) && (cell instanceof joint.shapes.basic.Rect));
};

var isCircle = function(cell) {
	return ((selectedCell !== null) && (cell instanceof joint.shapes.basic.Circle));
};

var isLink = function(cell) {
	return ((selectedCell !== null) && (cell instanceof joint.dia.Link));
};

var selectCell = function(cell) {
	console.log("selectCell\t");

	var color = "red";
	var width = 10;
	if (isRect(cell)) {
		cell.attr({
			rect : {
				stroke : color,
				'stroke-width' : width
			},
		});
	} else if (isCircle(cell)) {
		cell.attr({
			circle : {
				stroke : color,
				'stroke-width' : width
			},
		});
	} else if (isLink(cell)) {
		cell.attr({
			'.connection' : {
				stroke : color
			},
			'.marker-target' : {
				stroke : color,
				fill : color
			},
		});
	}
};

var unSelectCell = function(cell) {
	console.log("unSelectCell\t");

	var color = "black";
	var width = 1;
	if (isRect(cell)) {
		cell.attr({
			rect : {
				stroke : color,
				'stroke-width' : width
			},
		});
	} else if (isCircle(cell)) {
		cell.attr({
			circle : {
				stroke : color,
				'stroke-width' : width
			},
		});
	} else if (isLink(cell)) {
		cell.attr({
			'.connection' : {
				'stroke' : color
			},
			'.marker-target' : {
				stroke : color,
				fill : color
			},
		});
	}
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

$(function() {
	sfProjectUri = $('#project_uri').text();
	$("#link_to_kashiwade").attr(
			"href",
			KASHIWADE_BASE_URL + "common/metadata?resourceUri="
					+ encodeURIComponent(sfProjectUri));// Link to KASHIWADE
	$("#link_to_edit").attr("href",
			"edit?resourceUri=" + encodeURIComponent(sfProjectUri));// Link to
	// EDIT mode
	$("#link_to_view").attr("href",
			"view?resourceUri=" + encodeURIComponent(sfProjectUri));// Link to
	// VIEW mode
	sfProjectName = '';
	sfProjectId = sfProjectUri.split('#')[1];

	// initialize dataTable
	$('#fileTable').DataTable();

	// auto resize textarea
	$('textarea').autosize();

	var graph = new joint.dia.Graph;

	// release selected state when removed
	graph.on('remove', function(cell) {
		if (cell === selectedCell) {
			selectedCell = null;
		}
	});

	var $app = $('#holder');

	var paper = new joint.dia.Paper({
		width : 2000,
		height : 2000,
		gridSize : 1,
		model : graph,
		snapLinks : true,
		perpendicularLinks : true,
		linkView : joint.dia.LinkView.extend({
			pointerdblclick : function(evt, x, y) {
				if (V(evt.target).hasClass('connection')
						|| V(evt.target).hasClass('connection-wrap')) {
					this.addVertex({
						x : x,
						y : y
					});
				}
			}
		}),
		interactive : function(cellView) {
			if (cellView.model instanceof joint.dia.Link) {
				return {
					vertexAdd : false
				};
			}
			return true;
		}
	});

	// add nodes and edges
	paper.on('blank:pointerclick', function(evt, x, y) {

		console.log("add nodes and edges");

		if ($('#rect_btn').hasClass('active')) {
			// add rect when clicked
			var rect = new joint.shapes.basic.Rect({
				position : {
					x : x,
					y : y
				},
				size : {
					width : 150,
					height : 60
				},
				attrs : {
					rect : {
						fill : 'blue',
					},
					text : {
						text : 'New task',
						fill : 'white'
					}
				},
			});
			graph.addCell(rect);

			// set default property
			rect.sfProp = {
				id : rect.id,
				taskName : 'New task',
				workload : '',
				worker : '',
				location : '',
				comment : '',
			};
		} else if ($('#circle_btn').hasClass('active')) {
			// add circle when clicked
			var circle = new joint.shapes.basic.Circle({
				position : {
					x : x,
					y : y
				},
				size : {
					width : 150,
					height : 60
				},
				attrs : {
					circle : {
						fill : 'blue',
					},
					text : {
						text : 'New task',
						fill : 'white'
					}
				},
			});
			graph.addCell(circle);

			// set default property
			circle.sfProp = {
				id : circle.id,
				taskName : 'New task',
				workload : '',
				worker : '',
				location : '',
				comment : '',
			};
		} else if ($('#edge_btn').hasClass('active')) {
			// add link when clicked
			var link = new joint.dia.Link({
				source : {
					x : x - 100,
					y : y
				},
				target : {
					x : x + 100,
					y : y
				},
				attrs : {
					'.connection' : {
						'stroke-width' : 3,
						stroke : 'black'
					},
					'.marker-target' : {
						stroke : 'black',
						fill : 'black',
						d : 'M 12 0 L 0 6 L 12 12 z'
					},
				}
			});
			graph.addCell(link);
		}
	});

	var paperScroller = new joint.ui.PaperScroller({
		autoResizePaper : true,
		padding : 50,
		paper : paper
	});

	// Initiate panning when the user grabs the blank area of the paper.
	paper.on('blank:pointerdown', paperScroller.startPanning);

	paperScroller.$el.css({
		width : "100%",
		height : "100%"
	});

	$app.append(paperScroller.render().el);

	// Example of centering the paper.
	paperScroller.center();

	// Toolbar buttons.
	$('#btn-center').on('click', _.bind(paperScroller.center, paperScroller));

	$('#btn-center-content').on('click',
			_.bind(paperScroller.centerContent, paperScroller));

	$('#btn-zoomin').on('click', function() {
		paperScroller.zoom(0.2, {
			max : 2
		});
	});
	$('#btn-zoomout').on('click', function() {
		paperScroller.zoom(-0.2, {
			min : 0.2
		});
	});
	$('#btn-zoomtofit').on('click', function() {
		paperScroller.zoomToFit({
			minScale : 0.2,
			maxScale : 2
		});
	});

	// show property icon when mouseovered
	paper.on('cell:pointerclick', function(cellView, evt, x, y) {

		console.log("show property icon when mouseovered");

		// change color
		var cell = cellView.model;

		if (isRect(selectedCell) || isCircle(selectedCell)) {
			unSelectCell(selectedCell);
		} else if (isLink(selectedCell)) {
			unSelectCell(selectedCell);
		}
		if (cell === selectedCell) {
			selectedCell = null;
		} else {
			selectedCell = cell;
			selectCell(selectedCell);
		}

		// show properties
		if (isRect(cell) || isCircle(cell)) {
			showSfProps(cell.sfProp);
			if (typeof showPresentation == 'function') {
				showPresentation(cell);
			}

			// var nodeId = cell.sfProp.id;
			var nodeUri = SF_NAME_SPACE + "node#" + cell.sfProp.id;
			var data = getDocumentList(sfProjectUri, nodeUri);
			$('#file_count').html(data.length + ' files');
		} else if (isLink(cell)) {
			if (typeof showPresentation == 'function') {
				showPresentation(cell);
			}
			$('.sf-prop-field').val('');
			$('#file_count').html('');
		}
	});

	// reflect properties modification
	$('.sf-prop-field').change(function() {
		if (isRect(selectedCell) || isCircle(selectedCell)) {
			updateSfProps(selectedCell);

			selectedCell.attr({
				text : {
					text : selectedCell.sfProp.taskName
				},
			});
		}
	});

	// reflect presentation information modification
	$('.presentation-field').change(function() {
		updatePresentation(selectedCell);
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

		if (window.confirm('Are you sure? All RDF triples will be deleted.')) {
			graph.clear();
			selectedCell = null;
		} else {
			window.alert('Cancelled.');
		}

	});

	// auto layout
	$('#layout_btn').click(function() {
		$("#load-data").append('<img src="resources/img/gif-load.gif"/>');
		var elements = graph.getElements();
		var links = graph.getLinks();
		var cells = elements.concat(links);
		graph.clear();
		graph.addCells(cells);
		joint.layout.DirectedGraph.layout(graph, {
			setLinkVertices : false,
		});
		$("#load-data").empty();

		// zoom to fit
		paperScroller.zoomToFit({
			minScale : 0.2,
			maxScale : 2
		});
	});

	// import
	$('#import_btn').click(function() {
		importRDF(graph);

		// loading-iconの削除
		$("#load-data").empty();

		// 初期読み込み（空）でなければ
		if (graph.attributes.cells.length != 0) {
			// zoom to fit
			paperScroller.zoomToFit({
				minScale : 0.2,
				maxScale : 2
			});
		}
	});

	// export
	$('#export_btn').click(function() {
		exportRDF(graph);
	});

	// file upload
	$('#file_upload_btn').click(function() {
		if (isRect(selectedCell) || isCircle(selectedCell)) {
			// $('#file_upload_input').click();
			showFileUploadPopUp();

		}
	});

	// ワークフローに関連するすべての文書を表示
	$('#file_list_all_btn').click(function() {
		var data = getDocumentList(sfProjectUri);
		showFileListPopUp(data);
	});

	// tooltip
	$('[data-toggle="tooltip"]').tooltip();

	// import project
	$('#import_btn').click();
});

// 選択解除
var clearSelect = function() {
	unSelectCell(selectedCell);
	selectedCell = null;
	$('.sf-prop-field').text('');
	$('file_count').html('');
};

// 指定したワークフローに関連する文書の表示
$('#file_list_btn').click(function() {
	if (isRect(selectedCell) || isCircle(selectedCell)) {
		var nodeId = selectedCell.id;
		var nodeUri = SF_NAME_SPACE + "node#" + nodeId;
		var data = getDocumentList(sfProjectUri, nodeUri);
		showFileListPopUp(data);
	}
});
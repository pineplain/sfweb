var showSfProps = function(prop) {
	$('#task_id').text(prop.id);
	$('#task_name').text(prop.taskName);
	$('#workload').text(prop.workload);
	$('#worker').text(prop.worker);
	$('#location').text(prop.location);
	$('#comment').text(prop.comment);
};

var updateSfProps = function(cell) {
	if (cell !== null) {
		cell.sfProp = {
			id : cell.id,
			type : cell.sfProp.type,
			taskName : $('#task_name').text(),
			workload : $('#workload').text(),
			worker : $('#worker').text(),
			location : $('#location').text(),
			comment : $('#comment').text(),
		};
		$("#doc-list").empty();
	}
};

// 選択解除
var clearSelect = function() {
	if (isRect(selectedCell) || isCircle(selectedCell)) {
		setCellColor(selectedCell, 'blue');
	} else if (isLink(selectedCell)) {
		setCellColor(selectedCell, 'black');
	}
	selectedCell = null;
	$('.sf-prop-field').text('');
	$('file_count').html('');
};

$(function() {

	/*
	 * // export - test $('#export_btn').click(function() { clearSelect();
	 *
	 * $("#load-data").append('<img src="resources/img/gif-load.gif"/>');
	 *
	 * var sfPropAry = $.map(graph.getElements(), function(val, idx) { return
	 * val.sfProp; });
	 *
	 * var workflowJSON = JSON.stringify(graph.toJSON()); var properties =
	 * JSON.stringify({ props : sfPropAry });
	 *
	 * console.log(sfPropAry); console.log(graph);
	 *
	 * var sfURI = prefixes.sf; var nodeURI = sfURI + "node#"; var linkURI =
	 * sfURI + "link#"; var projectURI = sfURI + "project#";
	 *
	 * var subs = new Array(); var pres = new Array(); var objs = new Array();
	 * var flgs = new Array(); // Property for (var i = 0; i < sfPropAry.length;
	 * i++) { var obj = sfPropAry[i]; var nodeId = obj.id; $.each(obj,
	 * function(k, v) { if (k != "type") { subs.push(nodeURI + nodeId);
	 * pres.push(sfURI + k); objs.push(v); flgs.push("true"); }
	 *
	 * });
	 *
	 * subs.push(nodeURI + nodeId); pres.push(sfURI + "prop");
	 * objs.push(JSON.stringify(sfPropAry)); flgs.push("true"); }
	 *
	 * console.log(objs); // Graph var models = graph.attributes.cells;
	 * console.log(models);
	 *
	 * });
	 */

	// 指定したワークフローに関連する文書の表示
	$('#file_list_btn').click(function() {
		if (isRect(selectedCell) || isCircle(selectedCell)) {
			var nodeId = $("#task_id").text();
			var nodeUri = SF_NAME_SPACE + "node#" + nodeId;
			var data = getDocumentList(sfProjectUri, nodeUri);
			showFileListPopUp(data);
		}
	});
});

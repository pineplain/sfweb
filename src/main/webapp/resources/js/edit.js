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
			id : cell.id,
			type : cell.sfProp.type,
			taskName : $('#task_name').val(),
			workload : $('#workload').val(),
			worker : $('#worker').val(),
			location : $('#location').val(),
			comment : $('#comment').val(),
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
	$('.sf-prop-field').val('');
	$('file_count').html('');
};

$(function() {

	// 指定したワークフローに関連する文書の表示
	$('#file_list_btn').click(function() {
		if (isRect(selectedCell) || isCircle(selectedCell)) {
			var nodeId = $("#task_id").val();
			var nodeUri = SF_NAME_SPACE + "node#" + nodeId;
			var data = getDocumentList(sfProjectUri, nodeUri);
			showFileListPopUp(data);
		}
	});
});

var showSfProps = function(prop) {
	$('#task_id').val(prop.id);
	$('#task_name').val(prop.taskName);
	$('#workload').val(prop.workload);
	$('#worker').val(prop.worker);
	$('#location').val(prop.location);
	$('#comment').val(prop.comment);
};

var showInfo = function(data){

	var attrs = data.attributes.attrs;

	//Fill Color
	var type;
	if(attrs.circle){
		type = attrs.circle;
	} else if(attrs.rect){
		type = attrs.rect;
	}

	var fill_color_type = type.fill;
	$("#fill_color_type").val(fill_color_type);

	var text = attrs.text;

	//Text Color
	var fill_color_text = text.fill;
	$("#fill_color_text").val(fill_color_text);

	//Font Size
	var fontSize = text["font-size"];
	$("#font_size").val(fontSize);

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

var updateInfo = function(cell) {
	if (cell !== null) {
		var attributes = cell.attributes;

		var attrs = attributes.attrs;

		var text = attrs.text;
		text.fill = $("#fill_color_text").val();
		text["font-size"] = $("#font_size").val();

		//---------------------------

		var type;
		if(attrs.circle){
			type = attrs.circle;
		} else if(attrs.rect){
			type = attrs.rect;
		}

		type.fill = $("#fill_color_type").val();
	}
};

// 選択解除
var clearSelect = function() {
	unSelectCell(selectedCell);
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

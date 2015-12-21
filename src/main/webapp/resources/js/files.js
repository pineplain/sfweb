/**
 * プロジェクトに関連するドキュメントの取得
 *
 * @param resourceUri
 * @param nodeUri
 * @returns
 */
function getDocumentList(resourceUri, nodeUri) {
	// ノード指定がない場合
	if (nodeUri == "http://sfweb.is.k.u-tokyo.ac.jp/node#") {
		nodeUri = null;
	}

	var query = 'SELECT DISTINCT * WHERE { ';
	query += '<' + resourceUri
			+ '> <http://sfweb.is.k.u-tokyo.ac.jp/child> ?nodeUri . ';
	query += '?s <http://sfweb.is.k.u-tokyo.ac.jp/relatedNode> ?nodeUri . ';
	if (nodeUri != null) { // ノードの指定がある場合
		query += 'filter (?nodeUri = <' + nodeUri + '> ) . ';
	}
	query += '?nodeUri <http://sfweb.is.k.u-tokyo.ac.jp/taskName> ?nodeName . ';
	query += '?s <http://purl.org/dc/elements/1.1/title> ?title . ';
	query += '?s <http://purl.org/dc/elements/1.1/date> ?date . ';
	query += '}';

	var result = null;

	$.ajax({
		type : 'POST',
		url : KASHIWADE_BASE_URL + 'sparql',
		data : {
			query : query,
		},
		async : false,
		success : function(data) {
			result = data.results.bindings;
		},
	});

	return result;
};

/**
 * ファイルリストポップアップの表示メソッド
 */
var showFileListPopUp = function(data) {

	// dataTablesのReset
	$("#fileTable").dataTable().fnDestroy();

	var tbody = $("#tbody");
	tbody.empty();

	for (var i = 0; i < data.length; i++) {
		var obj = data[i];

		// 表に挿入
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
		a.attr("href", KASHIWADE_BASE_URL + "common/metadata?resourceUri="
				+ encodeURIComponent(obj.s.value));
		a.attr("class", "btn btn-default")
		a.append("View Detail&nbsp;&raquo;");
	}

	$.magnificPopup.open({
		items : {
			src : $('#file-list')
		},
		type : 'inline'
	});

	$('#fileTable').DataTable({
		"iDisplayLength" : 50
	});
};

/**
 * ファイル登録ポップアップの表示メソッド
 */
var showFileUploadPopUp = function() {

	$.magnificPopup.open({
		items : {
			src : $('#file-upload')
		},
		type : 'inline'
	});
};

/**
 * ファイル登録メソッド
 */

function uploadFile() {
	var files = $('#file_upload_input')[0].files;

	var groupName = $("#group_name").val();

	$("#uploading-file").append('<img src="resources/img/gif-load.gif">');

	// 各ファイルに対して
	for (var i = 0; i < files.length; i++) {
		var fd = new FormData();
		fd.append("files", files[i]);

		fd.append('group', groupName);

		var fields = new Array();
		var values = new Array();
		var literalFlags = new Array();

		// NodeUriとドキュメントの紐づけ
		var nodeId = selectedCell.id;
		var nodeUri = SF_NAME_SPACE + "node#" + nodeId;// NodeUri --
		// SPARQL検索に変更したほうがよいか？
		fields.push(SF_NAME_SPACE + "relatedNode");
		values.push(nodeUri);
		literalFlags.push("false");

		fd.append('fields', fields);
		fd.append('values', values);
		fd.append('literalFlags', literalFlags);

		$.ajax({
			url : KASHIWADE_BASE_URL + 'resource/add',
			type : 'POST',
			data : fd,
			processData : false,
			contentType : false,
			dataType : 'json',
			async : false,

		});
	}

	$("#uploading-file").empty();

	var nodeUri = SF_NAME_SPACE + "node#" + selectedCell.sfProp.id;
	var data = getDocumentList(sfProjectUri, nodeUri);
	$('#file_count').html(data.length + ' files');

	// dialog
	$("#dialog-icon").attr('src', 'resources/img/completeIcon.png');
	$("#dialog-head").text("Uploaded.");
	$("#dialog-text").empty();
	for (var i = 0; i < files.length; i++) {
		$("#dialog-text").append((i + 1) + "：" + files[i].name);
		if (i != data.length - 1) {
			$("#dialog-text").append("<br>");
		}
	}

	alert(files.length + " file uploaded.");

	$.magnificPopup.open({
		items : {
			src : $('#dialog')
		},
		type : 'inline'
	});
}

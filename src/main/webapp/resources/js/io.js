// export
function exportRDF(graph) {
	clearSelect();

	$("#load-data").append('<img src="resources/img/gif-load.gif"/>');

	var sfPropAry = $.map(graph.getElements(), function(val, idx) {
		return val.sfProp;
	});
	var workflowJSON = JSON.stringify(graph.toJSON());
	var properties = JSON.stringify({
		props : sfPropAry
	});

	// Exportする配列
	var subs = new Array();
	var pres = new Array();
	var objs = new Array();
	var flgs = new Array();

	// ---------------------------------------

	var deletedUriArray = new Array();

	// 描画情報
	var array = graph.toJSON().cells;
	for (var i = 0; i < array.length; i++) {
		var obj = array[i];
		var id = obj.id;
		var uri;
		var attrs = obj.attrs;
		if (attrs.text) {// Node or Link
			var text = attrs.text.text;
			uri = prefixes.sf + "node#" + id;

			// 登録情報（Type）
			subs.push(uri);
			pres.push(prefixes.rdf + "type");
			objs.push(prefixes.kdclass + "Node");
			flgs.push("false");

		} else {
			uri = prefixes.sf + "link#" + id;

			// TargetNode
			var targetUri = prefixes.sf + "node#" + obj.target.id;
			subs.push(uri);
			pres.push(prefixes.sf + "target");
			objs.push(targetUri);
			flgs.push("false");

			// SourceNode
			var sourceUri = prefixes.sf + "node#" + obj.source.id;
			subs.push(uri);
			pres.push(prefixes.sf + "source");
			objs.push(sourceUri);
			flgs.push("false");

			// 登録情報（Type）
			subs.push(uri);
			pres.push(prefixes.rdf + "type");
			objs.push(prefixes.kdclass + "Link");
			flgs.push("false");
		}

		// 登録情報（ID）
		subs.push(uri);
		pres.push(prefixes.sf + "id");
		objs.push(id);
		flgs.push("true");

		// 登録情報（描画JSON）
		subs.push(uri);
		pres.push(prefixes.sf + "graphJson");
		objs.push(JSON.stringify(obj));
		flgs.push("true");

		// 削除するURI（NodeとLinkのURI）
		deletedUriArray.push(uri);

		// 登録情報（Projectに関するChild）
		subs.push(sfProjectUri);
		pres.push(prefixes.sf + "child");
		objs.push(uri);
		flgs.push("false");
	}

	// Properties情報
	for (var i = 0; i < sfPropAry.length; i++) {
		var obj = sfPropAry[i];
		var uri = prefixes.sf + "node#" + obj.id;
		$.each(obj, function(key, value) {
			if (key != prefixes.rdf + "type") {// Typeでなければ
				subs.push(uri);
				pres.push(prefixes.sf + key);
				objs.push(value);
				flgs.push("true");
			}

		});

	}

	var date = getDateStr(new Date());

	// プロジェクトの更新者, 更新日時
	subs.push(sfProjectUri);
	pres.push(prefixes.sf + "updated");
	objs.push(date);
	flgs.push("true");

	subs.push(sfProjectUri);
	pres.push(prefixes.sf + "updatedBy");
	objs.push($("#username").text().trim());
	flgs.push("true");

	// プロジェクトに関連するNode, Linkの削除
	$.ajax({
		type : 'POST',
		url : KASHIWADE_BASE_URL + 'metadata/delete',
		aync : false,
		data : {
			subject : sfProjectUri,
			predicate : "http://sfweb.is.k.u-tokyo.ac.jp/child"
		},
		success : function(data) {
			// プロジェクトの更新者, 更新日時の変更
			$.ajax({
				type : 'POST',
				url : KASHIWADE_BASE_URL + 'metadata/deletes',
				aync : false,
				data : {
					subject : [ sfProjectUri, sfProjectUri ],
					predicate : [ prefixes.sf + "updated",
							prefixes.sf + "updatedBy" ]
				},
				traditional : true, // Important
				success : function(data) {
					// Node, Linkのそれぞれの情報の削除
					$.ajax({
						type : 'POST',
						url : KASHIWADE_BASE_URL + 'metadata/deletes',
						aync : false,
						data : {
							subject : deletedUriArray
						},
						traditional : true, // Important
						success : function(data) {

							// RDFトリプルの追加処理
							$.ajax({
								type : 'POST',
								url : KASHIWADE_BASE_URL + 'metadata/adds',
								aync : false,
								data : {
									subject : subs,
									predicate : pres,
									object : objs,
									literalFlag : flgs,
								},
								traditional : true, // Important
								success : function(data) {

									// dialog
									$("#dialog-icon").attr('src',
											'resources/img/completeIcon.png');
									$("#dialog-head").text('Saved.');
									$("#dialog-text").empty();
									$("#dialog-text").append(
											'<label>Date：</label>' + date
													+ '<br>');
									$("#dialog-text").append(
											'<label>Project ID：</label><br>'
													+ sfProjectUri);
									$.magnificPopup.open({
										items : {
											src : $('#dialog')
										},
										type : 'inline'
									});
								},
								error : function(data) {
									// dialog
									$("#dialog-icon").attr('src',
											'resources/img/errorIcon.png');
									$("#dialog-head").text('Error.');
									$("#dialog-text").text(data.statusText);
									$.magnificPopup.open({
										items : {
											src : $('#dialog')
										},
										type : 'inline'
									});
								},
								complete : function() {
									$("#load-data").empty();
								}
							});

						},
						complete : function() {
							$("#load-data").empty();
						}
					});
				}
			});
		}
	});
};

/**
 * 日付をフォーマットするメソッド
 *
 * @param dd
 * @returns {String}
 */
function getDateStr(dd) {
	yy = dd.getYear();
	mm = dd.getMonth() + 1;
	dd = dd.getDate();
	if (yy < 2000) {
		yy += 1900;
	}
	if (mm < 10) {
		mm = "0" + mm;
	}
	if (dd < 10) {
		dd = "0" + dd;
	}
	return yy + "-" + mm + "-" + dd;
}

// import
function importRDF(graph) {

	var initFlag = true;// プロジェクト名を登録するためのフラグ

	clearSelect();

	$("#load-data").append('<img src="resources/img/gif-load.gif"/>');

	var query = 'SELECT DISTINCT * WHERE { ';
	query += '<' + sfProjectUri + '> ?v ?o . ';// Projectに関するRDFトリプル
	query += 'OPTIONAL { ?o ?v2 ?o2 } ';// NodeやLinkeに関するRDFトリプル
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

			// 検索結果をURI毎に整形する
			var resultJson = new Object();

			for (var i = 0; i < result.length; i++) {
				var obj = result[i];

				var v = obj.v.value;
				var o = obj.o.value;

				// プロジェクト名の設定
				if (v == prefixes.sf + "projectName" && initFlag) {
					sfProjectName = o;
					$('#project_name').text(sfProjectName);
					initFlag = false;
				}

				// 整形処理部分
				if (obj.v2) {
					var v2 = obj.v2.value;
					var o2 = obj.o2.value;

					if (!resultJson[o]) {
						resultJson[o] = new Object();
					}

					resultJson[o][v2] = o2;
				}
			}

			// create graph
			var graphJson = {
				'cells' : []
			};

			var propsJson = {
				'props' : []
			};

			// 整形した値を描画情報, Property情報に修正
			$.each(resultJson, function(uri, obj) {

				var prop = new Object();

				var cellFlag = false; // Node or Link type

				$.each(obj, function(key, value) {

					// 描画情報を含む場合
					if (key == prefixes.sf + "graphJson") {
						graphJson.cells.push($.parseJSON(value));
					} else if (key == prefixes.rdf + "type") {
						if (value == prefixes.kdclass + "Node"
								|| value == prefixes.kdclass + "Link") {
							cellFlag = true
						}
					} else {
						prop[key.replace(prefixes.sf, "")] = value;
					}

				});

				if (cellFlag) {
					propsJson.props.push(prop);
				}

			});

			graph.fromJSON(graphJson);

			importSfPropFromJSON(graph, propsJson);

			console.log('Import succeeded');

		},
		error : function(data) {
			alert(data.statusText);
		}
	});

};
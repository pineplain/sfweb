<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>
<%@ page session="false"%>
<jsp:directive.page contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" />

<!DOCTYPE html>
<html lang="en">

<head>
<link rel="shortcut icon"
	href="<c:url value='/resources/img/favicon.ico' />">
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="">
<meta name="author" content="">

<title>Workflow List</title>

<!-- Bootstrap Core CSS -->
<link rel="stylesheet"
	href="<c:url value='/resources/thirdparty/bootstrap/css/bootstrap.min.css' />">
<link
	href="<c:url value='/resources/thirdparty/Magnific-Popup/magnific-popup.css' />"
	rel="stylesheet">
<link
	href="<c:url value='/resources/thirdparty/dataTables/css/jquery.dataTables.css' />"
	rel="stylesheet">
<link href="<c:url value='/resources/css/main.css' />" rel="stylesheet">
</head>

<body id="page-top">

	<c:import url="header.jsp"></c:import>

	<section id="services">
		<div class="container">
			<div class="row">
				<div class="col-lg-12 text-center">
					<h2 class="section-heading">Workflow List</h2>
					<hr class="primary">
				</div>
			</div>
		</div>

		<div id="loading" class="text-center">
			<img src="resources/img/gif-load.gif">
		</div>

		<div class="container">

			<sec:authorize ifAnyGranted="ROLE_ADMIN">
				<p>
					<a class="popup-with-form btn btn-primary" href="#test-form"><span
						class="glyphicon glyphicon-plus"></span> Add New Flow</a>
				</p>

				<hr>
			</sec:authorize>

			<table class="table table-striped table-hover" id="table">
				<thead id="thead">
					<tr>
						<th>Name</th>
						<th>Creator</th>
						<th>Created Date</th>
						<th>Updator</th>
						<th>Updated Date</th>
						<th>Detail</th>
						<th>KASHIWADE</th>
						<sec:authorize ifAnyGranted="ROLE_ADMIN">
							<th>Delete</th>
						</sec:authorize>
					</tr>
				</thead>
				<tbody id="tbody">
				</tbody>
			</table>
		</div>
	</section>

	<div id="test-form" class="mfp-hide white-popup-block">
		<div class="page-header">
			<h3>New Flow</h3>
		</div>

		<div class="form-group">
			<label>Name</label>
			<textarea class="form-control" id="name"></textarea>
		</div>

		<div class="form-group">
			<label>Creator</label> <input type="text" class="form-control"
				id="creator" readonly
				value="<sec:authentication
                            property="principal.username" />">
		</div>

		<button type="button" onclick="upload()" class="btn btn-default">
			<span class="glyphicon glyphicon-plus"></span> Submit
		</button>
	</div>

	<c:import url="footer.jsp"></c:import>

	<!-- jQuery -->
	<script src="resources/thirdparty/jquery/jquery-1.11.1.min.js"></script>

	<!-- Bootstrap Core JavaScript -->
	<script src="resources/thirdparty/bootstrap/js/bootstrap.min.js"></script>

	<script type="text/javascript"
		src="<c:url value='/resources/thirdparty/Magnific-Popup/jquery.magnific-popup.min.js' />"></script>

	<script type="text/javascript"
		src="<c:url value='/resources/thirdparty/dataTables/js/jquery.dataTables.js' />"></script>

	<script type="text/javascript"
		src="<c:url value='/resources/setting.js' />"></script>

	<script type="text/javascript">
		var result;

		jQuery(document).ready(function() {
			jQuery.ajaxSetup({
				cache : false
			});

			getWorkflowList();

			$('.popup-with-form').magnificPopup({
				type : 'inline',
				preloader : false,
				focus : '#name',

				// When elemened is focused, some mobile browsers in some cases zoom in
				// It looks not nice, so we disable it:
				callbacks : {
					beforeOpen : function() {
						if ($(window).width() < 700) {
							this.st.focus = false;
						} else {
							this.st.focus = '#name';
						}
					}
				}
			});

		});

		//既存ワークフローの取得
		function getWorkflowList() {

			//権限の取得
			var principal = '<sec:authentication property="principal" />';
			var auth = principal.split("ROLE")[1];

			var query = getPrefixes();
			query += " select distinct * where { ";
			query += " ?s rdf:type kdclass:project . ";
			query += " ?s sf:projectName ?name . ";
			query += " ?s sf:creator ?creator . ";
			query += " ?s sf:created ?created . ";
			query += " ?s sf:updatedBy ?updatedBy . ";
			query += " ?s sf:updated ?updated . ";
			query += " ?s rdf:type kdclass:project . ";
			query += " } ";

			var tbody = $("#tbody");

			$.ajax({
				type : "POST",
				url : KASHIWADE_BASE_URL + "sparql",
				data : {
					query : query,
				},
				success : function(data) {

					result = data.results.bindings;

					for (var i = 0; i < result.length; i++) {
						var obj = result[i];

						var tr = $("<tr>");
						tbody.append(tr);

						var td = $("<td>");
						tr.append(td);
						td.append(obj.name.value);

						td = $("<td>");
						tr.append(td);
						td.append(obj.creator.value);

						td = $("<td>");
						tr.append(td);
						td.append(obj.created.value);

						td = $("<td>");
						tr.append(td);
						td.append(obj.updatedBy.value);

						td = $("<td>");
						tr.append(td);
						td.append(obj.updated.value);

						td = $("<td>");
						tr.append(td);

						var a = $("<a>");
						td.append(a);
						a.attr("href", "view?resourceUri="
								+ encodeURIComponent(obj.s.value));
						a.attr("class", "btn btn-primary");
						a.append("View&nbsp;&raquo;");

						td = $("<td>");
						tr.append(td);

						var a = $("<a>");
						td.append(a);
						a.attr("href", KASHIWADE_BASE_URL
								+ "common/metadata?resourceUri="
								+ encodeURIComponent(obj.s.value));
						a.attr("class", "btn btn-default");
						a.append("View&nbsp;&raquo;");

						//削除機能
						if (auth.indexOf("ADMIN") != -1) {
							td = $("<td>");
							tr.append(td);

							var a = $("<button>");
							td.append(a);
							a.attr("href", KASHIWADE_BASE_URL
									+ "common/metadata?resourceUri="
									+ encodeURIComponent(obj.s.value));
							a.attr("class", "btn btn-danger");

							var span = $("<span>");
							a.append(span);
							span.attr("class", "glyphicon glyphicon-remove");

							a.attr("onclick", "deleteRow('" + i + "')");
							a.append(" Delete");
						}

					}

					// DataTable
					var table = $('#table').DataTable({
						"iDisplayLength" : 50,
						"sorting" : [ [ 4, "desc" ] ]
					//更新日時でソート
					});
				},
				error : function(data) {
					alert(data.statusText);
				},
				complete : function() {
					// #loading は、ローディングの画像（を囲む）要素名に置き換えてください。
					$("#loading").hide();
				}
			});
		}

		//新規フローの登録
		function upload() {

			var subs = new Array();
			var pres = new Array();
			var objs = new Array();
			var flgs = new Array();

			var dd = new Date();
			var id = dd.getTime();

			var dateStr = getDateStr(dd);

			var resourceUri = prefixes.sf + "project#" + id;
			//クラス
			subs.push(resourceUri);
			pres.push(prefixes.rdf + "type");
			objs.push(prefixes.kdclass + "project");
			flgs.push("false");

			//ID
			subs.push(resourceUri);
			pres.push(prefixes.sf + "projectId");
			objs.push(id);
			flgs.push("true");

			//Name
			subs.push(resourceUri);
			pres.push(prefixes.sf + "projectName");
			objs.push($("#name").val());
			flgs.push("true");

			//Creator
			subs.push(resourceUri);
			pres.push(prefixes.sf + "creator");
			objs.push($("#creator").val());
			flgs.push("true");

			//Updator
			subs.push(resourceUri);
			pres.push(prefixes.sf + "updatedBy");
			objs.push($("#creator").val());
			flgs.push("true");

			//Created Date
			subs.push(resourceUri);
			pres.push(prefixes.sf + "created");
			objs.push(dateStr);
			flgs.push("true");

			//Updated Date
			subs.push(resourceUri);
			pres.push(prefixes.sf + "updated");
			objs.push(dateStr);
			flgs.push("true");

			$.ajax({
				type : "POST",
				url : KASHIWADE_BASE_URL + "metadata/adds",
				async : false,
				data : {
					subject : subs,
					predicate : pres,
					object : objs,
					literalFlag : flgs
				},
				traditional : true, //Important
				success : function(data) {

					alert(data);
					location.href = "edit?resourceUri="
							+ encodeURIComponent(resourceUri);

				},
				fail : function(data) {
					alert(data);
				}
			});

		}

		//日付をフォーマットするメソッド
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

		//delete project
		function deleteRow(data) {

			if (window.confirm('Are you sure？')) {

				var resourceUri = result[data].s.value;
				var query = 'SELECT DISTINCT * WHERE { ';
				query += '<' + resourceUri + '> ?v ?o . ';
				query += ' OPTIONAL { ?doc <'+prefixes.sf+'relatedNode> ?o . } ';
				query += '}';

				$
						.ajax({
							type : 'POST',
							url : KASHIWADE_BASE_URL + 'sparql',
							data : {
								query : query,
							},
							success : function(data) {
								var result = data.results.bindings;

								var subs = new Array();
								var docs = new Array();

								for (var i = 0; i < result.length; i++) {
									var obj = result[i];
									var o = obj.o.value;
									var oType = obj.o.type;
									if (oType != "literal"
											&& o != "http://kashiwade.org/2012/09/kd/class/project") {
										subs.push(o);
									}

									if (obj.doc) {
										docs.push(obj.doc.value);
									}
								}

								subs.push(resourceUri);

								//プロジェクトの削除
								$
										.ajax({
											type : 'POST',
											url : KASHIWADE_BASE_URL
													+ 'metadata/deletes',
											data : {
												subject : subs,
											},
											traditional : true,
											success : function(data) {

												//関連ドキュメントが存在する場合
												if (docs.length > 0) {
													var pres = new Array();
													for (var i = 0; i < docs.length; i++) {
														pres
																.push(prefixes.sf
																		+ "relatedNode");
													}

													//Nodeとファイルの関係削除
													$
															.ajax({
																type : 'POST',
																url : KASHIWADE_BASE_URL
																		+ 'metadata/deletes',
																data : {
																	subject : docs,
																	predicate : pres
																},
																traditional : true,
																success : function(
																		data) {

																}
															});
												} else {
													alert("Deleted.");
													location.reload();
												}

											}
										});

							},
						});

			}
			// 「OK」時の処理終了

			// 「キャンセル」時の処理開始
			else {

				window.alert('Cenceled.'); // 警告ダイアログを表示

			}
			// 「キャンセル」時の処理終了
		}
	</script>

</body>

</html>

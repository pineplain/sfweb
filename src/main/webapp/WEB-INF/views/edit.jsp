<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page session="false"%>
<jsp:directive.page contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" />
<html>

<head>
<title>ShareFast Web</title>
<meta name=viewport content="width=device-width, initial-scale=1">
<link rel="shortcut icon"
	href="<c:url value='/resources/img/favicon.ico' />">
<link rel="stylesheet"
	href="<c:url value='/resources/thirdparty/jointjs/css/joint.min.css' />">
<link rel="stylesheet"
	href="<c:url value='/resources/thirdparty/jointjs/css/paperScroller.css' />">
<link rel="stylesheet"
	href="<c:url value='/resources/thirdparty/bootstrap/css/bootstrap.min.css' />">
<link rel="stylesheet"
	href="<c:url value='/resources/thirdparty/font-awesome/css/font-awesome.min.css' />">
<link rel="stylesheet" href="<c:url value='/resources/css/main.css' />">
<link
	href="<c:url value='/resources/thirdparty/Magnific-Popup/magnific-popup.css' />"
	rel="stylesheet">
<link
	href="<c:url value='/resources/thirdparty/dataTables/css/jquery.dataTables.css' />"
	rel="stylesheet">
</head>

<body>

	<c:import url="header.jsp"></c:import>

	<div class="container">
		<div class="col-xs-12">
			<!-- project name -->
			<h3 class="page-header">
				<span id="project_name"></span>
			</h3>

			<!-- loading json -->
			<div id="load-data" class="text-center"></div>
		</div>
	</div>
	<div class="sf-container">

		<div class="row">
			<div class="col-md-9">
				<div id="tool_box">

					<!-- cell's addition tools -->
					<span class="btn-group" data-toggle="buttons"> <label
						id="mouse_btn" class="btn btn-default active"
						data-toggle="tooltip" data-placement="bottom" title="Mouse">
							<input type="radio" name="tools" autocomplete="off" checked>
							<i class="fa fa-mouse-pointer"></i>
					</label> <label id="rect_btn" class="btn btn-default" data-toggle="tooltip"
						data-placement="bottom" title="Rect"> <input type="radio"
							name="tools" autocomplete="off"> <i class="fa fa-square"></i>
					</label> <!-- <label id="circle_btn" class="btn btn-default" data-toggle="tooltip" data-placement="bottom" title="Circle">
                    <input type="radio" name="tools" autocomplete="off">
                    <i class="fa fa-circle"></i>
                </label> --> <label id="edge_btn"
						class="btn btn-default" data-toggle="tooltip"
						data-placement="bottom" title="Edge"> <input type="radio"
							name="tools" autocomplete="off"> <i
							class="fa fa-long-arrow-right"></i>
					</label>
					</span>



					<!--- cell's remove tools -->
					<span class="btn-group">
						<button id="remove_btn" type="button" class="btn btn-default"
							data-toggle="tooltip" data-placement="bottom" title="Remove">
							<i class="fa fa-minus-circle"></i>
						</button>
						<button id="clear_btn" type="button" class="btn btn-default"
							data-toggle="tooltip" data-placement="bottom" title="Clear">
							<i class="fa fa-times-circle"></i>
						</button>
					</span>

					<!--- fit / zoom -->
					<span class="btn-group">
						<button id="btn-zoomtofit" type="button" class="btn btn-default"
							data-toggle="tooltip" data-placement="bottom" title="Zoom to fit">
							<i class="fa fa-align-center"></i>
						</button>
						<button id="btn-zoomin" type="button" class="btn btn-default"
							data-toggle="tooltip" data-placement="bottom" title="Zoom in">
							<i class="fa fa-search-plus"></i>
						</button>
						<button id="btn-zoomout" type="button" class="btn btn-default"
							data-toggle="tooltip" data-placement="bottom" title="Zoom out">
							<i class="fa fa-search-minus"></i>
						</button>
					</span>

					<!--- layout -->
					<span class="btn-group">
						<button id="layout_btn" type="button" class="btn btn-default"
							data-toggle="tooltip" data-placement="bottom" title="Layout">
							<i class="fa fa-sort-amount-asc"></i>
						</button> <!-- <button id="center_btn" type="button" class="btn btn-default" data-toggle="tooltip" data-placement="bottom" title="Center"><i class="fa fa-dot-circle-o"></i></button> -->
					</span>

					<!--- all files -->
					<span class="btn-group">
						<button id="file_list_all_btn" type="button"
							class="btn btn-default" data-toggle="tooltip"
							data-placement="bottom" title="All files">
							<i class="fa fa-files-o"></i>
						</button>
					</span>

					<!-- import / export -->
					<span class="btn-group">
						<button id="import_btn" type="button" class="btn btn-default"
							data-toggle="tooltip" data-placement="bottom" title="Import">
							<i class="fa fa-download"></i>
						</button>
						<button id="export_btn" type="button" class="btn btn-default"
							data-toggle="tooltip" data-placement="bottom" title="Export">
							<i class="fa fa-upload"></i>
						</button>
					</span>

					<!-- center -->
					<span class="btn-group">
						<button id="btn-center" type="button" class="btn btn-default"
							data-toggle="tooltip" data-placement="bottom" title="Center">
							<i class="fa fa-align-center"></i>
						</button>
						<button id="btn-center-content" type="button"
							class="btn btn-default" data-toggle="tooltip"
							data-placement="bottom" title="Center content">
							<i class="fa fa-align-center"></i>
						</button>
					</span>

					<!-- link to kashiwade -->
					<span class="btn-group"> <a id="link_to_kashiwade"
						type="button" class="btn btn-default" data-toggle="tooltip"
						data-placement="bottom" title="View on KASHIWADE"><i
							class="fa fa-list-alt"></i></a>
					</span>
				</div>

				<!-- graph -->
				<div id="holder"></div>
			</div>


			<div class="col-md-3">
				<!-- properties -->
				<h4>Properties</h4>
				<table class="table table-hover">
					<thead>
						<tr>
							<th>Key</th>
							<th>Value</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>Task id</td>
							<td><textarea id="task_id" readonly
									class="sf-prop-field form-control"></textarea></td>
						</tr>
						<tr>
							<td>Task name</td>
							<td><textarea id="task_name"
									class="sf-prop-field form-control"></textarea></td>
						</tr>
						<tr>
							<td>Workload</td>
							<td><textarea id="workload"
									class="sf-prop-field form-control"></textarea></td>
						</tr>
						<tr>
							<td>Worker</td>
							<td><textarea id="worker" class="sf-prop-field form-control"></textarea></td>
						</tr>
						<tr>
							<td>Location</td>
							<td><textarea id="location"
									class="sf-prop-field form-control"></textarea></td>
						</tr>
						<tr>
							<td>Comment</td>
							<td><textarea id="comment"
									class="sf-prop-field form-control"></textarea></td>
						</tr>
						<tr>
							<td>Files</td>
							<td>
								<p id="file_count"></p> <span class="btn-group">
									<button id="file_list_btn" type="button"
										class="btn btn-default" data-toggle="tooltip"
										data-placement="bottom" title="List files">
										<i class="fa fa-list-alt"></i>
									</button>
									<button id="file_upload_btn" type="button"
										class="btn btn-default" data-toggle="tooltip"
										data-placement="bottom" title="Upload files">
										<i class="fa fa-upload"></i>
									</button>
							</span>
								<form id="file_upload_form" method="POST"
									enctype="multipart/form-data">
									<input id="file_upload_input" type="file" name="files[]"
										style="display: none;" multiple>
								</form>
								<p class="text-center" id="uploading-file"></p>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>

	<div id="file-list" class="mfp-hide white-popup-block">
		<div class="page-header">
			<h3>File List</h3>
		</div>

		<table class="table table-striped table-hover" id="fileTable">
			<thead id="thead">
				<tr>
					<th>File Name</th>
					<th>Date</th>
					<th>Related Task</th>
					<th></th>
				</tr>
			</thead>
			<tbody id="tbody"></tbody>
		</table>
	</div>

	<div id="dialog" class="mfp-hide white-popup-block">
		<div class="row">
			<div class="col-xs-6">
				<img id="dialog-icon" style="width: 100%;" />
			</div>
			<div class="col-xs-6">
				<h3 class="page-header" id="dialog-head"></h3>
				<p id="dialog-text"></p>
			</div>

		</div>
	</div>

	<c:import url="footer.jsp"></c:import>

	<span id="project_uri" style="display: none;">${resourceUri}</span>

	<script
		src="<c:url value='/resources/thirdparty/jointjs/js/joint.all.min.js' />"></script>
	<script
		src="<c:url value='/resources/thirdparty/jointjs/js/joint.layout.DirectedGraph.min.js' />"></script>
	<script
		src="<c:url value='/resources/thirdparty/bootstrap/js/bootstrap.min.js' />"></script>
	<!-- <script src="<c:url value='/resources/js/zoom.js' />"></script> -->
	<script type="text/javascript"
		src="<c:url value='/resources/js/uri.js' />"></script>
	<script src="<c:url value='/resources/js/common.js' />"></script>
	<script src="<c:url value='/resources/js/edit.js' />"></script>
	<script type="text/javascript"
		src="<c:url value='/resources/thirdparty/Magnific-Popup/jquery.magnific-popup.min.js' />"></script>
	<script type="text/javascript"
		src="<c:url value='/resources/thirdparty/dataTables/js/jquery.dataTables.js' />"></script>
	<script type="text/javascript"
		src="<c:url value='/resources/thirdparty/autoSize/jquery.autosize-min.js' />"></script>
</body>

</html>

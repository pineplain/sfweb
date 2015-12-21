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
<link rel="stylesheet"
	href="<c:url value='/resources/thirdparty/bootstrap-toggle/css/bootstrap-toggle.min.css' />">
<link rel="stylesheet"
	href="<c:url value='/resources/thirdparty/jquery-ui-1.11.4/jquery-ui.min.css' />">
<link rel="stylesheet"
	href="<c:url value='/resources/thirdparty/colorpicker/css/colorpicker.css' />">


<style>
<!--
#colorSelector {
	position: relative;
	width: 36px;
	height: 36px;
	background:
		url( "<c:url value='/resources/thirdparty/colorpicker/images/select.png' />" );
}

#typeSelector {
	position: relative;
	width: 36px;
	height: 36px;
	background:
		url( "<c:url value='/resources/thirdparty/colorpicker/images/select.png' />" );
}

#colorSelector div {
	position: absolute;
	top: 3px;
	left: 3px;
	width: 30px;
	height: 30px;
	background:
		url( "<c:url value='/resources/thirdparty/colorpicker/images/select.png' />" );
}

#typeSelector div {
	position: absolute;
	top: 3px;
	left: 3px;
	width: 30px;
	height: 30px;
	background:
		url( "<c:url value='/resources/thirdparty/colorpicker/images/select.png' />" );
}
-->
</style>

</head>

<body>

	<c:import url="header.jsp"></c:import>

	<div class="container">
		<!-- project name -->
		<h3 class="page-header">
			<small>Project Name：</small>&nbsp;<span id="project_name"></span>
		</h3>

		<!-- loading json -->
		<div id="load-data" class="text-center"></div>
	</div>
	<div class="sf-container">

		<div class="row">
			<div class="col-md-9">

				<div id="tool_box" class="panel panel-default">
					<div class="panel-body">

						<!-- cell's addition tools -->
						<span class="btn-group" data-toggle="buttons"> <label
							id="mouse_btn" class="btn btn-default" data-toggle="tooltip"
							data-placement="bottom" title="Mouse"> <input
								type="radio" name="tools" autocomplete="off" checked> <i
								class="fa fa-mouse-pointer"></i>
						</label> <label id="rect_btn" class="btn btn-default"
							data-toggle="tooltip" data-placement="bottom" title="Rect">
								<input type="radio" name="tools" autocomplete="off"> <i
								class="fa fa-square"></i>
						</label> <label id="circle_btn" class="btn btn-default"
							data-toggle="tooltip" data-placement="bottom" title="Circle">
								<input type="radio" name="tools" autocomplete="off"> <i
								class="fa fa-circle"></i>
						</label> <label id="edge_btn" class="btn btn-default"
							data-toggle="tooltip" data-placement="bottom" title="Edge">
								<input type="radio" name="tools" autocomplete="off"> <i
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
								data-toggle="tooltip" data-placement="bottom" title="Delete all">
								<i class="fa fa-times-circle"></i>
							</button>
						</span>

						<!--- fit / zoom -->
						<span class="btn-group">
							<button id="btn-zoomtofit" type="button" class="btn btn-default"
								data-toggle="tooltip" data-placement="bottom"
								title="Zoom to fit">
								<i class="fa fa-align-center"></i>
							</button>
							<button id="layout_btn" type="button" class="btn btn-default"
								data-toggle="tooltip" data-placement="bottom" title="Layout">
								<i class="fa fa-sort-amount-asc"></i>
							</button> <!-- <button id="center_btn" type="button" class="btn btn-default" data-toggle="tooltip" data-placement="bottom" title="Center"><i class="fa fa-dot-circle-o"></i></button> -->

							<button id="btn-zoomin" type="button" class="btn btn-default"
								data-toggle="tooltip" data-placement="bottom" title="Zoom in">
								<i class="fa fa-search-plus"></i>
							</button>
							<button id="btn-zoomout" type="button" class="btn btn-default"
								data-toggle="tooltip" data-placement="bottom" title="Zoom out">
								<i class="fa fa-search-minus"></i>
							</button>
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
								data-toggle="tooltip" data-placement="bottom" title="Reload">
								<i class="fa fa-refresh"></i>
							</button>
							<button id="export_btn" type="button" class="btn btn-default"
								data-toggle="tooltip" data-placement="bottom" title="Save">
								<i class="fa fa-save"></i>
							</button>
						</span>


						<!-- view -->
						<span class="btn-group"> <a id="link_to_view" type="button"
							class="btn btn-default" data-toggle="tooltip"
							data-placement="bottom" title="View mode"><i
								class="fa fa-eye"></i></a>
						</span>

						<!-- link to kashiwade -->
						<span class="btn-group"> <a id="link_to_kashiwade"
							type="button" class="btn btn-default" data-toggle="tooltip"
							data-placement="bottom" title="View on KASHIWADE"><i
								class="fa fa-list-alt"></i></a>
						</span>
					</div>

				</div>

				<!-- graph -->
				<div id="holder"></div>
			</div>


			<div class="col-md-3">
				<div class="panel panel-default">
					<div class="panel-body">
						<ul id="resourceNarrowTabs" class="nav nav-tabs">
							<li class="active"><a href="#property" data-toggle="tab">Properties</a>
							</li>
							<li><a href="#presentation" data-toggle="tab">Presentation</a></li>
						</ul>

						<div id="resourceNarrowContents" class="tab-content">

							<div class="tab-pane in active" id="property">
								<br>
								<table class="table table-hover">
									<thead>
										<tr>
											<th>Key</th>
											<th>Value</th>
										</tr>
									</thead>
									<tbody>
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
											<td><textarea id="worker"
													class="sf-prop-field form-control"></textarea></td>
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
												<p id="file_count"></p>
												<p>
													<span class="btn-group">
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
												</p>

											</td>
										</tr>
									</tbody>
								</table>
							</div>

							<div class="tab-pane" id="presentation">
								<br>
								<div>

									<div id="presentation-node">

										<div class="form-group">
											<label>Font size&nbsp;:&nbsp; </label><span
												id="jquery-ui-slider-value" class="presentation-field"></span>&nbsp;px
											<div id="jquery-ui-slider" id="font_size"
												class="form-control"></div>
										</div>

										<div class="form-group">
											<label>Text color</label>
											<div id="colorSelector">
												<div style="background-color: #ffffffff"></div>
											</div>
										</div>

										<div class="form-group">
											<label>Fill color</label>
											<div id="typeSelector">
												<div style="background-color: #ffffffff"></div>
											</div>
										</div>

									</div>

									<div id="presentation-link">

										<div class="form-group">
											<label>strokedash array</label> <select id="dash"
												class="form-control presentation-field">
												<option>0</option>
												<option>1</option>
												<option>5,5</option>
												<option>5,10</option>
												<option>10,5</option>
												<option>5,1</option>
												<option>15,10,5,10,15</option>
											</select>
										</div>

										<div class="form-group">
											<label>smooth</label>
											<p>
												<input id="smooth" type="checkbox" data-toggle="toggle"
													class="form-control presentation-field">
											</p>
										</div>

									</div>
								</div>
							</div>

						</div>


					</div>

				</div>
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

	<div id="file-upload" class="mfp-hide white-popup-block">
		<div class="page-header">
			<h3>File Upload</h3>
		</div>

		<div class="form-group">
			<label>File input</label> <input type="file" id="file_upload_input"
				multiple>
		</div>

		<div class="form-group">
			<label>Group Name</label> <input type="text" class="form-control"
				id="group_name">
		</div>

		<button type="button" class="btn btn-primary" onclick="uploadFile()">
			<span class="glyphicon glyphicon-plus"></span> Uplaod
		</button>
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
		src="<c:url value='/resources/setting.js' />"></script>
	<script type="text/javascript"
		src="<c:url value='/resources/thirdparty/Magnific-Popup/jquery.magnific-popup.min.js' />"></script>
	<script type="text/javascript"
		src="<c:url value='/resources/thirdparty/dataTables/js/jquery.dataTables.js' />"></script>
	<script type="text/javascript"
		src="<c:url value='/resources/thirdparty/autoSize/jquery.autosize-min.js' />"></script>
	<script type="text/javascript"
		src="<c:url value='/resources/thirdparty/bootstrap-toggle/js/bootstrap-toggle.min.js' />"></script>
	<script type="text/javascript"
		src="<c:url value='/resources/thirdparty/jquery-ui-1.11.4/jquery-ui.min.js' />"></script>
	<script type="text/javascript"
		src="<c:url value='/resources/thirdparty/colorpicker/js/colorpicker.js' />"></script>
	<script src="<c:url value='/resources/js/common.js' />"></script>
	<script src="<c:url value='/resources/js/io.js' />"></script>
	<script src="<c:url value='/resources/js/files.js' />"></script>
	<script src="<c:url value='/resources/js/edit.js' />"></script>

</body>

</html>

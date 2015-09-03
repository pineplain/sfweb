<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page session="false"%>
<jsp:directive.page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" />
<html>

<head>
    <title>ShareFast Web</title>
    <meta name=viewport content="width=device-width, initial-scale=1">
    <link rel="shortcut icon" href="<c:url value='/resources/img/favicon.ico' />">
    <link rel="stylesheet" href="<c:url value='/resources/thirdparty/jointjs/css/joint.min.css' />">
    <link rel="stylesheet" href="<c:url value='/resources/thirdparty/bootstrap/css/bootstrap.min.css' />">
    <link rel="stylesheet" href="<c:url value='/resources/thirdparty/font-awesome/css/font-awesome.min.css' />">
    <link rel="stylesheet" href="<c:url value='/resources/css/main.css' />">
</head>

<body>

<c:import url="header.jsp"></c:import>

<div class="container">
    <div class="col-xs-12">
        <!-- project name -->
        <h3 class="page-header"><span id="project_name"></span></h3>
    </div>

    <div id="load-data" class="text-center"><img src="resources/img/gif-load.gif"></div>

    <div class="col-sm-12 col-md-9">
        <div id="tool_box">
            <!-- cell's addition tools -->
            <span class="btn-group" data-toggle="buttons">
                <label id="mouse_btn" class="btn btn-default active" data-toggle="tooltip" data-placement="bottom" title="Mouse">
                    <input type="radio" name="tools" autocomplete="off" checked>
                    <i class="fa fa-mouse-pointer"></i>
                </label>
                <label id="rect_btn" class="btn btn-default" data-toggle="tooltip" data-placement="bottom" title="Rect">
                    <input type="radio" name="tools" autocomplete="off">
                    <i class="fa fa-square"></i>
                </label>
                <label id="circle_btn" class="btn btn-default" data-toggle="tooltip" data-placement="bottom" title="Circle">
                    <input type="radio" name="tools" autocomplete="off">
                    <i class="fa fa-circle"></i>
                </label>
                <label id="edge_btn" class="btn btn-default" data-toggle="tooltip" data-placement="bottom" title="Edge">
                    <input type="radio" name="tools" autocomplete="off">
                    <i class="fa fa-long-arrow-right"></i>
                </label>
            </span>

            <!--- zoom -->
            <span class="btn-group">
                <button id="zoom_in_btn" type="button" class="btn btn-default" data-toggle="tooltip" data-placement="bottom" title="Zoom in"><i class="fa fa-search-plus"></i></button>
                <button id="zoom_out_btn" type="button" class="btn btn-default" data-toggle="tooltip" data-placement="bottom" title="Zoom out"><i class="fa fa-search-minus"></i></button>
            </span>

            <!--- cell's remove tools -->
            <span class="btn-group">
                <button id="remove_btn" type="button" class="btn btn-default" data-toggle="tooltip" data-placement="bottom" title="Remove"><i class="fa fa-minus-circle"></i></button>
                <button id="clear_btn" type="button" class="btn btn-default" data-toggle="tooltip" data-placement="bottom" title="Clear"><i class="fa fa-times-circle"></i></button>
            </span>

            <!--- layout -->
            <span class="btn-group">
                <button id="layout_btn" type="button" class="btn btn-default" data-toggle="tooltip" data-placement="bottom" title="Layout"><i class="fa fa-sort-amount-asc"></i></button>
                <!-- <button id="center_btn" type="button" class="btn btn-default" data-toggle="tooltip" data-placement="bottom" title="Center"><i class="fa fa-dot-circle-o"></i></button> -->
            </span>

            <!-- file io tools -->
            <span class="btn-group">
                <button id="import_btn" type="button" class="btn btn-default" data-toggle="tooltip" data-placement="bottom" title="Import"><i class="fa fa-download"></i></button>
                <button id="export_btn" type="button" class="btn btn-default" data-toggle="tooltip" data-placement="bottom" title="Export"><i class="fa fa-upload"></i></button>
            </span>
        </div>

        <!-- graph -->
        <div id="holder"></div>
    </div>

    <div class="col-sm-12 col-md-3">
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
                    <td><input readonly class="sf-prop-field form-control" id="task_id"/></td>
                </tr>
                <tr>
                    <td>Task name</td>
                    <td><input id="task_name" class="sf-prop-field form-control" type="text"></td>
                </tr>
                <tr>
                    <td>Workload</td>
                    <td><input id="workload" class="sf-prop-field form-control" type="text"></td>
                </tr>
                <tr>
                    <td>Worker</td>
                    <td><input id="worker" class="sf-prop-field form-control" type="text"></td>
                </tr>
                <tr>
                    <td>Location</td>
                    <td><input id="location" class="sf-prop-field form-control" type="text"></td>
                </tr>
                <tr>
                    <td>Comment</td>
                    <td><textarea id="comment" class="sf-prop-field form-control"></textarea></td>
                </tr>
            </tbody>
        </table>

        <!-- files -->
        <h4>Files</h4>
        <button id="file_upload_btn" type="button" class="btn btn-default" data-toggle="tooltip" data-placement="bottom" title="Upload files"><i class="fa fa-folder-open"></i></button>
        <form id="file_upload_form" method="POST" enctype="multipart/form-data">
            <input id="file_upload_input" type="file" name="files[]" style="display: none;" multiple>
        </form>

        <!-- files list -->
        <hr>
        <h4>Documents</h4>
        <ul id="doc-list" class="list-group"></ul>
        <!-- uploading file -->
        <div id="uploading-file" class="text-center"></div>
    </div>

</div>

<c:import url="footer.jsp"></c:import>

<span id="project_uri" style="display: none;">${resourceUri}</span>>

<script src="<c:url value='/resources/thirdparty/jointjs/js/joint.min.js' />"></script>
<script src="<c:url value='/resources/thirdparty/jointjs/js/joint.layout.DirectedGraph.min.js' />"></script>
<script src="<c:url value='/resources/thirdparty/bootstrap/js/bootstrap.min.js' />"></script>
<!-- <script src="<c:url value='/resources/js/zoom.js' />"></script> -->
<script src="<c:url value='/resources/js/main.js' />"></script>

</body>

</html>

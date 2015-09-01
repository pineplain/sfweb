<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page session="false"%>
<jsp:directive.page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" />
<html>

<head>
    <title>ShareFast Web</title>
    <meta name=viewport content="width=device-width, initial-scale=1">
    <link rel="shortcut icon" href="<c:url value='/resources/img/favicon.ico' />">
    <link rel="stylesheet" href="<c:url value='/resources/css/joint.min.css' />">
    <link rel="stylesheet" href="<c:url value='/resources/css/bootstrap.min.css' />">
    <link rel="stylesheet" href="<c:url value='/resources/css/main.css' />">
</head>

<body>

<c:import url="heading.jsp"></c:import>

<div class="container">
    <h1 class="page-header">ShareFast Web</h1>

    <div class="col-xs-12">
        <!-- cell's addition tools -->
        <span class="btn-group" data-toggle="buttons">
            <label id="mouse_btn" class="btn btn-default active" data-toggle="tooltip" data-placement="bottom" title="Mouse">
                <input type="radio" name="tools" autocomplete="off" checked>
                <span class="glyphicon glyphicon-hand-up"></span>
            </label>
            <label id="node_btn" class="btn btn-default" data-toggle="tooltip" data-placement="bottom" title="Node">
                <input type="radio" name="tools" autocomplete="off">
                <span class="glyphicon glyphicon-unchecked"></span>
            </label>
            <label id="edge_btn" class="btn btn-default" data-toggle="tooltip" data-placement="bottom" title="Edge">
                <input type="radio" name="tools" autocomplete="off">
                <span class="glyphicon glyphicon-arrow-right"></span>
            </label>
        </span>

        <!--- cell's remove tools -->
        <span class="btn-group">
            <button id="remove_btn" type="button" class="btn btn-default" data-toggle="tooltip" data-placement="bottom" title="Remove"><span class="glyphicon glyphicon-remove-circle"></span></button>
            <button id="clear_btn" type="button" class="btn btn-default" data-toggle="tooltip" data-placement="bottom" title="Clear"><span class="glyphicon glyphicon-remove"></span></button>
        </span>

        <!--- layout -->
        <span class="btn-group">
            <button id="layout_btn" type="button" class="btn btn-default" data-toggle="tooltip" data-placement="bottom" title="Layout"><span class="glyphicon glyphicon-sort"></span></button>
            <!-- <button id="center_btn" type="button" class="btn btn-default" data-toggle="tooltip" data-placement="bottom" title="Center"><span class="glyphicon glyphicon-record"></span></button> -->
        </span>

        <!-- file io tools -->
        <span class="btn-group">
            <button id="import_btn" type="button" class="btn btn-default" data-toggle="tooltip" data-placement="bottom" title="Import"><span class="glyphicon glyphicon-import"></span></button>
            <button id="export_btn" type="button" class="btn btn-default" data-toggle="tooltip" data-placement="bottom" title="Export"><span class="glyphicon glyphicon-export"></span></button>
        </span>
        <input id="import_file" type="file" style="display: none;">
    </div>

    <!-- graph -->
    <div class="col-sm-12 col-md-9">
        <div id="holder"></div>
    </div>

    <!-- properties -->
    <div class="col-sm-12 col-md-3">
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
                    <td>Task name</td>
                    <td><input id="task_name" class="sf-prop-field" type="text"></td>
                </tr>
                <tr>
                    <td>Workload</td>
                    <td><input id="workload" class="sf-prop-field" type="text"></td>
                </tr>
                <tr>
                    <td>Worker</td>
                    <td><input id="worker" class="sf-prop-field" type="text"></td>
                </tr>
                <tr>
                    <td>Location</td>
                    <td><input id="location" class="sf-prop-field" type="text"></td>
                </tr>
                <tr>
                    <td>Comment</td>
                    <td><textarea id="comment" class="sf-prop-field"></textarea></td>
                </tr>
            </tbody>
        </table>
    </div>
</div>

<c:import url="footer.jsp"></c:import>

<script src="<c:url value='/resources/js/joint.min.js' />"></script>
<script src="<c:url value='/resources/js/joint.layout.DirectedGraph.min.js' />"></script>
<script src="<c:url value='/resources/js/bootstrap.min.js' />"></script>
<script src="<c:url value='/resources/js/main.js' />"></script>

</body>

</html>

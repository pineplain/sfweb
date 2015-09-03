<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
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

<style>
.white-popup-block {
    background: #FFF;
    padding: 20px 30px;
    text-align: left;
    max-width: 650px;
    margin: 40px auto;
    position: relative
}
</style>


<!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
<!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.resources/creative/js/1.4.2/respond.min.js"></script>
    <![endif]-->

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

            <p>
                <a class="popup-with-form btn btn-primary" href="#test-form"><span
                    class="glyphicon glyphicon-plus"></span> Add New Flow</a>
            </p>

            <table class="table table-striped table-hover" id="table">
                <thead id="thead">
                    <tr>
                        <th>Name</th>
                        <th>Creator</th>
                        <th>Created Date</th>
                        <th>Updator</th>
                        <th>Updated Date</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody id="tbody">
                </tbody>
            </table>
        </div>
    </section>

    <div id="test-form" class="mfp-hide white-popup-block">
        <h1>New Flow</h1>

        <div class="form-group">
            <label>Name</label>
            <textarea class="form-control" id="name"></textarea>
        </div>

        <div class="form-group">
            <label>Creator</label>
            <textarea class="form-control" id="creator"></textarea>
        </div>

        <button type="button" onclick="upload()" class="btn btn-default">Submit</button>
    </div>

    <c:import url="footer.jsp"></c:import>

    <!-- jQuery -->
    <script src="resources/thirdparty/creative/js/jquery.js"></script>

    <!-- Bootstrap Core JavaScript -->
    <script src="resources/thirdparty/bootstrap/js/bootstrap.min.js"></script>

    <script type="text/javascript"
        src="<c:url value='/resources/thirdparty/Magnific-Popup/jquery.magnific-popup.min.js' />"></script>

    <script type="text/javascript"
        src="<c:url value='/resources/thirdparty/dataTables/js/jquery.dataTables.js' />"></script>

    <script type="text/javascript"
        src="<c:url value='/resources/js/uri.js' />"></script>

    <script type="text/javascript">
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
                url : endpoint + "/sparql",
                data : {
                    query : query,
                },
                success : function(data) {

                    var result = data.results.bindings;
                    console.log(result);

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
                        a.attr("href", "workflowEditor?resourceUri="
                                + encodeURIComponent(obj.s.value));
                        a.attr("class", "btn btn-default");
                        a.append("View Detail&nbsp;&raquo;");
                    }

                    // DataTable
                    var table = $('#table').DataTable({
                        "iDisplayLength" : 50,
                        "sorting" : [ [ 4, "desc" ] ]
                    //更新日時でソート
                    });

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

            var date = new Date();
            var id = date.getTime();

            var dateStr = date.toLocaleString();

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
                url : endpoint + "/metadata/adds",
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
                    location.href = "workflowEditor?resourceUri="
                            + encodeURIComponent(resourceUri);

                },
                fail : function(data) {
                    alert(data);
                }
            });

        }
    </script>

</body>

</html>

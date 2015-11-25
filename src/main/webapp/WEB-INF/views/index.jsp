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

<title>Index</title>

<!-- Bootstrap Core CSS -->
<link rel="stylesheet"
	href="<c:url value='/resources/thirdparty/bootstrap/css/bootstrap.min.css' />">

</head>

<body>

	<c:import url="header.jsp"></c:import>

	<div class="container">

		<div class="jumbotron">
			<h1>ShareFast Web</h1>
			<p>Application for document management system based on workflow</p>
			<p>
				<img class="img-thumbnail img-responsive"
					src="<c:url value='/resources/img/sf.png' />" />
			</p>
			<p class="text-center">
				<a class="btn btn-lg btn-primary" href="list" role="button">View
					Workflow List &raquo;</a>
			</p>
		</div>

	</div>

	<c:import url="footer.jsp"></c:import>

	<!-- jQuery -->
	<script src="resources/thirdparty/jquery/jquery-1.11.1.min.js"></script>

	<!-- Bootstrap Core JavaScript -->
	<script src="resources/thirdparty/bootstrap/js/bootstrap.min.js"></script>
</body>

</html>

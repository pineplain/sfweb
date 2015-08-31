<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>
<jsp:directive.page contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" />
<html>

<head>
<title>MVC Sample</title>
<meta name=viewport content="width=device-width, initial-scale=1">
<link rel="apple-touch-icon"
	href="<c:url value='/resources/images/apple-touch-icon.png' />">
<link rel="shortcut icon"
	href="<c:url value='/resources/images/favicon.ico' />">
<link
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css"
	rel="stylesheet">
</head>

<body>

	<c:import url="heading.jsp">
	</c:import>

	<div class="container">

		<div class="page-header">
			<h1>Index</h1>
		</div>

		<p>Hello</p>
	</div>


	<c:import url="footer.jsp"></c:import>

	<script src="http://code.jquery.com/jquery-1.11.1.min.js"></script>

	<script type="text/javascript"
		src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
</body>

</html>
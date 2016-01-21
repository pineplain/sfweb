<%@ page contentType="text/html;charset=Shift_JIS"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="f" uri="http://java.sun.com/jsp/jstl/fmt"%>
<html>

<head>
<title>Login</title>
</head>
<meta name=viewport content="width=device-width, initial-scale=1">
<link rel="apple-touch-icon"
	href="<c:url value='/resources/img/apple-touch-icon.png' />">
<link rel="shortcut icon"
	href="<c:url value='/resources/img/favicon.ico' />">
<link
	href="<c:url value='/resources/thirdparty/bootstrap/css/bootstrap.min.css' />"
	rel="stylesheet">

<body>

	<!-- Header -->
	<nav class="navbar navbar-default navbar-static-top">
		<div class="container">
			<!-- Brand and toggle get grouped for better mobile display -->
			<div class="navbar-header">
				<button type="button" class="navbar-toggle" data-toggle="collapse"
					data-target="#bs-example-navbar-collapse-1">
					<span class="sr-only">Toggle navigation</span> <span
						class="icon-bar"></span> <span class="icon-bar"></span> <span
						class="icon-bar"></span>
				</button>
				<a class="navbar-brand">ShareFast Web</a>
			</div>
		</div>
	</nav>

	<div class="container text-center">
		<div class="row">
			<div class="col-md-6">
				<h2>Authorized User</h2>
				<form action="j_spring_security_check" method="post"
					class="form-horizontal">
					<div class="form-group">
						<label class="col-sm-2 control-label">Username</label>
						<div class="col-sm-10">
							<input type="text" name="j_username" class="form-control">
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-2 control-label">Password</label>
						<div class="col-sm-10">
							<input type="password" name="j_password" class="form-control">
						</div>
					</div>
					<input type="submit" class="btn btn-primary" value="Login">
				</form>
			</div>
			<div class="col-md-6">
				<h2>Guest User</h2>
				<p>Continue as a guest. No sign-up required.</p>
				<form action="j_spring_security_check" method="post">
					<input type="hidden" name="j_username" value="user"> <input
						type="hidden" name="j_password" value="user"> <input
						type="submit" class="btn btn-primary" value="Login as Guest">
				</form>
			</div>
		</div>
	</div>

	<hr>

	<footer class="footer">
		<div class="container" style="text-align: center">
			<p>
				Copyright <span class="glyphicon glyphicon-copyright-mark"></span>
				The University of Tokyo<br> This web site is powered by <a
					href="https://sourceforge.net/projects/kashiwade/">KASHIWADE</a>
			</p>
		</div>
	</footer>

	<script type="text/javascript"
		src="<c:url value='/resources/thirdparty/jquery/jquery-1.11.1.min.js' />"></script>

	<script type="text/javascript"
		src="<c:url value='/resources/thirdparty/bootstrap/js/bootstrap.min.js' />"></script>
</html>
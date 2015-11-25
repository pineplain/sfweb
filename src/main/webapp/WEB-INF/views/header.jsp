<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>
<jsp:directive.page pageEncoding="UTF-8" />

<!-- Header -->
<nav id="mainNav" class="navbar navbar-default">
	<div class="container">
		<!-- Brand and toggle get grouped for better mobile display -->
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
				<span class="sr-only">Toggle navigation</span> <span
					class="icon-bar"></span> <span class="icon-bar"></span> <span
					class="icon-bar"></span>
			</button>
			<a class="navbar-brand page-scroll" href="<c:url value='/' />">ShareFast
				Web</a>
		</div>

		<div class="collapse navbar-collapse"
			id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav" id="nav">
				<li><a href="list"><span class="glyphicon glyphicon-list"></span>&nbsp;Workflow
						List</a></li>
			</ul>

			<ul class="nav navbar-nav navbar-right">
				<li><a id="username"><span class="glyphicon glyphicon-user"></span>&nbsp;<sec:authentication
							property="principal.username" /></a></li>
				<li><a href="<c:url value='/logout' />"><span
						class="glyphicon glyphicon-log-out"></span>&nbsp;Logout</a></li>
			</ul>
		</div>
		<!-- /.navbar-collapse -->
	</div>
	<!-- /.container-fluid -->
</nav>

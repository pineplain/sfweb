<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<jsp:directive.page pageEncoding="UTF-8" />

<!-- Header -->
<nav class="navbar navbar-default">
	<div class="container">
		<!-- Brand and toggle get grouped for better mobile display -->
		<div class="navbar-header">
			<button type="button" class="navbar-toggle" data-toggle="collapse"
				data-target="#bs-example-navbar-collapse-1">
				<span class="sr-only">Toggle navigation</span> <span
					class="icon-bar"></span> <span class="icon-bar"></span> <span
					class="icon-bar"></span>
			</button>
			<a href="<c:url value='/' />" class="navbar-brand">ShareFast Web</a>
		</div>
		<!-- Collect the nav links, forms, and other content for toggling -->
		<div class="collapse navbar-collapse"
			id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav" id="nav">
				<li
					<c:if test="${param.activePage == 'sample'}" >class="active"</c:if>>
					<a href="<c:url value='/' />">Sample</a>
				</li>
			</ul>
		</div>
	</div>
</nav>

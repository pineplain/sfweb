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
    href="<c:url value='/resources/css/bootstrap.min.css' />">

<!-- Custom Fonts -->
<link
    href='http://fonts.googleapis.com/css?family=Open+Sans:300italic,400italic,600italic,700italic,800italic,400,300,600,700,800'
    rel='stylesheet' type='text/css'>
<link
    href='http://fonts.googleapis.com/css?family=Merriweather:400,300,300italic,400italic,700,700italic,900,900italic'
    rel='stylesheet' type='text/css'>
<link rel="stylesheet"
    href="resources/creative/font-awesome/css/font-awesome.min.css"
    type="text/css">

<!-- Plugin CSS -->
<link rel="stylesheet" href="resources/creative/css/animate.min.css"
    type="text/css">

<!-- Custom CSS -->
<link rel="stylesheet" href="resources/creative/css/creative.css"
    type="text/css">

<!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
<!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.resources/creative/js/1.4.2/respond.min.js"></script>
    <![endif]-->

</head>

<body id="page-top">

    <nav id="mainNav" class="navbar navbar-default navbar-fixed-top">
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

            <!-- Collect the nav links, forms, and other content for toggling -->
            <div class="collapse navbar-collapse"
                id="bs-example-navbar-collapse-1">
                <ul class="nav navbar-nav navbar-right">
                    <li><a href="workflowList">Workflow List</a></li>
                    <li><a
                        href="http://heineken.is.k.u-tokyo.ac.jp/forest3/common/resourceList">Document
                            List</a></li>
                    <li><a href="http://heineken.is.k.u-tokyo.ac.jp/forest3/">KASHIWADE</a>
                    </li>
                </ul>
            </div>
            <!-- /.navbar-collapse -->
        </div>
        <!-- /.container-fluid -->
    </nav>

    <header>
        <div class="header-content">
            <div class="header-content-inner">
                <h1>ShareFast WEB</h1>
                <hr>
                <p>Application for document management system based on workflow</p>
            </div>
        </div>
    </header>

    <section class="bg-primary" id="about">
        <div class="container">
            <div class="row">
                <div class="col-lg-8 col-lg-offset-2 text-center">
                    <h2 class="section-heading">We've got what you need!</h2>
                    <hr class="light">
                    <p class="text-faded">The association between design documents and workflow is described by metadata based on semantic Web technology. This system offers a workflow editor to create and edit workflow.</p>
                </div>
            </div>
        </div>
    </section>

    <section id="services">
        <div class="container">
            <div class="row">
                <div class="col-lg-12 text-center">
                    <h2 class="section-heading">Developers</h2>
                    <hr class="primary">
                </div>
            </div>
        </div>
        <div class="container">
            <div class="row">
                <div class="col-lg-3 col-md-6 text-center">
                    <div class="service-box">
                        <i class="fa fa-4x fa-diamond wow bounceIn text-primary"></i>
                        <h3>Taiga Mitsuyuki</h3>
                        <p class="text-muted">Assistant Professor</p>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6 text-center">
                    <div class="service-box">
                        <i class="fa fa-4x fa-paper-plane wow bounceIn text-primary"
                            data-wow-delay=".1s"></i>
                        <h3>Hiroya Matsubara</h3>
                        <p class="text-muted">M2</p>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6 text-center">
                    <div class="service-box">
                        <i class="fa fa-4x fa-newspaper-o wow bounceIn text-primary"
                            data-wow-delay=".2s"></i>
                        <h3>Shinnosuke Wanaka</h3>
                        <p class="text-muted">M2</p>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6 text-center">
                    <div class="service-box">
                        <i class="fa fa-4x fa-heart wow bounceIn text-primary"
                            data-wow-delay=".3s"></i>
                        <h3>Satoru Nakamura</h3>
                        <p class="text-muted">D2</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="no-padding" id="portfolio">
        <div class="container-fluid">
            <div class="row no-gutter">
                <div class="col-lg-4 col-sm-6">
                    <a href="workflowList" class="portfolio-box"> <img
                        src="resources/creative/img/portfolio/1.jpg"
                        class="img-responsive" alt="">
                        <div class="portfolio-box-caption">
                            <div class="portfolio-box-caption-content">
                                <div class="project-category text-faded">Category</div>
                                <div class="project-name">Workflow List</div>
                            </div>
                        </div>
                    </a>
                </div>
                <div class="col-lg-4 col-sm-6">
                    <a
                        href="http://heineken.is.k.u-tokyo.ac.jp/forest3/common/resourceList"
                        class="portfolio-box"> <img
                        src="resources/creative/img/portfolio/2.jpg"
                        class="img-responsive" alt="">
                        <div class="portfolio-box-caption">
                            <div class="portfolio-box-caption-content">
                                <div class="project-category text-faded">Category</div>
                                <div class="project-name">Document List</div>
                            </div>
                        </div>
                    </a>
                </div>
                <div class="col-lg-4 col-sm-6">
                    <a href="http://heineken.is.k.u-tokyo.ac.jp/forest3/" class="portfolio-box"> <img
                        src="resources/creative/img/portfolio/3.jpg"
                        class="img-responsive" alt="">
                        <div class="portfolio-box-caption">
                            <div class="portfolio-box-caption-content">
                                <div class="project-category text-faded">Category</div>
                                <div class="project-name">KASHIWADE</div>
                            </div>
                        </div>
                    </a>
                </div>
            </div>
        </div>
    </section>

    <aside class="bg-dark">
        <div class="container text-center">
            <div class="call-to-action">
                <h2>GitHub</h2>
                <a href="https://github.com/pineplain/sfweb" class="btn btn-default btn-xl wow tada">Download
                    Now!</a>
            </div>
        </div>
    </aside>

    <section id="contact">
        <div class="container">
            <div class="row">
                <div class="col-lg-8 col-lg-offset-2 text-center">
                    <h2 class="section-heading">Let's Get In Touch!</h2>
                    <hr class="primary">
                    <p>Ready to start your next project with us? That's great! Give
                        us a call or send us an email and we will get back to you as soon
                        as possible!</p>
                </div>
                <div class="col-lg-4 col-lg-offset-2 text-center">
                    <i class="fa fa-phone fa-3x wow bounceIn"></i>
                    <p>04-7136-4626</p>
                </div>
                <div class="col-lg-4 text-center">
                    <i class="fa fa-envelope-o fa-3x wow bounceIn" data-wow-delay=".1s"></i>
                    <p>
                        <a href="mailto:info@is.k.u-tokyo.ac.jp">info@is.k.u-tokyo.ac.jp</a>
                    </p>
                </div>
            </div>
        </div>
    </section>

    <c:import url="footer.jsp"></c:import>
    <!-- jQuery -->
    <script src="resources/creative/js/jquery.js"></script>

    <!-- Bootstrap Core JavaScript -->
    <script src="resources/js/bootstrap.min.js"></script>

    <!-- Plugin JavaScript -->
    <script src="resources/creative/js/jquery.easing.min.js"></script>
    <script src="resources/creative/js/jquery.fittext.js"></script>
    <script src="resources/creative/js/wow.min.js"></script>

    <!-- Custom Theme JavaScript -->
    <script src="resources/creative/js/creative.js"></script>

</body>

</html>

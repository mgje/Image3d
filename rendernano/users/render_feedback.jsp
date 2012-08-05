<%@ taglib uri="/taglibs/nanoTag.tld" prefix="nano" %>
<%@ page 
 contentType="text/html; charset=ISO-8859-1"
%> 
<html>
	<head>
	<title>Render Feedback</title>
	<link rel="stylesheet" type="text/css" href="style.css">
	</head>
	
	<body>
	
	<h1>Render Feedback</h1>
	<p>
	Rendering has completed. The rendered image is now available in the gallery. To view 
	see the detailed output of the render process, please click 
	<a href="render_feedback.jsp?showlog=true">here</a>.
	</p>
	
	<p>Back to <a href="gallery.jsp">gallery</a>.</p>
	
		 
		<%if(request.getParameter("showlog") != null){
			%>
			<p>
			<%=session.getAttribute("RenderLog")%>
			</P>
			<%
		}%>
	
	
	<nano:copyright/>
	</body>
</html>
<%@ page 
 contentType="text/html; charset=ISO-8859-1"
%> 
<HTML>
<HEAD>
</HEAD>
<BODY>

	<h3>Render Result</h3>
	
	<%
	if(request.getParameter("renderedImage")!=null){
	    %>dummy-image<%
	}
	else{
	    %>no image rendered<%
	}
%>
</BODY>
<%@page import="java.io.*"%>
<%@page import="goodpractice.povwww.Configuration"%>
<%@page import="java.net.*"%>
<%@ taglib uri="/taglibs/nanoTag.tld" prefix="nano" %>
<%@ page 
 contentType="text/html; charset=ISO-8859-1"
%> 
<html>
<head>
<title>Script Editor</title>
<link rel="stylesheet" type="text/css" href="../css/style.css">
</head>
<body>
<div id="navigation">

NAVIGATION: <a <%=Configuration.getAppBaseURL()%>users/gallery.jsp">Gallery</a> | 
<a href="<%=Configuration.getAppBaseURL()%>users/documentation.jsp">Documentation</a>


</div>
<center>

<h4>Edit Image Script</h4>

<form action="UpdateScript" method="POST">

<input type="HIDDEN" name="scriptType" value="<%=Configuration.TEMPLATE_TYPE_POV%>">
<input type="submit" value="Update Script">
<br>
<textarea cols="120" rows="30" name="scriptsource" style="background-color:whitesmoke;">
<%
String script = "";
try{
    String fileLocation = Configuration.getTemplateLocator(Configuration.TEMPLATE_TYPE_POV);
    URL povUrl = new URL(Configuration.getTemplateLocator(Configuration.TEMPLATE_TYPE_POV));
    BufferedReader in = new BufferedReader(new InputStreamReader(povUrl.openStream()));
    for(String s = in.readLine(); s!=null; s = in.readLine()){
        script += s;
        %><%=s.trim()%>
        <%
    }
}
catch(Exception e){}
%>

</textarea>
<br>
<input type="submit" value="Update Script">


</form>
<nano:copyright/>
</center>

</body>
</html>
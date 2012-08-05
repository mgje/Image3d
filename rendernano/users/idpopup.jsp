<%@page import="goodpractice.povwww.Configuration"%>
<%@ taglib uri="/taglibs/nanoTag.tld" prefix="nano" %>
<%@ page 
 contentType="text/html; charset=ISO-8859-1"
%> 
<html>
<head>
<title>ID</title>
<link rel="stylesheet" type="text/css" href="../css/style.css">
</head>
<body style="margin-left:5%;margin-right:5%;text-align:justify;">
<br>
<h3>ID</h3>
When you visit <%=Configuration.getAppName()%> for the first time, you receive a 
random ID. This ID is stored in a cookie, that is, a small text file in your browsers 
cookie directory. Each time you visit <%=Configuration.getAppName()%>, your browser send 
that ID and the application will recognize you.
<br><br>
However, if you delete the cookie on your computer, or if you access <%=Configuration.getAppName()%>
 from a different computer, the application will not recognize you. If you remember your ID, 
 you can tell the application to restore that ID for you, even if you don't have the cookie. 
 You can either write down your ID yourself, or have it emailed to you. As soon as you fill out 
 the respective form in the gallery, an email will be sent to you.
<p style="text-align:right;">
<nano:copyright/>
</p>
</body>
</html>
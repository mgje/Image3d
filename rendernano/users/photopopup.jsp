<%@ page 
 contentType="text/html; charset=ISO-8859-1"
%> 
<%
String fileId = request.getParameter("fileId");
if(fileId==null){
    %>Error: no picture specified.<%
    
}
else{
%>

<html>
<head>
<title>Image: <%=fileId%></title>
</head>
<body>
<img src="DefaultFileToUser?fileName=<%=fileId%>" border=0>
    
    
    
<%
}
%>
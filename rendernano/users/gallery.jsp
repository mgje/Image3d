<%@page import="goodpractice.povwww.*"%>
<%@page import="goodpractice.povwww.fs.*"%>
<%@ taglib uri="/taglibs/nanoTag.tld" prefix="nano" %>
<%@ page 
 contentType="text/html; charset=ISO-8859-1"
%> 
<%
	Logger.dev(this, "Create fsreader");
	FSReader reader = new FSReader(Configuration.getUserHome(request) + "measurements");
	Logger.dev(this, "Read images");
	String[] images = reader.getFileNames();
	reader = new FSReader(Configuration.getUserHome(request) + "rendered");
	Logger.dev(this, "Read rendered");
	String[] render = reader.getFileNames();
	Logger.dev(this, "Image Load OK");
%>

<html>
	<head>
	<title>Nano3d Visualization Service</title>
	<link rel="stylesheet" type="text/css" href="../css/gallerynewstyle.css">
	

	</head>
<body>
<center>
<img src="../images/nano3dsilt.jpg" width=650 alt="banner">
<table width=650 border=0 cellpadding=0 cellspacing=20>
	<tr>
	<td class="left" width=180 valign=top><center>
		<div id="welcome">
			<div id="title">Wilkommen !</div>
			
			Mit image3d k&ouml;nnen Sie 3D Ansichten von 
			H&ouml;henprofilen erzeugen. 
			<br><br>
			F&uuml;r eine kurze 
			Einf&uuml;hrung klicken Sie <a href="documentation.jsp" target=_blank>hier</a>.
			<br>
			<br>
			Ihre ID ist <i><%=Configuration.getUser(request)%></i>. 
			<br><br>
			<!---
			Informationen zu ihrer ID erhalten Sie <a onClick="javascript:PopupId()" style="cursor:hand;">hier</a>.
			<br><br>
			<br>
			--->
			<form action="<%=Configuration.getAppBaseURL()%>users/gallery.jsp" method="POST">
				<input class="small" type="text" name="restoreCookieId">
				<input class="small" type="submit" value="andere ID">
			</form>
			<br><br>
			
			<div id="title">Info</div>
	        <div id="help">
		       <table>
		          <tr><td><img src="../images/picture.png"/></td><td>3D Visualisierung</td></tr>
		          <tr><td><img src="../images/movies.png"/></td><td>Animation erstellen</td></tr>
		          <tr><td><img src="../images/trash.png"/></td><td>Daten l&ouml;schen</td></tr>
		       </table>
	        </div>
			<!---
			<b>Have your ID emailed</b>
			<br>
			<form action="<%=Configuration.getAppBaseURL()%>users/Emailer" method="POST">
				<input type="hidden" name="command" value="email">
				<input class="small" type="text" name="address">
				<input class="small" type="submit" value="Email">
			</form>
            --->
		</div></center>

		</td>

<!--- Spalte 2 -->

		<td class="center" width=400 valign=top>
		<center>
			<span class="title">H&ouml;henprofile</span>
			<div id="measurements">

		<!--span class="title">Measurements</span-->
		<table border=0 cellpadding=0>
		
	    
		<%
		for(int i = 0; i < images.length; i++){
		    %>
		    <tr>
		    <td><form action="Delete" method="POST">
		    	<input type="HIDDEN" name="id" value="<%=images[i]%>">
		    	<button type="submit" value="Delete"><p><img src="../images/trash.png" ></p></button>
		    	</form></td>
		    	
		    <td><form action="SetJob" method="POST">
		    	<input type="HIDDEN" name="imageLocator"> 
		    	<input type="HIDDEN" name="redirectUrl" value="renderEditor.jsp">
		    	<input type="HIDDEN" name="imageId" value="<%=images[i]%>">
		    	<button type="submit" value="3dImage"><p><img src="../images/picture.png" ></p></button>
		    	</form></td>
		    	
		    
		    	<td></td>
		    
		    	<td>
		    	<form action="SetJob" method="POST">
		    	   <input type="HIDDEN" name="imageLocator"> 
		    	   <input type="HIDDEN" name="redirectUrl" value="renderMovieEditor.jsp">
		    	   <input type="HIDDEN" name="imageId" value="<%=images[i]%>">
		    	   <button type="submit" value="3dImage"><p><img src="../images/movies.png" ></p></button>
		    	</form></td>
		    	</td>
		    	
		    	
		    	
		    <%
		    if(i%2>0){    
		        %><td class="color"><a href="SetJob?imageLocator&redirectUrl=renderEditor.jsp&imageId=<%=images[i]%>">
		        <img src="ThumbnailToUser?fileName=<%=images[i]%>&forceNew=true&width=48&height=48" alt="Not rendered yet" width=48 height=48>
		        <%=images[i]%></a></td><%
		    }
		    else{
		        %><td class="othercolor"><a href="SetJob?imageLocator&redirectUrl=renderEditor.jsp&imageId=<%=images[i]%>">
		        <img src="ThumbnailToUser?fileName=<%=images[i]%>&forceNew=true&width=48&height=48" alt="Not rendered yet" width=48 height=48>
		        <%=images[i]%></a></td><%
		    }
		    %>
		    </tr>
		    <%
		}
%>
	    
	</table><br>
	<form action="FileToServer" enctype="multipart/form-data" method="POST">
	<input name="file" type="file" value="Add file"><input type="submit" value="Add"></form>

</div>
</center>
		</td>

<!--- Spalte 3 -->
		<td class="right" width=180 valign=top><center>

	
	<div id="renderedimages">
	<div id="title">3D</div>
	<table border=0>
	<%
	for(int i = 0; i < render.length; i++){
	    %>
	    <tr><td>
	    <form action="Delete" method="POST">
    	<input type="HIDDEN" name="id" value="<%=render[i]%>">
    	<button type="submit" value="Delete"><p><img src="../images/trash.png" ></p></button>
    	</form></td><td><a href="FileToUser?fileName=<%=render[i]%>">
    	<img src="ThumbnailToUser?fileName=<%=render[i]%>&forceNew=true&width=64&height=48" alt="Not rendered yet" width=64 height=48>
    	<br><%=render[i].substring(render[i].indexOf(".")+1)%></a><br></td></tr><%
	}
	%>
	</table>
	</div>

	</center>
		</td>

	</tr>


	<tr>
	
	<td colspan=3 class="bar" >
	<center>
	<nano:copyright/>
	</center>
	</td>
	</tr>
	</table>
	</center>

	
</body>
</html>	
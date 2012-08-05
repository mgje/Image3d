<%@page import="goodpractice.povwww.*"%>
<%@page import="java.io.*, java.util.*"%>
<%@page import="goodpractice.povwww.pov.*"%>
<%@page import="java.net.URL"%>
<%@ page 
 contentType="text/html; charset=ISO-8859-1"
%> 
<%@ taglib uri="/taglibs/nanoTag.tld" prefix="nano" %>
<%
	JobSession js = (JobSession) request.getSession().getAttribute(JobSession.class.getName());
	if(js==null){
	    %>Error: no job session active. Please go <a href="gallery.jsp">back to the gallery</a> and 
	    start the rendering process by clicking on the render button.
	    <%
	    return;
	}
	
	String fileId = js.getImageId();
	String imageFile = Configuration.getUserHome(request) + request.getParameter("id");
	
	/* Read .pov and .ini script from FS */
	URL povUrl = new URL(Configuration.getTemplateLocator(Configuration.TEMPLATE_TYPE_POV));
	BufferedReader in = new BufferedReader(new InputStreamReader(povUrl.openStream()));
	StringBuffer povScript = new StringBuffer();
	String tmp = "";
	while( (tmp=in.readLine()) != null)
		povScript.append(tmp);
	URL iniUrl = new URL(Configuration.getTemplateLocator(Configuration.TEMPLATE_TYPE_INI));
	in = new BufferedReader(new InputStreamReader(iniUrl.openStream()));	StringBuffer iniScript = new StringBuffer();
	while( (tmp = in.readLine()) != null)
		iniScript.append(tmp);

	/* create parameter array of both ini and pov params */
	Parameter[] pov = ScriptGenerator.getFormParameters(povScript.toString());
	Parameter[] ini = ScriptGenerator.getFormParameters(iniScript.toString());
	
	Parameter[] parameters = new Parameter[pov.length + ini.length];
	for(int i = 0; i < parameters.length; i++){
		parameters[i] = (i>=pov.length) ? ini[i-pov.length] : pov[i];
	}	
	Object rpTmp = request.getSession().getAttribute("povwwwParamRemember");
	Hashtable rememberParams = rpTmp==null ? null : (Hashtable)rpTmp;
%>

<html>

<head>

	<title>Enter Rendering Parameters</title>
	<link rel="stylesheet" type="text/css" href="../css/style.css">
	<script language="javascript">
	function DoImageSubmit(){
		<%
			//	generate function that collects all applet configuration values and applies 
			//	them to the form 
			int appletIdx = 0;
			for(int i = 0; i < parameters.length; i++){
				Parameter p = parameters[i];
				if(p.isComplex() && p.isValid() && p.hasAppletTag()){
				%> document.forms[0].<%=p.getName()%>.value = document.applets[<%=appletIdx++%>].getConfiguration();<%
				}
			}	
		%>
		document.forms[0].submit();
	}	

	function DoParameterUpdate(){
	    <%
		//	generate function that collects all applet configuration values and applies 
		//	them to the form
	    if(rememberParams!=null){
			appletIdx = 0;
			for(int i = 0; i < parameters.length; i++){
				Parameter p = parameters[i];
				if(!parameters[i].getName().equals("imageLocator")){
				    %>
				    /*alert("Parameter: <%=parameters[i].getName()%> (complex: <%=parameters[i].isComplex()%>)");*/
				    <%
				try{
				    String rP = (String) rememberParams.get(p.getName());
				    %>/*alert("Setting <%=p.getName()%> = <%=rP%>");*/<%
				    if(!p.isComplex()){
				        %>document.forms[0].<%=p.getName()%>.value = "<%=rP%>";<%
				    }
				    else if(!p.hasAppletTag()){
				        %>document.forms[0].<%=p.getName()%>.value = "<%=rP%>";<%
				    }
				    else{
				        // applet
				        %>
				        /*alert("Conf: " + document.applets[<%=appletIdx%>].getConfiguration());*/
				        document.applets[<%=appletIdx++%>].setConfiguration("<%=rP%>");
				        <%
				    }
				}catch(Exception e){ e.printStackTrace();}
				}
			}	
	    }
	%>	    
	}
	</script>
</head>
	
<body>
<div id="navigation">

NAVIGATION: <a href="<%=Configuration.getAppBaseURL()%>users/gallery.jsp">Gallery</a> | 
<a href="<%=Configuration.getAppBaseURL()%>users/documentation.jsp">Documentation</a>
</div>

<div id="title">
<!--img src="titleimagenew.jpg"--><!--image3d.epistemis.com: render image-->
</div>


<div id="main">

<div id="left">


	<form action="Render" method="POST">
	<input type="HIDDEN" name="imageLocator" value="<%=Configuration.getUserHome(request) + Constants.DIR_MEASURE + fileId%>">
	<div id="parameters">
	<table class="parameters">
		<tr><td>Image File</td><td><input type="text" name="imageFile" size="<%=fileId.length()%>" value="<%=fileId%>" readonly></td></tr>
		<%
		for(int i = 0; i < parameters.length; i++){
			if(!(parameters[i].getName().equalsIgnoreCase("imageFile")||parameters[i].getName().equalsIgnoreCase("imageLocator"))){
				if(parameters[i].isComplex()){
					if(parameters[i].isValid()){
						if(parameters[i].hasAppletTag()){
							%> <tr><td><%=parameters[i].getName()%></td>
							<td><%=parameters[i].getAppletTag()%></td>
							<input type="HIDDEN" name="<%=parameters[i].getName()%>" value=""/></tr>
							<%
						}
						else{
							String[] vals = parameters[i].getValues();
							String[] labs = parameters[i].getLabels();
							%> <tr><td><%=parameters[i].getName()%></td>
							<td><select name="<%=parameters[i].getName()%>"><%
							for(int j = 0; j < vals.length; j++){
								%><option value="<%=vals[j]%>"><%=labs[j]%><%
							}
							%></select></td></tr><%
						}
					}
					else{
					%><tr><td>invalid parameter:</td><td><%=parameters[i].getName()%></td></tr><%
					}
				}
				else{
				%>
				<tr><td><%=parameters[i].getName()%></td><td>
				<input type="text" name="<%=parameters[i].getName()%>"></td></tr>
				<%
				}
			}
		}
			

		%>
		</table>
		</div>
		<center><input type="button" value="Render" onClick="javascript:DoImageSubmit()"></center>
		</form>
		</div>
	

<script language="javascript">
<!--
DoParameterUpdate();
-->
</script>
<div id="right">
<center>
<%
String imgT = js.getImageId();
imgT = imgT.substring(0,imgT.lastIndexOf("."));
%>
	<img src="ThumbnailToUser?fileName=rendered.<%=imgT%>.png&forceNew=true&width=640&height=480" alt="Not rendered yet" width=640 height=480>


<div id="note">
<b>Note:</b> the image on the right is a compressed, fixed-sized version of the rendered image. 
The view in this editor will always display images with the dimensions 640x480. You can 
access the original rendered image in the gallery.
</div>
<nano:copyright/>
</center>
</body>
</html>
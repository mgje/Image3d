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

	<title>3D Parameter, image3d goodpr@ctice</title>
	<script type="text/javascript" src="js/nanoAjax.js"></script>
	<link rel="stylesheet" type="text/css" href="../css/style.css">
	<script language="javascript">
	function DoImageSubmit(){
	  var requestParams=""; 
		<%
			//	generate function that collects all applet configuration values and applies 
			//	them to the form 
			int appletIdx = 0;
			for(int i = 0; i < parameters.length; i++){
				Parameter p = parameters[i];
				if(p.isComplex() && p.isValid() && p.hasAppletTag()){ %> 
				document.forms[0].<%=p.getName()%>.value = document.applets[<%=appletIdx%>].getConfiguration();
				requestParams += "<%=p.getName()%>=" + document.applets[<%=appletIdx%>].getConfiguration() + '&';
				
				<%
					appletIdx++;
				}//end if applet
				else{//standard form elements, like: text, select 
				%>
				requestParams +=  "<%=p.getName()%>=" + window.document.forms[0].<%=p.getName()%>.value +'&'; 				
				<%
				}//end else
			}//end for loop
		%>
		/* document.forms[0].submit();*/
		requestParams +=  "imageFile=" + "<%=fileId%>";		
		
		/*alert(requestParams);*/
		ajaxRequest("POST","Render",requestParams,ajaxCallbackFunction);
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
NAVIGATION: <a href="<%=Configuration.getAppBaseURL()%>users/gallery.jsp">
Datei&uuml;bersicht</a> | 
<a href="<%=Configuration.getAppBaseURL()%>users/documentation.jsp" 
target=_blank>Hilfe</a>

</div>

<div id="title">
<!--img src="titleimagenew.jpg"--><!--image3d.epistemis.com: render image-->
</div>
<!--div id="navigation">
<%--
NAVIGATION: <a href="<%=Configuration.getAppBaseURL()%>users/gallery.jsp">
Datei&uuml;bersicht</a> | 
<a href="<%=Configuration.getAppBaseURL()%>users/documentation.jsp">Hilfe</a>
--%>
AVIGATION: <a href="<%=Configuration.getAppBaseURL()%>users/gallery.jsp">
Datei&uuml;bersicht</a> | 
<a href="<%=Configuration.getAppBaseURL()%>users/documentation.jsp">Hilfe</a>

</div-->

<div id="main">

<div id="left">


	<form action="Render" method="POST">
	<input type="HIDDEN" name="imageLocator" value="<%=Configuration.getUserHome(request) + Constants.DIR_MEASURE + fileId%>">
	<div id="parameters">
	<table class="parameters">
		<tr><td>Filename</td><td><input type="text" name="imageFile" size="<%=fileId.length()%>" value="<%=fileId%>" readonly></td></tr>
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
		<br>
		<center>
		<b>  3D Visualisierung </b>
		</center>
		<br>
		<center><input type="button" value="Ausf&uuml;hren" onClick="javascript:DoImageSubmit()"></center>
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
	<img  id="MainImage"   src="ThumbnailToUser?fileName=rendered.<%=imgT%>.png&forceNew=true&width=640&height=480" alt="Not rendered yet" width=640 height=480>


<div id="note">

</div>
<nano:copyright/>
</center>
</body>
</html>


<script type="text/javascript">
function ajaxCallbackFunction(xmlParams){ //later will process the xml return from servlet here
	/*alert("callback");*/
	var search="&"+(new Date()).getTime();
	window.document.getElementById('MainImage').src+=search;
	
}
</script>



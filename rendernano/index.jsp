<%@ taglib uri="/taglibs/nanoTag.tld" prefix="nano" %>
<html>
<head>
<title>NANO3D visualization service</title>
<link rel="stylesheet" type="text/css" href="css/gallerynewstyle.css">
</head>
<body>

<center>

<table width=800 border=0 cellpadding=0 cellspacing=20>

<th colspan=3><img src="images/nano3dsilt.jpg" width=800></th>

<tr>
	<td class="left" width=180>
		<center><div id="loginwelcome">Wilkommen bei <br>Image3d </div></center>
	</td>

	<td class="center" width=400>

<center><div id="login">
<form action="users/gallery.jsp" method="POST">
<table class="login" border=0  cellpadding="0">
<tr><td><span class="title">Username</span></td><td><input type="text" name="uid"></td></tr>
<tr><td><span class="title">Password</span></td><td><input type="password" name="pwd"></td></tr>
<tr><td>&nbsp;</td><td><input type="submit" value="Login"></td></tr>
<tr><td>&nbsp;</td><td></td>
<tr><td></td><td><br><input type="submit" value="Guest Login"></td></tr>
</table>
</form></div>
</center>
	</td>


	<td class="right" width=180><center><div id="loginwelcome">
	F&uuml;r eine kurze 
			Einf&uuml;hrung klicken Sie <a href="users/documentation.jsp" target=_blank>hier</a>.
	
	</div></center></td>

</tr>


<tr>

<td colspan=3 class="bar"><center><nano:copyright/></center>
</td>

</tr>
</table>
</center>

</body>
</html>
/*
 * Created on 03.12.2004 by florian
 */
package goodpractice.povwww.web.servlet;

import javax.servlet.http.*;
import goodpractice.povwww.fs.*;
import java.io.*;

public class StatusServlet extends HttpServlet {

		/**
	 * 
	 */
	private static final long serialVersionUID = 6215384869778390532L;

		public static final String LOCATION = "/povwww/users/StatusServlet";
		
		private static final String fileContext = "/usr/local/share/povApp/users/";
		
		
		public void doGet(HttpServletRequest request, HttpServletResponse response){
			try{
				FSReader reader = new FSReader(fileContext+  "florian/");
				String[] files = reader.getFileNames();
				PrintWriter out = new PrintWriter(response.getWriter());
				out.println("<html><body><h1>Images</h1><table border=1>");
				for(int i = 0; i < files.length; i++){
					out.println("<tr><td><a href=\"FileToUser?fileName=" + files[i] + "\">" + files[i] + "</a></td><td>"
							+ "<form action=\"/povwww/form_render.jsp\" method=\"POST\"><input type=\"HIDDEN\"" 
							+ " name=\"id\" value=\"" + files[i] + "\"><input type=submit value=\"render\""
							+ "</form></td><td><form action=\"Delete\" method=\"POST\">"
							+ "<input type=\"HIDDEN\" name=\"id\" value=\"" + files[i] + "\"" 
							+ "><input type=submit value=\"delete\"></form></td></tr>");
				}
				
				out.println("</table>");
				out.println("<hr>");
				out.println("<b>Add Image</b> ");
				out.println("<form action=\"FileToServer\" enctype=\"multipart/form-data\" method=\"POST\">");
				out.println("<input name=\"file\" type=\"file\"><input type=\"submit\" value=\"upload\">");
				out.println("</body></html>");
			}
			catch(Exception e){}
		}
}

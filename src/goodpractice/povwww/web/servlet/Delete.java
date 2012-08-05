/*
 * Created on 03.12.2004 by florian
 */
package goodpractice.povwww.web.servlet;

import javax.servlet.http.*;
import goodpractice.povwww.fs.FSWriter;
import goodpractice.povwww.Configuration;


public class Delete extends HttpServlet {

	
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 2185550631100878204L;

	public void doPost(HttpServletRequest request, HttpServletResponse response){
		try{
		    String fileContext = Configuration.getUserHome(request);
			FSWriter writer = new FSWriter(fileContext);
			String fileId = request.getParameter("id");
			Exception err = null;
			try{
			    writer.deleteFile(fileId);
			}catch(Exception e){ err = e; }
			
			//response.sendRedirect(StatusServlet.LOCATION);
			if(err!=null)
			    response.sendRedirect("gallery.jsp?status=" + err.toString());
			else
			    response.sendRedirect("gallery.jsp");
		}
		catch(Exception e){ System.out.println("Delete Error"+e.getMessage());}
		
	}
}

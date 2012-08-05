/*
 * Created on Jan 13, 2005 by florian
 */
package goodpractice.povwww.web.servlet;

import javax.servlet.http.*;
import java.io.*;
//import java.net.URL;

import goodpractice.povwww.Configuration;

public class UpdateScript extends HttpServlet {
    
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public void doPost(HttpServletRequest request, HttpServletResponse response){
     try{
        int scriptType = Integer.parseInt(request.getParameter("scriptType"));
        String script = request.getParameter("scriptsource");
        File f = new File(Configuration.getTemplateLocatorFs(scriptType));
        PrintWriter pw = new PrintWriter(new FileWriter(f));
        pw.println(script.trim());
        pw.flush();
        pw.close();
       // PrintWriter out = new PrintWriter(response.getWriter());
        /*out.println("<h3>Script updated</h3>");
        out.println("<p>Reading back script:<br>");
        URL povUrl = new URL(Configuration.getTemplateLocator(Configuration.SCRIPT_TYPE_IMAGE));
        BufferedReader in = new BufferedReader(new InputStreamReader(povUrl.openStream()));
        out.println("<pre>");
        for(String s = in.readLine(); s!=null; s = in.readLine()){
            out.println(s);
        }
        out.println("</pre>");
        out.flush();
        out.close();*/
        response.sendRedirect("editScript.jsp");
     }
     catch(Exception e){
         e.printStackTrace();
     }
        
    
    }

}

/*
 * Created on 03.12.2004 by florian
 */
package goodpractice.povwww.web.servlet;

import goodpractice.povwww.Configuration;
import goodpractice.povwww.Constants;
import goodpractice.povwww.Logger;
import goodpractice.povwww.fs.FSWriter;
import goodpractice.povwww.pov.AutoScript;
import goodpractice.povwww.proc.I_Job;
import goodpractice.povwww.proc.PovJob;
import goodpractice.povwww.proc.Spawner;

import java.util.Enumeration;
import java.util.Hashtable;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


public class Render extends HttpServlet {

	
	
		/**
	 * 
	 */
	private static final long serialVersionUID = -5749014409745977045L;

		public void doGet(HttpServletRequest request, HttpServletResponse response){
			//...
		}
	
		
		/**
		 * Parameters to this servlet
		 * 
		 * 			width, height		dimension of the image to be rendered
		 * 			id					filename of the image source
		 * 								(output filename is automatic)
		 * 			
		 * 
		 */
		public void doPost(HttpServletRequest request, HttpServletResponse response){
		    
		    /*
		     * first, write all parameters to session - they may be used by 
		     * the renderForm to keep track of user inputs.
		     */
			Logger.dev(this, "Start Render Servlet");
			Hashtable params = new Hashtable();
		    Enumeration Paraenum = request.getParameterNames();
		    while(Paraenum.hasMoreElements()){
		        String key = (String) Paraenum.nextElement();
		        params.put(key, request.getParameter(key));
		    }
		    request.getSession().setAttribute("povwwwParamRemember", params);
		    
		    String userHome = Configuration.getUserHome(request);
		    String imageName = request.getParameter("imageFile");
		    String outputFile = userHome + Constants.DIR_RENDER + "rendered." + stripExt(imageName) + ".png";
		    
		    
		    StringBuffer log = new StringBuffer();
		   
			log.append("Creating AutoScript<br>");
		    
			/*
			 * create the AutoScript and build it. The script creates the .pov and .ini files 
			 * that will server the PovJob as parameters.
			 */
			AutoScript as = new AutoScript(imageName, Configuration.getUserHome(request), request, Configuration.TEMPLATE_TYPE_POV, Configuration.TEMPLATE_TYPE_INI);
		   // String errMsg= "";
		    try{
		        as.build();
		    }
		    catch(Exception e){ 
		        log.append("Error: Render.java:"+e.toString() + "<br>");
		        log.append("Cause: " + e.getCause() + "<br>");
		        StackTraceElement[] st = e.getStackTrace();
		        for(int i = 0; i < st.length; i++){
		            log.append(st[i].toString() + "<br>");
		            if(i>10) break;
		        }
		        
		        Logger.dev(this, log.toString());
		        
		    }
		    
		    /*
		     * create the povjob and execute it
		     */
			I_Job job = new PovJob(outputFile, as);
			int exVal = -1;
			try{
			    exVal = Spawner.spawn(job);
			}catch(Exception e){
				Logger.dev(this, "Render Error"+e.getMessage());
			}
			
			
			/*
			 * delete temp files (.pov, .ini)
			 */
			try{ 
			FSWriter writer = new FSWriter(userHome);
			String sFileId = as.getScriptName();
			writer.deleteFile(sFileId);
			sFileId = as.getIniName();
			writer.deleteFile(sFileId);
			}catch(Exception e){ 
				log.append(e.toString());
				Logger.dev(this, log.toString());	
			}
	
			HttpSession session = request.getSession();

			/*
			 * finish log and add it to session for debug
			 */
			log.append("<h3>Render Result</h3>");
			log.append("Rendering ended with exit code: " + exVal + "<br>");
			log.append("Rendering command: " + job.getCommand() + "<br>");
			log.append("<hr>");
			log.append("<h3>Log</h3>");
			log.append(Spawner.LOG);
			
			session.setAttribute("RenderLog", log);		
			
			Logger.dev(this, log.toString());
			// AJAX don't need a redirect
			/*
			try{
			    response.sendRedirect("renderEditor.jsp");
			}catch(Exception e){
				 Logger.dev(this, "Could not redirect REnder.java "+e.getMessage());
			}
			*/
			
			
			
   
		}
		
		private String stripExt(String withExt){
		    return withExt.substring(0,withExt.lastIndexOf("."));
		}
}

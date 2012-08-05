/*
 * Created on 03.12.2004 by florian
 */
package goodpractice.povwww.web.servlet;

import javax.servlet.http.*;
import goodpractice.povwww.fs.*;
import java.io.*;
import goodpractice.povwww.Configuration;

public class DefaultFileToUser extends HttpServlet {


	
		/**
	 * 
	 */
	private static final long serialVersionUID = -6749646206930340990L;

		public void doGet(HttpServletRequest request, HttpServletResponse response){
			String fileName = request.getParameter("fileName");
			if(fileName == null){
				try{
					System.out.println("DefaultFileToUser Filename not found in request, redirecting to error.");
					response.sendError(HttpServletResponse.SC_BAD_REQUEST, "No file specified");
				} catch(Exception e){}
					return;
			}
			

			FSReader reader = new FSReader(Configuration.getAppHome() + "/" + "examples" + "/");
			try{
			    if(fileName.endsWith("avi")){
			        response.setContentType("video/avi");
			    }
			    else if(fileName.endsWith("mpg")){
			        response.setContentType("video/mpeg");
			    }
			    else{
			        response.setContentType("image/jpeg");
			    }
			    
			    
				InputStream in = reader.openStream(fileName);
				response.setContentLength(in.available());
				
				response.setHeader("Content-disposition", "attachment; filename=" + fileName);
				OutputStream out = response.getOutputStream();
				int eos = 0;
				while( (eos=in.read()) != -1){
					out.write(eos);
				}
				
				/*byte[] buff = new byte[in.available()];
				in.read(buff);
				out.write(buff);*/
				
				in.close();
				out.flush();
				out.close();
			}
			catch(Exception e){
				try{
					response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "The following error occured: " + e);
					
				}catch(Exception e2){}
			}
			
			
		}
}

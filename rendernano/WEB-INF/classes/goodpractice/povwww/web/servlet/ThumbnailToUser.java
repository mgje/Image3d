/*
 * Created on 03.12.2004 by florian
 */
package goodpractice.povwww.web.servlet;

import javax.servlet.http.*;
import goodpractice.povwww.fs.*;
import java.io.*;
import goodpractice.povwww.Configuration;
import goodpractice.povwww.*;

public class ThumbnailToUser extends HttpServlet {


	
		/**
	 * 
	 */
	private static final long serialVersionUID = 3584659712533120653L;

		public void doGet(HttpServletRequest request, HttpServletResponse response){
		    String userHome = Configuration.getUserHome(request);
			String fileName = request.getParameter("fileName");
			boolean forceNew = request.getParameter("forceNew")==null ? false : true;
			int width = request.getParameter("width")==null ? 100 : Integer.parseInt(request.getParameter("width"));
			int height = request.getParameter("height")==null ? 100 : Integer.parseInt(request.getParameter("height"));
			
			if(fileName == null){
				try{
					System.out.println("Thumbnail To User Error:Filename not found in request, redirecting to error.");
					response.sendError(HttpServletResponse.SC_BAD_REQUEST, "No file specified");
				} catch(Exception e){}
					return;
			}
			

			FSReader reader = new FSReader(userHome);
			String thumbFileName = Constants.PREFIX_THUMB + fileName;
			if(!thumbFileName.endsWith(".jpg"))
			    thumbFileName = thumbFileName.substring(0,thumbFileName.lastIndexOf(".")) + ".jpg";
			
			/* if the thumbnail doesn't exist, create it */
			if(forceNew || !reader.exists(thumbFileName)){
			    try{
			        Logger.app(this, "Encoding " + fileName + " to " + thumbFileName);
			        ThumbnailEncoder te = new ThumbnailEncoder();
			        te.encode(userHome + getSubFolder(fileName) + 
			                fileName, userHome + Constants.DIR_THUMB + thumbFileName,
			                width, height);
			    }
			    catch(Exception e){
			        Logger.app(this, "ENCODING ERROR:" + e);
			    }
			}
			
			
			
			
			try{
			    response.setContentType("image/jpeg");
			    InputStream in = reader.openStream(thumbFileName);
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
		
		private String getSubFolder(String filePattern){
		    if(filePattern.startsWith(Constants.PREFIX_RENDER))
		        return Constants.DIR_RENDER;
		    else if(filePattern.startsWith(Constants.PREFIX_THUMB))
		        return Constants.DIR_THUMB;
		    else if(filePattern.startsWith(Constants.PREFIX_DESCRIPTION))
		        return Constants.DIR_DESC;
		    return Constants.DIR_MEASURE;
		}
		
		
	
}

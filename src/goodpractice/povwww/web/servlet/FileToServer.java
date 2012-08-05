/*
 * Created on 03.12.2004 by florian
 */
package goodpractice.povwww.web.servlet;

import javax.servlet.http.*;
import org.apache.commons.fileupload.*;
import java.util.*;
import java.io.File;
import goodpractice.povwww.Configuration;
import goodpractice.povwww.Constants;

public class FileToServer extends HttpServlet {

	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1213408437935906513L;

	public void doPost(HttpServletRequest request, HttpServletResponse response){
		try{
		String userHome = Configuration.getUserHome(request);
		DiskFileUpload fu = new DiskFileUpload();
        fu.setSizeMax(-1);
        fu.setSizeThreshold(4096);
        File tmpRepository = new File(userHome + "tmpupload/");
        if(!tmpRepository.exists())
            tmpRepository.mkdir();
        fu.setRepositoryPath(tmpRepository.getAbsolutePath());
        List fileItems = fu.parseRequest(request);
        Iterator it = fileItems.iterator();
        while(it.hasNext()){
        	FileItem fi = (FileItem)it.next();
        	String fileName = fi.getName();
        	if(fileName.indexOf("\\")>0)
        	    fileName = fileName.substring(fileName.lastIndexOf("\\")+1);
        	if(fileName.indexOf("/")>0)
        	    fileName = fileName.substring(fileName.lastIndexOf("/")+1);
        	fi.write(new File(userHome + getSubFolder(fileName) + fileName));
        }	
        response.sendRedirect("gallery.jsp");
		}
		catch(Exception e){ 
			System.out.println("FileToServer Error"+e.getMessage());
			try{
			    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.toString());
			}catch(Exception e2){}
		}
	}
	
	/* TODO: this is obsolete here, the whole fs writing in this servlet should go to 
	 * FSWriter, and probably, the getSubFolder method to a separate class in 
	 * povwww.fs
	 */
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

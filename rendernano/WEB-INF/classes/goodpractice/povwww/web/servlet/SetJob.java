/*
 * Created on 03.12.2004 by florian
 */
package goodpractice.povwww.web.servlet;

import javax.servlet.http.*;
import goodpractice.povwww.pov.*;
import java.util.*;
import goodpractice.povwww.Logger;


public class SetJob extends HttpServlet {

	
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -701759176199581638L;

	public void doPost(HttpServletRequest request, HttpServletResponse response){
		try{
		    Enumeration e = request.getParameterNames();
		    while(e.hasMoreElements()){
		        String tmp = (String) e.nextElement();
		        Logger.dev(this, tmp + "=" + request.getParameter(tmp));
		    }
		    String redirectUrl = request.getParameter("redirectUrl");
		    String imageId = request.getParameter("imageId");
		    JobSession js = new JobSession(imageId);
		    Enumeration other = request.getParameterNames();
		    Hashtable p = new Hashtable();
		    while(other.hasMoreElements()){
		        String tmp = (String) other.nextElement();
		        if(!tmp.equals("redirectUrl"))
		            if(!tmp.equals("imageId"))
		                p.put(tmp, request.getParameter(tmp));
		    }
		    js.setParameters(p);
		    request.getSession().setAttribute(JobSession.class.getName(), js);
		    Logger.dev(this, "Send URLRedirect: " + redirectUrl);
		    response.sendRedirect(redirectUrl);
		}
		catch(Exception e){ System.out.println("SetJob Error"+e.getMessage());}
		
	}
	
	public void doGet(HttpServletRequest request, HttpServletResponse response){
		try{
		    Enumeration e = request.getParameterNames();
		    while(e.hasMoreElements()){
		        String tmp = (String) e.nextElement();
		        Logger.dev(this, tmp + "=" + request.getParameter(tmp));
		    }
		    String redirectUrl = request.getParameter("redirectUrl");
		    String imageId = request.getParameter("imageId");
		    JobSession js = new JobSession(imageId);
		    Enumeration other = request.getParameterNames();
		    Hashtable p = new Hashtable();
		    while(other.hasMoreElements()){
		        String tmp = (String) other.nextElement();
		        if(!tmp.equals("redirectUrl"))
		            if(!tmp.equals("imageId"))
		                p.put(tmp, request.getParameter(tmp));
		    }
		    js.setParameters(p);
		    request.getSession().setAttribute(JobSession.class.getName(), js);
		    Logger.dev(this, "Send URLRedirect: " + redirectUrl);
		    response.sendRedirect(redirectUrl);
		}
		catch(Exception e){ System.out.println("SetJob Error last line"+e.getMessage());}
		
	}
}

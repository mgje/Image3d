/*
 * Created on 03.12.2004 by florian
 */
package goodpractice.povwww.web.filter;

import java.io.*;
import javax.servlet.http.*;
import goodpractice.povwww.fs.*;
import goodpractice.povwww.*;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

public class CookieFilter implements Filter {


    String[] seed = {"n","a","n","o","n","c","c","r"};
   // private String cookieRegEx = 
   //     "[a-z]*[0-9]*";
    
    
	/* (non-Javadoc)
	 * @see javax.servlet.Filter#init(javax.servlet.FilterConfig)
	 */
	public void init(FilterConfig arg0) throws ServletException {
		// do nothing

	}

	/* (non-Javadoc)
	 * @see javax.servlet.Filter#doFilter(javax.servlet.ServletRequest, javax.servlet.ServletResponse, javax.servlet.FilterChain)
	 */
	public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain chain) throws IOException, ServletException {
	    
	    Logger.dev(this, "doFilter()");
	    HttpServletRequest req = (HttpServletRequest)request;
		HttpServletResponse res = (HttpServletResponse) response;
		
		//String encoding="UTF-8";
		//req.setCharacterEncoding(encoding);
		
		/* 1. custom cookie request?
		 * 2. if no custom request, set cookie if not allready set
		 */
		
		String customId = req.getParameter(Constants.RESTORE_COOKIE_PARAMETER);
		
		if ( customId != null ){
		    Logger.dev(this, "Custom Id Request, process...");
		    if(customId.matches(Constants.COOKIE_REGEXP)){
		        Logger.app(this, "Restore CustId: " + customId);
		        if(FSReader.userExists(customId)){
		        	
		            Cookie toSet = new Cookie(Constants.COOKIE_NAME, customId);
		            toSet.setMaxAge(Integer.MAX_VALUE);
		            res.addCookie(toSet);
		            Logger.dev(this, "New Cookie added:"+toSet.getName());
		            req.getSession().setAttribute(Constants.FEEDBACK_PARAMETER,"ID successfully restored.");
		        }
		        else{
		            req.getSession().setAttribute(Constants.FEEDBACK_PARAMETER,"The ID you have requested doesn't exist. No changes made.");
		            Logger.dev(this, "The ID you have requested doesn't exist. No changes made.:");
		        }
		        res.sendRedirect(req.getRequestURL().toString());
		    }
		    else{
		        Logger.app(this, "Restore CustId failed: irregular name");
		        req.getSession().setAttribute(Constants.FEEDBACK_PARAMETER,"Invalid ID restore request: bad ID format.");
		        //res.sendError(HttpServletResponse.SC_BAD_REQUEST, "The specified ID doesn't match the cookies regular expression");
		        Logger.dev(this, "Invalid ID restore request: bad ID format.");
		        res.sendRedirect(req.getRequestURL().toString());
		    }
		}
		else{
		    Logger.dev(this, "Iterate cookies...");
		    Cookie[] cookies = req.getCookies();
		    boolean cookieOk = false;
		    for(int i = 0; cookies!=null && i <  cookies.length && !cookieOk; i++){
		        if( cookies[i].getName().equals(Constants.COOKIE_NAME) )
		            cookieOk = true;
		    }
		    if(cookieOk){
		        Logger.app(this, "Image3d  Cookie found. Continue Filter Chain.");
		        chain.doFilter(request, response);
		        
		    }
		    else{
		        Logger.app(this, "Image3d Cookie Not Found. Creating new cookie...");
		        String newId = getRandom();
		        Logger.dev(this, "Cookie Name in CookieFilter: " + Constants.COOKIE_NAME);
		        Cookie newCookie = new Cookie(Constants.COOKIE_NAME, newId);
		        newCookie.setMaxAge(Integer.MAX_VALUE);
		        FSWriter.initUser(newId);
		        res.addCookie(newCookie);
		        res.sendRedirect(req.getRequestURL().toString());
		    }
		}
	}

	
	
	public String getRandom(){
	    String retVal = "";
	    for(int i = 0; i < seed.length; i++){
	        retVal += seed[((int)(Math.random()*seed.length))%seed.length];
	    }
	    retVal += String.valueOf(System.currentTimeMillis());
	    return retVal;    
	}
	
	
	
	public void destroy() {
	    	// do nothing
	}
	


}

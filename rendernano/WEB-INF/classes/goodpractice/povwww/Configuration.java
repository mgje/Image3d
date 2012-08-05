/*
 * Created on 04.12.2004 by florian
 */
package goodpractice.povwww;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import goodpractice.povwww.Constants;


/**
 * 
 * @author florian
 *
 * Holds the basic configuration of the application.
 */
public class Configuration {
    


	public static final String LIB_PREFIX = Constants.LIB_PREFIX;
	public static final String POVRAY = Constants.POVRAY;
    public static final int TEMPLATE_TYPE_POV = 0;
    public static final int TEMPLATE_TYPE_INI = 1;
    public static final int TEMPLATE_TYPE_MOV_POV = 2;
    public static final int TEMPLATE_TYPE_MOV_INI = 3;
    
    

    private static String appBase = goodpractice.povwww.Constants.APP_BASE;
    private static String appWWWURL = goodpractice.povwww.Constants.APP_WWW_URL;
    private static String userBase = goodpractice.povwww.Constants.USER_BASE;
    private static String scriptBase = goodpractice.povwww.Constants.APP_WWW_URL+"scripts/";
    
    
    
    //private static String scriptFsBase = "/var/lib/tomcat5/webapps/image3d/scripts/";
    private static String scriptFsBase = goodpractice.povwww.Constants.SCRIPT_BASE_FS;

    private Configuration(){}
    
    
    private static String[] templateLocator = 
    	{ "baseImageScript.pov", "baseImageIni.ini","baseMovieScript.pov","baseMovieIni.ini"};

	public static String getUser(HttpServletRequest request){
	    Cookie[] cookies = request.getCookies();
	    for(int i = 0; i < cookies.length; i++){
	        Logger.app(new Configuration(), "Cookie: " + cookies[i].getName());
	        if(cookies[i].getName().equals(Constants.COOKIE_NAME)){
	            return cookies[i].getValue();
	        }
	    }
	    Logger.app(new Configuration(), "Hier gibt es kein Cookie");
		return null;
	}
	

	
	public static String getUserHome(HttpServletRequest request){
	    
	    return userBase + getUser(request) + "/";
	}
	
	
	
	public static String stripExtension(String fName){
	    return fName.substring(0,fName.lastIndexOf("."));
	}
	
	public static String getTemplateLocator(int type){
	    return scriptBase + templateLocator[type];
	}
	
	public static String getTemplateLocatorFs(int type){
	    return scriptFsBase + templateLocator[type];
	}
	
	public static String getAppHome(){
	    return appBase;
	}
	
	
	public static String getAppName(){
	    return "Image3d";
	}
	
	public static String getAppBaseURL(){
	    return appWWWURL;
	}



	public static String getmencoder() {
		
		return "/usr/bin/mencoder ";
	}



	public static String getffmpeg() {
		return "/usr/local/bin/ffmpeg ";
	}
	
}

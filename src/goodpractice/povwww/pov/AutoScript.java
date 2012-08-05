/*
 * Created on 07.12.2004 by florian
 */
package goodpractice.povwww.pov;

import javax.servlet.http.*;
import goodpractice.povwww.*;
import java.io.*;
import java.util.Hashtable;
import java.util.Enumeration;
import java.net.URL;
import java.util.regex.*;
/**
 * Creates a script for a render request.
 * @author florian
 *
 */

public class AutoScript implements Script {
    
    
    
    private HttpServletRequest request;
    private String scriptOutFile;
	private String iniOutFile;
	
	private int povType;
	private int iniType;

    
    public AutoScript(String imageName, String userHome, HttpServletRequest request, int povType, int iniType){
		this.request = request;
		this.povType = povType;
		this.iniType = iniType;
		scriptOutFile = userHome + Constants.DIR_MEASURE + imageName + ".pov";
		iniOutFile =  userHome + Constants.DIR_MEASURE + imageName + ".ini";
	}
    
    public String getScriptLocator(){	return scriptOutFile;	}
    public String getScriptName(){		return scriptOutFile;				}
    public String getIniLocator(){		return iniOutFile;		}
    public String getIniName(){			return iniOutFile;					}
	
	public void build() throws IOException{
	    /* read .pov template and create .pov script, line by line */
	    File sof = new File(scriptOutFile);
	    File iof = new File(iniOutFile);
	    if(sof.exists()) sof.delete();
	    if(iof.exists()) iof.delete();
	    
	    URL povUrl = new URL(Configuration.getTemplateLocator(povType));
	    
	    BufferedReader in = new BufferedReader(new InputStreamReader(povUrl.openStream()));
		PrintWriter out = new PrintWriter(new FileWriter(sof));
		StringBuffer povScr = new StringBuffer();
		for(String tmp = in.readLine(); tmp != null; tmp = in.readLine())
		    povScr.append(tmp + "\n");
		ParameterMatcher pm = new ParameterMatcher(request);
		out.println(pm.matchRequest(povScr.toString()));
		out.flush();

		URL iniUrl = new URL(Configuration.getTemplateLocator(iniType));
		in = new BufferedReader(new InputStreamReader(iniUrl.openStream()));
		out = new PrintWriter(new FileWriter(iof));
		StringBuffer iniScr = new StringBuffer();
		for(String tmp = in.readLine(); tmp != null; tmp = in.readLine()){
		    iniScr.append(tmp + "\n");
		}
		out.println(pm.matchRequest(iniScr.toString()));
		out.flush();
	}
	
}

class ParameterMatcher{
    
    private Pattern REGEX = Pattern.compile("#@[^@]*@");
    
    
    private Hashtable params;
    
    
    
    public ParameterMatcher(HttpServletRequest request){
        params = new Hashtable();
        Enumeration paraenum = request.getParameterNames();
        while(paraenum.hasMoreElements()){
            String tmp = paraenum.nextElement().toString();
            params.put(tmp, request.getParameter(tmp));
        }  
    }
    
    
    public String matchRequest(String text){
        Matcher matcher = REGEX.matcher(text);
        while(matcher.find()){
            /* get next parameter in script */
            String occurence = matcher.group();
            //System.out.println("Occurence: " + occurence);
            /* find out parameter value from hashtable ("request-loaded") */
            String param = null;
            if(occurence.indexOf(":")>=0){
                String[] tmp = occurence.split(":");
                param = tmp[0];
            }
            else{
                param = occurence;
            }
            param = param.replaceAll("#?@","");
            String value = (String) params.get(param);
            Logger.app(this, "Replacing \"" + param + "\" with \"" + value + "\"");
            occurence = escapeForRegex(occurence);
            Logger.app(this, "Occurence stripped: " + occurence);
            Matcher mt = Pattern.compile("#@" + param + "[^@]*@").matcher(text);
            Logger.dev(this, "Value to fill in: " + value);
            text = mt.replaceAll(value);
            
            //System.out.println(text);
        }
        Logger.app(this, "Resulting TEXT: " + text);
        return text;
    }
    
    private String escapeForRegex(String str){
        str = str.replaceAll("[\\{\\}\\[\\]]","[^@]");
        return str;
    }
    

}
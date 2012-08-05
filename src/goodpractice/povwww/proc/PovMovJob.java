/*
 * Created on 03.12.2004 by florian
 */
package goodpractice.povwww.proc;


import goodpractice.povwww.pov.*;
import goodpractice.povwww.Constants;
import goodpractice.povwww.Logger;

public class PovMovJob implements I_Job{

	//public static final String LIB_PREFIX = "/usr/local/share/povray-3.6/include";
	//public static final String POVRAY = "/usr/local/bin/povray";
	
	private String cmd;
	private String libArg;
	private Script script;
	private String outArg;
	

	public PovMovJob(){
		cmd =  Constants.POVRAYMOV;
		libArg = Constants.LIB_PREFIX;
	}
	
	public PovMovJob(String outFile, Script script){
		
		cmd = Constants.POVRAYMOV;
		libArg = Constants.LIB_PREFIX;
		outArg = outFile;
		this.script = script;
	}
	
	
	public String getCommand(){
		return cmd + " " + script.getIniLocator() + " +L" + libArg + " +I" + script.getScriptLocator() + " +O" + outArg;
	}
	
	
	
	public void setCmd(String cmd){
		this.cmd = cmd;
	}
	public void setLibPrefix(String libPrefix){
		libArg = libPrefix;
	}

}
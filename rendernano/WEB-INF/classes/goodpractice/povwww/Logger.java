/*
 * Created on Jan 21, 2005 by florian
 */
package goodpractice.povwww;

import java.io.*;
import java.util.Calendar;

public class Logger {
    
    private static File logFile = new File("/var/log/tomcat5/logpovwwwImage3dAppLog");
    private static PrintWriter pw;
    
    static{
        try{
        	//System.out.println("Important Logfile:"+logFile);
            pw = new PrintWriter(new FileWriter(logFile));
        }
        catch(Exception e){
        	System.out.println(e.getClass()+"Error: could not create logFile"+e.getMessage());
        }
    }
    

    public static void app(Object caller, String msg){
        try{
            String partClass = getPartName(caller);
            synchronized(logFile){
                pw.println("[APP]" + getDateStr() + partClass + ": " + msg);
                pw.flush();
            }
        }
        catch(Exception e){System.out.println(e.getClass()+"Error: app does not work"+e.getMessage());}
    }
    
    public static void dev(Object caller, String msg){
        try{
            String partClass = getPartName(caller);
            synchronized(logFile){
                pw.println("[DEV]" + getDateStr() + partClass + ": " + msg);
                pw.flush();
            }
        }
        catch(Exception e){System.out.println(e.getClass()+"Error: dev does not work"+e.getMessage());}
    }
    

    
    public static void appTrace(Object caller, Exception e, int depth){
        StackTraceElement[] elem = e.getStackTrace();
        String partClass = getPartName(caller);
        synchronized(logFile){
            pw.println("[APP]Stack Trace for " + partClass + ":");
            for(int i = 0; i <= depth && i < elem.length; i++){
                pw.println("[APP]\t" + elem[i].toString());
            }
        }
    }
    
    public static void devTrace(Object caller, Exception e, int depth){
        StackTraceElement[] elem = e.getStackTrace();
        String partClass = getPartName(caller);
        synchronized(logFile){
            pw.println("[DEV]Stack Trace for " + partClass + ":");
            for(int i = 0; i < depth && i < elem.length; i++){
                pw.println("[DEV]\t" + elem[i].toString());
            }
        }
    }
    
    
    private static String getPartName(Object o){
        String full = o.getClass().toString();
        String part = full.substring(full.lastIndexOf(".")+1);
        return part;
    }
    
    private static String getDateStr(){
       Calendar c = Calendar.getInstance();
       String retVal = c.get(Calendar.HOUR_OF_DAY) + ":" + c.get(Calendar.MINUTE);
       return "[" + retVal + "]";
       
    }
    
   
    
}

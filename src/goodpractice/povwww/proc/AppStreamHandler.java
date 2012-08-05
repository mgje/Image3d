/*
 * Created on 04.12.2004 by florian
 */
package goodpractice.povwww.proc;

import java.io.*;

public class AppStreamHandler extends Thread {
	
	private BufferedReader reader;
	private StringBuffer sb;
	private String prefix;
	
	private boolean running = true;
	
	public AppStreamHandler(InputStream stream, StringBuffer sb, String prefix) {
		try{
			reader = new BufferedReader(new InputStreamReader(stream));
			this.sb = sb;
			this.prefix = prefix;
		}
		catch(Exception e){
			System.out.println("Error AppStreamHandler:"+e.getMessage());
		}
		
	}
	
	
	public void run(){
		sb.append(prefix + "-LOGGER running...");
		String line = "";
		try{
			while(running){
				line = reader.readLine();
				if(line==null){
					try{ sleep(100);}catch(InterruptedException e2){}
				}
				else{
					sb.append(prefix + ": " + line + "<br>");
				}
			}
			sb.append(prefix + "-LOGGER done!");
		}catch(Exception e){ System.out.println(e);}
	}
	
	
	public void setRunning(boolean running){
		this.running = running;
	}

}

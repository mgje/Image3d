/*
 * Created on 06.12.2004 by florian
 */
package goodpractice.povwww.proc;

public class MEncoderJob implements I_Job{

    	private String cmd;
    	
    	public MEncoderJob(String cmd){
    	    this.cmd = cmd;
    	}

    	public String getCommand() {
    	    return cmd;
    	}

 
    	public void setCmd(String cmd) {
    	    this.cmd = cmd;
    	}

    	public void setLibPrefix(String libPrefix) {
        	// fix interface: shouldn't have povray-specifix libPrefix
    	}
    
    

}

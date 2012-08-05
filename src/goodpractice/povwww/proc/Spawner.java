/*
 * Created on 03.12.2004 by florian
 */
package goodpractice.povwww.proc;


public class Spawner {

	public static final String POV_APP = "";
	public static final String LIB_PREFIX = "";
	
	public static StringBuffer LOG = new StringBuffer();
	
	
	public static int spawn(I_Job job) throws Exception{
		Runtime rt = Runtime.getRuntime();
		Process proc = rt.exec(job.getCommand());
		
		AppStreamHandler err = new AppStreamHandler(proc.getErrorStream(), Spawner.LOG, "-");
		AppStreamHandler in  = new AppStreamHandler(proc.getInputStream(), Spawner.LOG, "+");
		
		err.start();in.start();

		int exVal = proc.waitFor();
		
		err.setRunning(false); in.setRunning(false);
		
		return exVal;
	}
	
	
}

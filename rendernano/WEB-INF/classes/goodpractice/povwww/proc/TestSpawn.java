/*
 * Created on 03.12.2004 by florian
 */
package goodpractice.povwww.proc;

public class TestSpawn{


	public static void testSpawn() throws Exception{

	Runtime rt = Runtime.getRuntime();
	String cmd = "/usr/local/bin/povray +L/usr/local/share/povray-3.5/include +I/usr"
		+	"/local/share/povApp/users/florian/script.pov +O/usr/local/share/povApp/users/flo"
		+	"rian/render_local.jpg";
	rt.exec(cmd);

	}
}
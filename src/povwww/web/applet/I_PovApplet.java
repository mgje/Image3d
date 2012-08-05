/*
 * Created on 10.12.2004 by florian
 */
package povwww.web.applet;

public interface I_PovApplet {

    public java.awt.Dimension getDimensions();
    
    public String getConfiguration();
    
    public void setConfiguration(String str);
    
}

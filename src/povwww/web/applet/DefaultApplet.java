/*
 * Created on Jun 17, 2005 by florian
 */
package povwww.web.applet;

import java.awt.Dimension;

import javax.swing.JApplet;

public abstract class DefaultApplet extends JApplet implements I_PovApplet {

    /* (non-Javadoc)
     * @see povwww.web.applet.I_PovApplet#getDimensions()
     */
    
    protected int WIDTH = 80;
    protected int HEIGHT = 80;
    public Dimension getDimensions() {
        return new Dimension(WIDTH, HEIGHT);
    }


    public abstract String getConfiguration();
    public abstract void setConfiguration(String str);


}

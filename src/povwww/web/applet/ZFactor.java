/*
 * Created on 10.12.2004 by florian
 */
package povwww.web.applet;

import javax.swing.*;
import java.awt.*;
import java.util.Hashtable;

import javax.swing.event.*;

public class ZFactor extends DefaultApplet {

    /* (non-Javadoc)
     * @see povwww.applet.I_PovApplet#getDimensions()
     */

    /**
	 * 
	 */
	private static final long serialVersionUID = 4173999884521756403L;
	
	static Hashtable colors = new Hashtable();
	
	static {
	  colors.put("RED", Color.RED);
	  colors.put("GREEN", Color.GREEN);
	  colors.put("BLUE", Color.BLUE);
	  colors.put("YELLOW", Color.YELLOW);
	  colors.put("BLACK", Color.BLACK);
	  colors.put("WHITE", Color.WHITE);
	  colors.put("ORANGE", Color.ORANGE);
	  colors.put("LIGHTGRAY", Color.LIGHT_GRAY);
	}



	private WaveCanvas wc;
    private JSlider jsl;
    private Color bgColor = Color.WHITE;
                            
   
    public String getConfiguration(){
        return String.valueOf((double)wc.getZFactor()/10/2);
    }

    public void setConfiguration(String config){
        double p = Double.parseDouble(config);
        //System.out.println(this.getClass()+"WERT ZFaktor:"+p);
        //int p = Integer.parseInt(config);
        wc.setZFactor((int)(p*10*2));
        jsl.setValue((int)(p*10*2));
    }
    
    public void start(){
     jsl = new JSlider(JSlider.VERTICAL,1,20,1);
     jsl.setBackground(Color.WHITE);
     getContentPane().setLayout(new BorderLayout());
     getContentPane().add(jsl, BorderLayout.WEST);
     wc = new WaveCanvas();
     if(getParameter("background-color")!=null){
         String cn = getParameter("background-color");
         try{
             bgColor = this.getMapColor(cn.toUpperCase());
         }catch(Exception e){ System.out.println(e.getClass()+"Couldn't decode color: " + cn);}
     }
     wc.setBgColor(bgColor);
     jsl.addChangeListener(wc);
     //wc.setSize(new Dimension(100,100));
     wc.setMinimumSize(new Dimension(300,300));
     getContentPane().add(wc, BorderLayout.CENTER);
    }

	

	public static Color getMapColor(String c) {
	  Color x = (Color) colors.get(c);  // convert character to string and lookup
	  if (x == null)
	    return Color.BLACK;
	  return x;
	}




    
    
    

    
    
}

class WaveCanvas extends JComponent implements ChangeListener{
    
    /**
	 * 
	 */
	private static final long serialVersionUID = 1142497095743172873L;
	private int zFactor = 1;
    private Color bgColor;
    
    public WaveCanvas(){}
    
 
    public void setZFactor(int zFactor){
        this.zFactor = zFactor;
    }
    
    public int getZFactor(){
        return zFactor;
    }
    
    public void setBgColor(Color color){
        bgColor = color;
    }
    
    
    private int[] zMulti = {2,4,7,4,3,5,8,6};
    public void paint(Graphics g){
      int height = getHeight();
      int width = getWidth();
      g.setColor(bgColor);
      g.fillRect(0,0,width,height);
      g.setColor(Color.WHITE);
      
      for(int i = 0; i < zMulti.length; i++){
          Polygon p = new Polygon();
          p.addPoint(10*i,height);
          p.addPoint(10*i+5,height-zMulti[i]*zFactor/2);
          p.addPoint(10*i+10,height);
          g.fillPolygon(p);
      }
      g.setColor(Color.BLACK);
      g.setFont(new Font(getFont().getName(),Font.BOLD,11));
      String factStr = ((float)zFactor/(float)2)+"x";
      g.drawString(factStr, 30,15);
    }
    
    
    public void stateChanged(ChangeEvent event){
        JSlider sl = (JSlider) event.getSource();
        setZFactor(sl.getValue());
        //System.out.println(zFactor);
        paint(getGraphics());
    }
 
    
}

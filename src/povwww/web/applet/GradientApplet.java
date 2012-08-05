/*
 * Created on Jan 28, 2005 by florian
 */
package povwww.web.applet;

import java.awt.Color;
import java.awt.Component;
import java.awt.Dimension;
import java.awt.GradientPaint;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.lang.reflect.Field;
import java.util.*;


import javax.swing.*;

public class GradientApplet extends DefaultApplet {

    /**
	 * 
	 */
	private static final long serialVersionUID = -6018770403037844912L;
	public static final int HEIGHT = 80;
    public static final int WIDTH = 100;
    
    private JComboBox comboBox;
    
    private List colorArgList;
    private ColorParam[] items;
    
    public void init(){
        int i = 0; //used to iterate over all given applet parameters
        String pValue = "";
        colorArgList = new ArrayList();
        while( (pValue = this.getParameter("value" + i)) != null){
            String label = getParameter("label" + i);// see if we also have a label for the value
            // povray color arguments come as [intOffset color colorName][intOffset color colorName] etc.
            StringTokenizer st = new StringTokenizer(pValue,"[]");
            List tmpList = new ArrayList();
            while(st.hasMoreTokens()){
                String tmp = st.nextToken();
                /*
                 * Possible Color Formats:
                 * [nr color cName}
                 * [nr color rgb <r,g,b>
                 */
                if(tmp.indexOf("rgb")>0){
                    try{
	                    String seq = tmp.substring(tmp.indexOf("<")+1, tmp.indexOf(">"));
	                    //System.out.println("Sequence: " + seq);
	                    StringTokenizer sst = new StringTokenizer(seq, ",");
	                    float r = Float.parseFloat(sst.nextToken());
	                    float g = Float.parseFloat(sst.nextToken());
	                    float b = Float.parseFloat(sst.nextToken());
	                    //System.out.println("r=" + r + ",g=" + g + ",b=" + b);
	                    tmpList.add(new Color(r, g, b));
                    }
                    catch(Exception e){
                        System.out.println(e.getClass()+"GradientApplet init Error"+e.getMessage());
                    }
                }
                else{
                    String cName = tmp.substring(tmp.lastIndexOf(" ")+1).trim(); // that's the color name, see format above                
                    Field[] fields = Color.class.getFields();
                    for(int j = 0; j < fields.length; j++){
                        if(fields[j].getName().equalsIgnoreCase(cName)){
                            try{
                                tmpList.add((Color)(Color.class.getField(fields[j].getName()).get(null)));
                            }catch(IllegalAccessException e){
                            	System.out.println(e.getClass()+"Error Gradient Applet"+e.getMessage());
                            }
                             catch(NoSuchFieldException e){
                            	 System.out.println(e.getClass()+"Error Gradient Applet"+e.getMessage());
                             }
                        }
                    }
                }
            }
            colorArgList.add(new ColorParam(label, pValue, tmpList));
            ++i;
        }
        items = new ColorParam[colorArgList.size()];
        for(int j = 0; j < items.length; j++){
            items[j] = (ColorParam) colorArgList.get(j);
        }
        
        // now we have all arguments, create the ComboBox and set the Renderer
        comboBox = new JComboBox(items);
        comboBox.setBackground(Color.WHITE);
        GradientRenderer r = new GradientRenderer();
        r.setPreferredSize(new Dimension(WIDTH, HEIGHT));
        r.setBackground(Color.WHITE);
        comboBox.setRenderer(r);
        comboBox.setMaximumRowCount(3);
        getContentPane().add(comboBox);
        
    }
    
    public void start(){
        
    }
    

    /* (non-Javadoc)
     * @see povwww.web.applet.I_PovApplet#getConfiguration()
     */
    public String getConfiguration() {
        return items[comboBox.getSelectedIndex()].getOriginalParam();
    }
    
    public void setConfiguration(String config){
        int indexToSet = 0;
        for(int i = 0; i < items.length; i++){
            String tmp = items[i].getOriginalParam();
            if(tmp.equals(config)){
                indexToSet = i;
                break;
            }
        }
        comboBox.setSelectedIndex(indexToSet);
        repaint();
    }

}

/*
 * Use this as ComboBox item. Contains GradientList and label, maybe 
 * later we could add distance information (so the gradient width wouldn't 
 * be arbitrary)
 */
class ColorParam{
    private String label;
    private List list;
    private String originalParam;
    
    public ColorParam(String label, String originalParam, List list){
        this.label = label;
        this.originalParam = originalParam;
        this.list = list;
    }
    
    public String getLabel(){	return label;	}
    public List getList(){		return list;	}
    public String getOriginalParam(){ return originalParam;	}
}


/* ListCellRenderer for the ComboBox. sets Icon and Text as well 
 * as cell alignment
 */
class GradientRenderer extends JLabel implements ListCellRenderer{
    
    /**
	 * 
	 */
	private static final long serialVersionUID = 6117428637092399514L;
	private ColorParam current;
    
    public Component getListCellRendererComponent(JList list,
            	Object value, int index, boolean isSelected,
            	boolean hasCellFocus){
        
        current = (ColorParam) value;
        int nOfColors = current.getList().size();
        float gradSize = 90/ (nOfColors-1);
        List gradients = new ArrayList();
        ListIterator it = current.getList().listIterator();
        int gradPos = 0;
        while(it.hasNext()){
            Color cur = (Color) it.next();
            if(it.hasNext()){ // even number, get next gradient
                Color nxt = (Color) it.next();
                gradients.add(new GradientPaint(gradPos,0,cur, gradPos+gradSize,0, nxt));
                it.previous();
                gradPos += gradSize;
            }
            else if(!it.hasPrevious()){ // first and only
                gradients.add(new GradientPaint(gradPos-gradSize,0,cur,gradPos,0,cur));
            }
        }
        setVerticalTextPosition(SwingConstants.BOTTOM);
        setHorizontalTextPosition(SwingConstants.CENTER);
        if(gradients.size()>0){
            setIcon(new GradientIcon((int)gradSize, gradients));
            setText(current.getLabel());
        }
        else{
            List tmp = new ArrayList();
            tmp.add(new GradientPaint(0,0,Color.WHITE,0,100,Color.WHITE));
            setVerticalTextPosition(SwingConstants.CENTER);
            setIcon(new GradientIcon((int)gradSize,tmp));
            setText(current.getLabel() + " (no preview available)");
        }
        setIconTextGap(10);
        setBorder(null);
        //setText(current.toString());
        return this;
    }
    

    
}

/*
 * actually paints the gradient and is the icon of the ListCell 
 */
class GradientIcon implements Icon{
    
    private int gradSize;
    private List gradients;
    
    
    public GradientIcon(int gradSize, List gradients){
        this.gradSize = gradSize;
        this.gradients = gradients;
    }
    
    
    public void paintIcon(Component c, Graphics g, int x, int y){
        Graphics2D g2d = (Graphics2D) g;
        int gradPos = 0;
        for(int i = 0; i < gradients.size(); i++){
           // GradientPaint curG = (GradientPaint)gradients.get(i);
            g2d.setPaint((GradientPaint)gradients.get(i));
            g2d.fillRect(gradPos,0,(int)gradSize,80);
            gradPos += gradSize;
        }
    }
    
    
    
    public int getIconHeight(){
        return 80;
    }
    public int getIconWidth(){
        return 80;
    }
}
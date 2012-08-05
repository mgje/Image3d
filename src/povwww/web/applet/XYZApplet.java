/*
 * Created on 09.12.2004 by florian
 */
package povwww.web.applet;

import java.awt.*;
import java.awt.event.*;
import java.util.*;


public class XYZApplet extends DefaultApplet implements MouseListener, MouseMotionListener{
    
    
    
    /**
	 * 
	 */
	private static final long serialVersionUID = -8808434978465679984L;

	private Point[] points;
    
    private Point[] cameras;
    private String[] labels;
    private int selectedCam;
    
    private int cHeight = 8;
    private int cWidth = 8;
    
    
    private boolean labelPainted;
    
    public XYZApplet(){}
    
    
    
    public void init(){
        addMouseListener(this);
        addMouseMotionListener(this);
        points = new Point[8];
        points[0] = getPoint(-1,-1,-1);
        points[1] = getPoint(1,-1,-1);
        points[2] = getPoint(1,1,-1);
        points[3] = getPoint(-1,1,-1);
        points[4] = getPoint(-1,-1,1);
        points[5] = getPoint(1,-1,1);
        points[6] = getPoint(1,1,1);
        points[7] = getPoint(-1,1,1);   
        
        ArrayList cams = new ArrayList();
        ArrayList labs = new ArrayList();
        String camArg = "value";
        String labArg = "label";
        int i = 0;
        String pValue = "";
        while( (pValue = this.getParameter(camArg + i)) != null){
            cams.add(pValue);
            labs.add(getParameter(labArg + i));
            ++i;
        }
        cameras = new Point[cams.size()];
        labels = new String[cameras.length];
        
        for(i = 0; i < cameras.length; i++){
            StringTokenizer st = new StringTokenizer(cams.get(i).toString(),",");
            int ax = Integer.parseInt(st.nextToken());
            int ay = Integer.parseInt(st.nextToken());
            int az = Integer.parseInt(st.nextToken());
            cameras[i] = getPoint(ax, ay, az);
            labels[i] = labs.get(i).toString();
        }
    }
    
    
    public void start(){
        
    }
    
    
    
    public void paint(Graphics g){
        //System.out.println(this.getClass()+"paint");
        g.setColor(Color.WHITE);
        g.fillRect(0,0,getWidth(),getHeight());
        g.setColor(Color.BLACK);
        
        Polygon[] cube = new Polygon[6];
        cube[0] = getPolygon(0,1,2,3);//front
        cube[1] = getPolygon(4,5,6,7);//back
        cube[2] = getPolygon(0,4,7,3);//left
        cube[3] = getPolygon(1,5,6,2);//right
        cube[4] = getPolygon(3,2,6,7);//top
        cube[5] = getPolygon(0,1,5,4);//bottom
        for(int i = 0; i < cube.length; i++){
            g.drawPolygon(cube[i]);
        }
        // redraw inner lines
        
        
        
        // draw cameras
        g.setColor(Color.GRAY);
        for(int i = 0; i < cameras.length; i++){
            int X = (int)cameras[i].getX() - cWidth/2;
            int Y = (int)cameras[i].getY() - cHeight/2;
            if(i == selectedCam){
                Color tmp = g.getColor();
                g.setColor(Color.GREEN);
                g.fillOval(X,Y,cWidth,cHeight);
                g.setColor(tmp);
            }
            else{
                g.fillOval(X,Y,cWidth,cHeight);
            }
        }
        labelPainted = false;
        
        
    }
    
    /*
     * translate 3d-point <x,y,z> to java 2d point <x,y>
     */
    public Point getPoint(int x, int y, int z){
        int originX = 20;
        int originY = 60;
        int middleX = originX + 20;
        int middleY = originY - 20;
        int X = middleX, Y = middleY;
        Point retVal = new Point();
        if ( x > 0 )
            X += 20;//originX += 50;
        else if( x < 0)
            X -= 20;
        if ( y > 0 )
            Y -= 20;
        else if( y < 0)
            Y += 20;
        if ( z > 0 ){
            X += 10;
            Y -= 10;
        }
        else if(z < 0 ){
            X -= 10;
            Y += 10;
        }
        retVal.setLocation(X, Y);
        return retVal;
    }
    
    public Polygon getPolygon(int a, int b, int c, int d){
        Polygon retVal = new Polygon();
        retVal.addPoint((int)points[a].getX(),(int)points[a].getY());
        retVal.addPoint((int)points[b].getX(),(int)points[b].getY());
        retVal.addPoint((int)points[c].getX(),(int)points[c].getY());
        retVal.addPoint((int)points[d].getX(),(int)points[d].getY());
        return retVal;
    }
    
    
   
    
    public String getConfiguration(){
        return getParameter("value" + selectedCam);
    }
    

    public void setConfiguration(String config){
        for(int i = 0; i < cameras.length; i++){
            String toCompare = getParameter("value" + i);
            if(toCompare.equals(config)){
                selectedCam = i;
            	update(getGraphics());
            	break;
            }
        }
        
    }
    /* used to select camera locations */
    public void mouseClicked(MouseEvent evt){
        Point p = new Point(evt.getX(), evt.getY());
        for(int i = 0; i < cameras.length; i++){
            if(cameras[i].distance(p.getX(), p.getY()) < 5){
                selectedCam = i;
                update(getGraphics());
                break;
            }
        }
    }
    
    
    
    public void mouseEntered(MouseEvent evt){}
    public void mouseExited(MouseEvent evt){}
    public void mousePressed(MouseEvent evt){}
    public void mouseReleased(MouseEvent evt){}
    
    
    public void mouseDragged(MouseEvent evt){}
    
    /* used to display camera names (labels) */
    public void mouseMoved(MouseEvent evt){
        Point p = new Point(evt.getX(), evt.getY());
        boolean closeToAnyone = false;
        for(int i = 0; i < cameras.length; i++){
          if(cameras[i].distance(p.getX(), p.getY()) <= 5){
            closeToAnyone = true;
            if(!labelPainted){
                Graphics g = getGraphics();
                FontMetrics fm = this.getFontMetrics(g.getFont());
                char[] tx = labels[i].toCharArray();
                int fontWidth = fm.charsWidth(tx,0,tx.length);
                int fontHeight = fm.getHeight();
                //int xOff = (int)p.getX();
                int xOff = 2;
                int yBottom = 78;
                //int yBottom = (int)p.getY();
                g.setColor(Color.decode("0xFFFACD"));
                int spacing = 2;
                g.fillRect(xOff, yBottom-fontHeight-2*spacing, fontWidth+4*spacing, fontHeight+2*spacing);
                g.setColor(Color.BLACK);
                g.drawRect(xOff, yBottom-fontHeight-2*spacing, fontWidth+4*spacing, fontHeight+2*spacing);
                g.setColor(Color.BLUE);
                g.drawString(labels[i], xOff+2*spacing, yBottom-spacing*2);
                labelPainted = true;
            }
          }
        }
        if(labelPainted && !closeToAnyone)
            this.update(getGraphics());
    }
    
    
    

}

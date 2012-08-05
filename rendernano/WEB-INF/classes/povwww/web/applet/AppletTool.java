/*
 * Created on 10.12.2004 by florian
 */
package povwww.web.applet;

import java.awt.Point;

public class AppletTool {
    
    private double scale;
    
    public AppletTool(){
        this(1);
    }
    public AppletTool(double scale){
        this.scale = scale;
    }
    public AppletTool(int scale){
        this((double)scale);
    }

    public  Point toJavaPoint(Point3D point){
       double x = point.getX();
       double y = -point.getY();
       System.out.println("AppletTool X: "  + x + ", Y: " + y);
       x += point.getZ()/2.0;
       y -= point.getZ()/2.0;
       Point p = new Point();
       p.setLocation(x*scale, y*scale);
       return p;
       
    }
    
    public  Point3D toPovrayPoint(Point2D point){
        return null;
    }
    
    
}

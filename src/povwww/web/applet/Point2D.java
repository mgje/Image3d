/*
 * Created on 10.12.2004 by florian
 */
package povwww.web.applet;

import java.awt.Point;

public class Point2D {
    
    private Point javaPoint;
    private Point3D povrayPoint;
    
    public Point2D(Point3D p){
        povrayPoint = p;
        AppletTool t = new AppletTool(10);
        javaPoint = t.toJavaPoint(p);  
    }
    
    public Point3D getPovrayPoint(){
        return povrayPoint;
    }

}

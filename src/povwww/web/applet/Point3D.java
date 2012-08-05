/*
 * Created on 10.12.2004 by florian
 */
package povwww.web.applet;

public class Point3D {

    private double x, y, z;
    
    public Point3D(int x, int y, int z){
        this.x = x;
        this.y = y;
        this.z = z;
    }
    
    public Point3D(double x, double y, double z){
        this.x = x;
        this.y = y;
        this.z = z;
    }
    
    
    
    
    public double getX(){	return x;	}
    public double getY(){	return y;	}
    public double getZ(){	return z;	}
    
    
    public void setX(int x){	this.x = x;	}
    public void setX(double x){	this.x = x;	}
    public void setY(int y){	this.y = y;	}
    public void setY(double y){	this.y = y;	}
    public void setZ(int z){	this.z = z;	}
    public void setZ(double z){	this.z = z;	}
    
    
}

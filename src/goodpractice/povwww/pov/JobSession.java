/*
 * Created on Mar 25, 2005 by florian
 */
package goodpractice.povwww.pov;

import java.util.*;

public class JobSession {
    
    private String imageId;
    
    private Hashtable parameters;
    
    public JobSession(String imageId){
        this.imageId = imageId;
    }
    
    public String getImageId(){
        return imageId;
    }
    public void setImageId(String imageId){
        this.imageId = imageId;
    }
    
    public Hashtable getParameter(){
        return parameters;
    }
    
    public void setParameters(Hashtable s){
        parameters = s;
    }

}

/*
 * Created on 09.12.2004 by florian
 */
package goodpractice.povwww.pov;

import java.awt.Dimension;

import povwww.web.applet.I_PovApplet;

import goodpractice.povwww.Logger;

public class Parameter {

    private boolean complex;
    private String name;
    private String[] values;
    private String[] labels;
    
    private String appletTag;
    
    
    public Parameter(String name){
        this(name, false);
    }
    public Parameter(String name, boolean complex){
        this.name = name;
        this.complex = complex;
    }
    
    public void setComplex(boolean complex){
        this.complex = complex;
    }
    
    public void setValues(String[] values){
        this.values = values;
    }
    public void setLabels(String[] labels){
        this.labels = labels;
    }
    
    public void setAppletTag(String appletArg){
        String appletClass = appletArg;
        Dimension dim = new Dimension(100,80);
        try{
            dim = ((I_PovApplet)(Class.forName(appletClass).newInstance())).getDimensions();
        }catch(Exception e){}
        appletTag = "<APPLET archive=\"/image3d/povwww.jar\" code=\"" + appletClass + ".class\" WIDTH=\"" 
        	+ ((int)dim.getWidth()) + "\" HEIGHT=\"" + ((int)dim.getHeight()) + "\">";
        String[] tmpVal = getValues();
        String[] tmpLab = getLabels();
        for(int i = 0; i < tmpVal.length; i++){
            appletTag += "<PARAM name=\"value" + i + "\" value=\"" + tmpVal[i] + "\">";
            appletTag += "<PARAM name=\"label" + i + "\" value=\"" + tmpLab[i] + "\">";
        }
        appletTag += "<PARAM name=\"background-color\" value=\"Blue\">";
        appletTag += "</APPLET>";
    }
    
    public String getAppletTag(){
        return appletTag;
    }
    
    public String getName(){
        return name;
    }
    public String[] getValues(){
        return values;
    }
    
    public String[] getLabels(){
        if(labels==null)
            return values;
        return labels;
    }
    
    public boolean isValid(){
        
        if(!complex)	return true;
        if(values==null)	return false;
        Logger.app(this,"labels.length=" + getLabels().length + " | values.length=" + getValues().length);
        if(getLabels().length!=getValues().length)	return false;
        return true;
    }
    
    public boolean isComplex(){
        return complex;
    }
    
    public boolean hasAppletTag(){
        return appletTag != null;
    }
    
    
    public String toString(){
        if(complex)
            return "Complex Parameter: " + name + "(" + (isValid() ? "valid" : "invalid") + ")";
        return "Simple Parameter: " + name;
    }
    
}

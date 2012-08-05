
package goodpractice.povwww.fs;


import java.io.*;
import java.util.List;
import java.util.ArrayList;
import goodpractice.povwww.Constants;
import goodpractice.povwww.Logger;


/**
 * @author florian
 * 
 * This class handles the server filesystem of the nano3d application. It provides 
 * methods to obtain filelist and names and to open streams to files.
 * 
 * 
 * 
 */



public class FSReader {

    private String[] defaultFilenameFilter = {"jpg", "jpeg", "tiff", "png"};
    
	private String basePath;
	
	private FSReader(){}
	
	public FSReader(String basePath){
		this.basePath = basePath;
		Logger.app(this, "BasePath: " + basePath);
	}
	
	public void setFilenameFilter(String[] filter){
	    defaultFilenameFilter = filter;
	}
	
	public String[] getFilenameFilter(){
	    return defaultFilenameFilter;
	}
	
	public boolean exists(String fileName){
	    File check = new File(basePath + getSubFolder(fileName) + fileName);
	    return check.exists();
	}
	
	
	public InputStream openStream(String fileName) throws IOException{
		return new FileInputStream(new File(basePath + getSubFolder(fileName) + fileName));
	}
	
	
	
	public String[] getFileNames(){
		Logger.app(this, "getfilname::"+basePath);
		File f = new File(basePath);
		try{
			File[] tmp = f.listFiles(new PovImageFilter(defaultFilenameFilter));
			String[] retVal = new String[tmp.length];
			for(int i = 0; i < retVal.length; i++){
				retVal[i] = tmp[i].getName();
			}
			return retVal;
		}
		catch(Exception e){
		    Logger.appTrace(this, e, 10);
		    return null;
		}
	}
	
	public String[] getDirectoryNames(){
	    File f = new File(basePath);
	    List l = new ArrayList();
	    File[] all = f.listFiles();
	    for(int i = 0; i < all.length; i++){
	        if(all[i].isDirectory()){
	            l.add(all[i]);
	        }
	    }
	    String[] retVal = new String[l.size()];
	    int i = 0;
	    while(!l.isEmpty()){
	        retVal[i++] = ((File)l.remove(0)).getName();
	    }
	    return retVal;
	}
	
	
	public static boolean userExists(String name){
	    File f = new File(Constants.USER_BASE + name);
	    if(f.exists())
	        return true;
	    return false;
	}
	
	
	/*
	 * This method is used for obtaining user files. In every user home,
	 * there are several subfolders: measurements, render, descriptions, thumbnail. 
	 * Measurements are stored in measurement, etc. While listing these subdirectories 
	 * requires the base path of the FSReader to be adapted (e.g. if you want to list 
	 * all files in measurements, you have to set the base path to userHome + measurement),
	 * the methods to obtain files don't. The name of the file tells its type, so the 
	 * FSReader will -by using the method getSubFolder() - automatically determine the 
	 * appropriate subfolder.
	 */
	
	private String getSubFolder(String filePattern){
	    if(filePattern.startsWith(Constants.PREFIX_RENDER))
	        return Constants.DIR_RENDER;
	    else if(filePattern.startsWith(Constants.PREFIX_THUMB))
	        return Constants.DIR_THUMB;
	    else if(filePattern.startsWith(Constants.PREFIX_DESCRIPTION))
	        return Constants.DIR_DESC;
	    return Constants.DIR_MEASURE;
	}
	
	
	
	
	
	
}


class PovImageFilter implements FilenameFilter{
	
	private String[] accepted;
	
	public PovImageFilter(String[] filter){
	    accepted = filter;
	}
	
	public boolean accept(File dir, String name){
	    if(accepted==null)
	        return true;
	    String extension = name.substring(name.lastIndexOf(".")+1);
		for(int i = 0; i < accepted.length; i++){
			if(extension.equalsIgnoreCase(accepted[i]))
				return true;
		}
		return false;
	}
}

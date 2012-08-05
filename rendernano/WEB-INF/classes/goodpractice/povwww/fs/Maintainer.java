/*
 * Created on 13.12.2004 by florian
 */
package goodpractice.povwww.fs;

import java.io.*;

public class Maintainer extends Thread {
    
    private boolean stopped;
    
    public void run(){
        while(!stopped){
            try{
                sleep(1000*60*24); // execute once a day
            }catch(InterruptedException e){}
            checkFiles();
            checkProfiles();
        }
    }
    
    
    private void checkFiles(){
     FSReader users = new FSReader("/usr/local/share/povApp/users");
     String[] uNames = users.getDirectoryNames();
     for(int i = 0; i < uNames.length; i++){
         File tmp = new File("/usr/local/share/povApp/users/" + uNames[i]);
         File[] uFiles = tmp.listFiles();
         for(int j = 0; j < uFiles.length; j++){
             long lastMod = uFiles[j].lastModified();
             long now = System.currentTimeMillis();
             if(now - lastMod > (1000*60*60*24*7))
                 uFiles[j].delete();
         }
         
     }
    }
    
    
    
    private void checkProfiles(){
        
    }

}

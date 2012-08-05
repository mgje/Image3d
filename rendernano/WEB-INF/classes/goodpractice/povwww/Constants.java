/*
 * Created on 13.12.2004 by florian
 */
package goodpractice.povwww;

public class Constants {
    
	
	//linus
	//public static final String APP_BASE = "/home/guggisbe/povApp/";
	//nano-world
    public static final String APP_BASE = "/usr/local/share/povApp/";
    //DEV-Notebook
	//public static final String APP_BASE = "/usr/local/share/povApp/";
	
	public static final String USER_BASE = APP_BASE + "devusers/";
    
    
    
//	linus
    //public static final String APP_BASE_URL = "http://linus.cs.unibas.ch:8080/image3d/";
    //public static final String APP_WWW_URL = APP_BASE_URL;
	
	//Nano-World
	public static final String APP_WWW_URL = "http://image3d.epistemis.com/image3d/";
	public static final String APP_BASE_URL = "http://127.0.0.1:8080/image3d/";
	//public static final String APP_BASE_URL = "http://image3d.epistemis.com/image3d/";
    //Dev_Notebook
    //public static final String APP_BASE_URL = "http://131.152.85.162:8080/image3d/";
    //public static final String APP_WWW_URL = APP_BASE_URL;
    //Linus
    //public static final String POVRAY = "/usr/local/povray/povray";
	//multi Prozessor Script
    //public static final String POVRAYMOV = "/home/guggisbe/povApp/runpov";
    //public static final String POVRAYAVI = "/home/guggisbe/povApp/runavipov";
    //public static final String LIB_PREFIX = "/usr/local/povray/include";
    //public static final String SCRIPT_BASE_FS = "/usr/share/tomcat5/webapps/image3d/scripts/";
    
    //Dev-comp //nano-world
   
    public static final String POVRAY = "/usr/local/bin/povray";
    public static final String POVRAYMOV = "/usr/local/bin/povray";
      public static final String POVRAYAVI = "/usr/local/bin/povray"; 
    public static final String LIB_PREFIX = "/usr/local/share/povray-3.6/include";
    public static final String SCRIPT_BASE_FS = "/usr/share/tomcat5/webapps/image3d/scripts/";
    
    
    public static final String COOKIE_NAME = "image3ddevcookie";
    public static final String RESTORE_COOKIE_PARAMETER = "restoreCookieId";
    public static final String COOKIE_REGEXP = "[a-z]+[0-9]+";
    
    public static final String FEEDBACK_PARAMETER = "userFeedback";
    
    public static final String DIR_MEASURE = "measurements/";
    public static final String DIR_RENDER = "rendered/";
    public static final String DIR_DESC = "descriptions/";
    public static final String DIR_THUMB = "thumbnails/";
    public static final String DIR_MOV = "mov_tmp/";
    public static final String DIR_EXAMPLE = "../../examples/";
    public static final String DIR_EXAMPLE_RENDERED = "../../examples_rendered/";
    
    public static final String PREFIX_RENDER = "rendered.";
    public static final String PREFIX_THUMB = "thumbnail.";
    public static final String PREFIX_DESCRIPTION = "description.";

	

	


	

}

/*
 *   povray shell script
 *   
 *    
#!/bin/bash

numberOfJobs=7

povINI=$1

povIncl=$2

povFile=$3

povFileout=$4

frames=105

finalFrame=104




for ((i=0;i<$numberOfJobs;i+=1)); do  

subsetStartFrame=$[$i*$frames/numberOfJobs]

subsetEndFrame=$[$subsetStartFrame+($frames/$numberOfJobs)-1]

(/usr/local/povray/povray $povINI +KFI1 +KFF$finalFrame +SF$subsetStartFrame +EF$subsetEndFrame $povIncl $povFile  $povFileout ) &

done



wait  


echo '------------------------'

echo 'render finished!'

echo "$1 frames in $SECONDS seconds"

    
exit




*/
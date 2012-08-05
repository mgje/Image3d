/*
 * Created on 04.12.2004 by florian
 */
package goodpractice.povwww.pov;

public interface Script {

    
    public static final int OF_TGA = 0;
    public static final int OF_PNG = 1;
    
    
    
	public void build() throws java.io.IOException;

	
	
	
	public String getScriptLocator();
	public String getIniLocator();
	
	public String getScriptName();
	public String getIniName();
	
	
	
	
	public static final String INCLUDES 	=	"#include \"colors.inc\"\n"
												+ "#include \"textures.inc\"\n";
	
	public static final String DECLARES		=	"#declare DIST = 4;\n"          
												+ "#declare KAMERA = <-DIST*(cos(2*pi*clock)),DIST,-DIST*(sin(2*pi*clock))>;\n";	
	
	public static final String LIGHT_SOURCE =	"light_source {\n"
											    + "KAMERA\n"
											    + "color White\n"
											    + "spotlight\n"
											    + "radius 30\n"
											    + "falloff 20\n"
											    + "tightness 10\n"
											    + "point_at <0, 0, 0>\n"
												+ "}\n";
	
	public static final String BACKGROUND 	=	"background { color Black }\n";
	
	public static final String CAMERA 		=	"camera {\n"  
												+ "location KAMERA\n"
												+ "look_at   <0.0, 0.0,  0.0>\n"
												+ "right     x*image_width/image_height\n"
												+ "}\n";
		      
	public static final String HEIGHT_FIELD_1	=	"height_field{\n"
													+ "	jpeg\n";
	public static final String HEIGHT_FIELD_2	=	"	smooth\n"
	      + "	water_level 0.0\n"
	      + "	hierarchy off\n"  
	      + "	translate <-0.5,0,-0.5>\n"
	      + "	texture{\n"
	      + "		pigment {\n"
	      + "			gradient y       //this is the PATTERN_TYPE\n"
	      + "			color_map {\n"
	      + "				[0.0  color Blue]\n" 
	      + "				[0.3 color Blue]\n"
	      + "				[0.3  color Yellow]\n"
	      + "				[0.6  color Yellow]\n"
	      + "				//[0.6  color Green]\n"
	      + "				[0.8  color Red]\n"
	      + "			}\n"
	      + " 		}\n"
	      + " 	}\n"
		  + "}\n";
	
	
	
	
	
	
}

#include "colors.inc"	  // Standard Color definitions
#include "textures.inc"	  // Standard Texture definitions
#include "functions.inc"  // internal functions usable in user defined functions

#declare dist = #@Distance:2.0;3.0;4.0;5.0@;
#declare cameraVector = <#@CameraPosition:-1,1,-1;-1,-1,-1;-1,1,1;-1,-1,1:Top left;Bottom left;Top right;Bottom right:povwww.web.applet.XYZApplet@> * dist;
#declare lightVector = <#@LightPosition:-1,1,-1;-1,-1,-1;-1,1,1;-1,-1,1:Top left;Bottom left;Top right;Bottom right:povwww.web.applet.XYZApplet@> * dist;
#declare shapeType = #@ShapeType:1;2:Sphere;Cylinder@; 
#declare imageFile = "#@imageLocator@";  
#declare ambientLight = #@AmbientLight:0.1;0.2;0.3;0.4;0.5;0.6;0.7;0.8;0.9@;
#declare ROTATION = #@Rotation:0;90;180;270@;

background{
	color #@BackgroundColor:White;Black;Blue;Green;Yellow;Red@
}

// Light Definition
light_source {
  lightVector      // position of the light source
  //color rgb 0.9     // color of the light
  color White
}
// perspective (default) camera
camera {
  location  cameraVector
  look_at   <0.0, 0.0,  0.0>
  right     x*image_width/image_height
}
             

#if(shapeType = 1)
// create a sphere shape
sphere {
  <0, 0, 0> // center of sphere <X Y Z>
  1       // radius of sphere
  texture{
    pigment{
        image_map {
                jpeg imageFile // the file to read (iff/tga/gif/png/jpeg/tiff/sys)
                map_type 1        // 0=planar, 1=spherical, 2=cylindrical, 5=torus
                interpolate 2     // 0=none, 1=linear, 2=bilinear, 4=normalized distance
                // once           // for no repetitive tiling
                // [filter N V]   // N=all or color index # (0...N), V= value (0.0...1.0)
                // [transmit N V] // N=all or color index # (0...N), V= value (0.0...1.0)
                // [use_color | use_index]
        } // image_map
    }
    // control an object's surface finish
    finish {
        ambient ambientLight          // ambient surface reflection color [0.1]
        // (---diffuse lighting---)
        diffuse 0.6          // amount [0.6]
        brilliance 0.5       // tightness of diffuse illumination [1.0]
        reflection {
                //0.0                      // minimal reflection value (for variable reflection)
                1.0                        // reflection amount (maximum for variable reflection)
                //fresnel on               // realistic variable reflection
                //falloff 1.0              // falloff exponent for variable reflection
                //exponent 1.0             // influence surface reflection characteristic
                //metallic 1.0             // tint reflection in surface color
        }
     } // finish
  } // texture
rotate <0,ROTATION, 0> 
} // sphere  


#else 
 // draw cubus         
 cylinder{
        <0,-1,0>, <0,1,0>, 2
        
        texture{
                pigment{
                image_map{
                        jpeg imageFile
                        map_type 1
                        interpolate 2
                }       
                }
                finish{
                        ambient ambientLight
                        diffuse 0.6
                        //billiance 1.0
                        reflection{
                                1.0
                        } 
                
                }
       }
       rotate <0,ROTATION,0>
 }
                
#end
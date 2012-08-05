#include "colors.inc"
        #include "textures.inc"
        #declare DIST = 1;
        #declare TOP_CENTER = <0,1,0>;
        #declare TOP_N = <0,1,1>;
        #declare TOP_S = <0,1,-1>;
        #declare TOP_E = <1,1,0>;
        #declare TOP_W = <-1,1,0>;
        #declare TOP_NE = <1,1,1>;
        #declare TOP_NW = <-1,1,1>;
        #declare TOP_SE = <1,1,-1>;
        #declare TOP_SW = <-1,1,-1>;
        #declare LEVEL_SOUTH = <0,0,-1>;
        #declare SCALE = #@Distance:0.5;0.6;0.7;0.8;0.9;1;2;3;4:0.5 (close);0.6;0.7;0.8;0.9;1x;2x;3x;4x (far)@;
        #declare KAMERA = <#@CameraPosition:0,1,0;0,1,1;0,1,-1;1,1,0;-1,1,0;1,1,1;-1,1,1;1,1,-1;-1,1,-1;0,0,-1:Top, Center;Top, North;Top, South;Top, East;Top, West;Top, NE;Top, NW;Top, SE;Top, SW;Level, South:povwww.web.applet.XYZApplet@> * SCALE;
        background{
        color #@Background:Black;White@
        }
        light_source {
        KAMERA
        color White*#@CameraBrigthness:1.5;0.5;0.75;1;1.25;1.5;1.75;2;2.5;3@
        adaptive 1
        jitter
        }
        camera{
        location KAMERA
        look_at <0.0,0.0,0.0>
        right x*image_width/image_height
        }
        
        height_field{
        jpeg
        "#@imageLocator@"
        smooth
        water_level 0.0
        hierarchy off
        translate <-0.5,0,-0.5>
        texture{
        pigment {
        gradient y       //this is the PATTERN_TYPE
        color_map {
        #@ColorPattern:[0.0 rgb <0,0.08627451,0.6>][0.20 rgb <0.058823529,0.549019608,0.164705882>][0.6 color Gray][0.95 color White];
        [0.0 color Black][0.2 color Blue][0.6 color Red][1.0 color Yellow];
        [0.0 rgb <0.17588, 0.39608, 0.900000>][0.40000 rgb <1, 1, 1>][0.5500000 rgb <0.3, 0.9, 0.0>] [0.800000 rgb <0.7, 0.6, 0.0>] [1 rgb <1, 0.4, 0>*1.2];
        [0.0 rgb <0.170588, 0.019608, 0.900000>] [0.40000 rgb <1, 1, 1>] [0.600000 rgb  <1, 1, 0.0>] [1 rgb <1, 0.3, 0>]; 
        [0.0, 0.021 color rgb <0.010, 0.010, 0.010>  color rgb <0.040, 0.010, 0.020>] [0.021, 0.067 color rgb <0.040, 0.010, 0.020>  color rgb <0.105, 0.080, 0.060>] [0.067, 0.117 color rgb <0.105, 0.080, 0.060>  color rgb <0.275, 0.220, 0.140>] [0.117, 0.167 color rgb <0.275, 0.220, 0.140>  color rgb <0.490, 0.155, 0.260>] [0.167, 0.230 color rgb <0.490, 0.155, 0.260> color rgb <0.615, 0.060, 0.425>] [0.230, 0.305 color rgb <0.615, 0.060, 0.425>  color rgb <0.860, 0.140, 0.485>] [0.305, 0.385 color rgb <0.860, 0.140, 0.485>  color rgb <1.150, 0.325, 0.335>] [0.385, 0.469 color rgb <1.150, 0.325, 0.335>  color rgb <1.235, 0.560, 0.125>] [0.469, 0.548 color rgb <1.235, 0.560, 0.125>  color rgb <0.980, 0.665, 0.035>] [0.548, 0.623 color rgb <0.980, 0.665, 0.035> color rgb <0.590, 0.550, 0.160>] [0.623, 0.703 color rgb <0.590, 0.550, 0.160>  color rgb <0.270, 0.320, 0.370>] [0.703, 0.787 color rgb <0.270, 0.320, 0.370>  color rgb <0.095, 0.165, 0.230>] [0.787, 0.891 color rgb <0.095, 0.165, 0.230>  color rgb <0.020, 0.145, 0.575>] [0.891, 0.950 color rgb <0.020, 0.145, 0.575>  color rgb <0.005, 0.140, 0.425>] [1.0, 1.000 color rgb <0.005, 0.140, 0.425> color rgb <0.010, 0.010, 0.010>];
        [0.0 color rgb <0.6, 0.6, 0.7>*0.6] [0.58 color rgb <0.9, 0.6, 0.3>*0.6] [1 color rgb <0.2, 0.6, 0.1>*0.5];  
        [0.0 color rgb <1, 0.95, 0.9>] [0.5 color rgb <0.6, 0.5, 0.52>] [1.0 color rgb <0.9, 0.8, 0.7>]; 
        [0.0 color rgb <0.33, 0.37, 0.90> ][0.14 color rgb <0.3210, 0.53, 0.9259> ] [0.26 color rgb <0.3610, 0.57, 0.9259> ] [0.50 color rgb < 0.880, 0.935, 0.976 >];
        [0.0 color Blue][0.5 color Yellow][1.0 color Red];
        [0.0 color Black][0.2 color DimGrey][0.6 color Coral][1.0 color Orange];
        [0.0 color Black][0.3 color rgb <0.55, 0.19, 0.0>][0.7 color rgb <0.19, 0.80, 0.69>][1.0 color rgb <0.91, 0.76, 0.65>];
        [0.0 color Black][0.2 color rgb <1.00, 0.43, 0.78>][0.7 color rgb <0.96, 0.80, 0.69>][1.0 color rgb <0.85, 0.85, 0.10>];
        [0.0 color Black][0.3 color rgb <0.00, 0.43, 0.78>][0.7 color rgb <0.3, 0.3, 0.2>][1.0 color rgb <0.85, 0.85, 0.10>];
        [0.0 color Black][0.3 color Aquamarine][0.7 color CadetBlue][1.0 color LightGray];
        [0.0 color Black][0.3 color DarkSlateBlue][0.7 color CadetBlue][1.0 color LightGray];
        [0.0 color Black][0.3 color DarkSlateBlue][0.7 color MediumBlue][1.0 color LightGray];
        [0.0 color Black][0.3 color DarkSlateBlue][0.7 color Orange][1.0 color LightGray];
        [0.0 color Black][0.3 color DarkSlateBlue][0.7 color YellowGreen][1.0 color LightGray];
        [0.0 color Black][0.3 color DarkSlateBlue][0.7 color Silver][1.0 color LightGray];
        [0.0 color Black][0.3 color Bronze][0.7 color Orange][1.0 color Silver];
        [0.0 color Black][0.2 color Bronze][0.6 color BrightGold][1.0 color Silver];
        [0.0 color Black][0.2 color Bronze][0.6 color BrightGold][1.0 color PaleGreen];
        [0.0 color Black][0.2 color Bronze][0.6 color NeonBlue][1.0 color DustyRose];
        [0.0 color Black][0.2 color MandarinOrange][0.6 color NeonBlue][1.0 color Very_Light_Purple];
        [0.0 color Black][0.2 color MandarinOrange][0.6 color NeonBlue][1.0 color Plum]:
        Topographie;blackyellow;mix3;hug;mix2;wild;
        tuarkis;moon;Sky-color;BlueYellowRed;blackcoralorange;scarlet;
        neonpink;
        m1;m2;m3;m4;m5;m6;
        p1;p2;p3;p4;p5;p6:povwww.web.applet.GradientApplet@
        }
        }
        finish{
        phong 0.5
        ambient White * #@AmbientLight:0.4;0.1;0.2;0.3;0.4;0.5;0.6;0.7;0.8;0.9@
        }
        }
        scale <1,#@ZFactor:0.1;0.2;0.4;0.8;1:1x;2x;4x;8x;10x:povwww.web.applet.ZFactor@,1>
        rotate <0,#@Rotation:0;90;180;270:none;90 degrees;180 degrees;270 degrees@,0>
        }
        


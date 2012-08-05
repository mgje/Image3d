/**
* Manages startup and overall control of the Flash Image Rotator
*
* @author	Jeroen Wijering
* @version	1.02
**/


import com.jeroenwijering.players.*;


class com.jeroenwijering.players.ImageRotator extends AbstractPlayer { 


	/** Array with all config values **/
	private var configArray:Object = {
		file:"playlist.xml",
		width:"undefined",
		height:"undefined",
		shuffle:"true",
		backcolor:"0x000000",
		frontcolor:"0xffffff",
		lightcolor:"0x990000",
		linkfromdisplay:"true",
		linktarget:"_self",
		showicons:"false",
		logo:"undefined",
		overstretch:"false",
		rotatetime:"5",
		shownavigation:"false",
		transition:"fade",
		callback:"undefined",
		enablejs:"false",
		playerclip:"undefined"
	}
	/** Accepted types of mediafiles **/
	private var fileTypes:Array = new Array(".jpg",".png",".gif");


	/** Constructor **/
	function ImageRotator(tgt:MovieClip,fil:String) {
		super(tgt,fil);
	};


	/** Setup all necessary MCV blocks. **/
	private function setupMCV():Void {
		// set controller
		controller = new RotatorController(configArray,fileArray);
		// set views
		var rov = new RotatorView(controller,configArray,fileArray);
		var ipv = new InputView(controller,configArray,fileArray);
		var vws:Array = new Array(rov,ipv);
		if(configArray["enablejs"] == "true") {
			var jsv = new JavascriptView(controller,configArray,fileArray);
			vws.push(jsv);
		}
		if(configArray["callback"] != "undefined") {
			var cbv = new CallbackView(controller,configArray,fileArray);
			vws.push(cbv);
		}
		// set models
		configArray["displayheight"] = configArray["height"];
		var im1 = new ImageModel(vws,controller,configArray,fileArray,configArray["playerclip"].img1);
		var im2 = new ImageModel(vws,controller,configArray,fileArray,configArray["playerclip"].img2);
		var mds:Array = new Array(im1,im2);
		// start mcv cycle
		controller.startMCV(mds);
	};


}
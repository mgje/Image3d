/**
* Player that reads all media formats Flash can read.
*
* @author	Jeroen Wijering
* @version	1.03
**/


import com.jeroenwijering.players.*;


class com.jeroenwijering.players.MediaPlayer extends AbstractPlayer { 


	/** Array with all config values **/
	private var configArray:Object = {
		file:"playlist.xml",
		width:"undefined",
		height:"undefined",
		autostart:"false",
		shuffle:"true",
		repeat:"false",
		backcolor:"0xffffff",
		frontcolor:"0x000000",
		lightcolor:"0x000000",
		displayheight:"undefined",
		linkfromdisplay:"false",
		linktarget:"_self",
		showicons:"true",
		logo:"undefined",
		overstretch:"fit",
		showdigits:"true",
		showfsbutton:"false",
		fullscreenmode:"false",
		fullscreenpage:"fullscreen.html",
		fsreturnpage:"mediaplayer.html",
		bufferlength:"5",
		volume:"80",
		autoscroll:"false",
		thumbsinplaylist:"false",
		rotatetime:"10",
		callback:"undefined",
		streamscript:"undefined",
		enablejs:"false",
		playerclip:"undefined"
	}
	/** Accepted types of mediafiles **/
	private var fileTypes:Array = new Array(".mp3",".flv","rtmp://",".jpg",".png",".gif",".swf",".rbs");


	/** Constructor **/
	public function MediaPlayer(tgt:MovieClip,fil:String) {
		super(tgt,fil);
	};


	/** Setup all necessary MCV blocks. **/
	private function setupMCV():Void {
		// set controller
		controller = new PlayerController(configArray,fileArray);
		// set views
		var pav = new PlayerView(controller,configArray,fileArray);
		var ipv = new InputView(controller,configArray,fileArray);
		var vws:Array = new Array(pav,ipv);
		if(configArray["displayheight"] < configArray["height"]-20 && configArray["fullscreenmode"] == "false") {
			var plv = new PlaylistView(controller,configArray,fileArray);
			vws.push(plv);
		} else {
			configArray["playerclip"].playlist._visible = false;
		}
		if(configArray["enablejs"] == "true") {
			var jsv = new JavascriptView(controller,configArray,fileArray);
			vws.push(jsv);
		}
		if(configArray["callback"] != "undefined") {
			var cbv = new CallbackView(controller,configArray,fileArray);
			vws.push(cbv);
		}
		// set models
		var mp3 = new MP3Model(vws,controller,configArray,fileArray);
		var flv = new FLVModel(vws,controller,configArray,fileArray,configArray["playerclip"].display.video);
		var img = new ImageModel(vws,controller,configArray,fileArray,configArray["playerclip"].display.image);
		var mds:Array = new Array(mp3,flv,img);
		// start mcv cycle
		controller.startMCV(mds);
	};


}
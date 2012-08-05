/**
* Manages startup and overall control of the Flash MP3 Player
*
* @author	Jeroen Wijering
* @version	1.04
**/


import com.jeroenwijering.players.*;


class com.jeroenwijering.players.MP3Player extends AbstractPlayer { 


	/** Array with all config values **/
	private var configArray:Object = {
		file:"song.mp3",
		width:"undefined",
		height:"undefined",
		autostart:"false",
		shuffle:"true",
		repeat:"false",
		backcolor:"0xffffff",
		frontcolor:"0x000000",
		lightcolor:"0x000000",
		displayheight:"0",
		linkfromdisplay:"false",
		linktarget:"_self",
		showicons:"true",
		logo:"undefined",
		showeq:"false",
		overstretch:"true",
		showdigits:"true",
		volume:"80",
		autoscroll:"false",
		thumbsinplaylist:"false",
		callback:"undefined",
		enablejs:"false",
		playerclip:"undefined"
	}
	/** Accepted types of mediafiles **/
	private var fileTypes:Array = new Array(".mp3",".rbs");


	/** Constructor **/
	function MP3Player(tgt:MovieClip,fil:String) {
		super(tgt,fil);
	};


	/** Setup all necessary MCV blocks. **/
	private function setupMCV():Void {
		// displayheight fix for EQ
		configArray["showeq"] == "true" && configArray["displayheight"] == "0" ? configArray["displayheight"] = 50: null; 
		// set controller
		controller = new PlayerController(configArray,fileArray);
		// set views
		var pav = new PlayerView(controller,configArray,fileArray);
		var ipv = new InputView(controller,configArray,fileArray);
		var vws:Array = new Array(pav,ipv);
		if(configArray["showeq"] == "true") {
			var eqv = new EqualizerView(controller,configArray,fileArray);
			vws.push(eqv);
		} else {
			configArray["playerclip"].display.equalizer._visible = false;
		}
		if(configArray["displayheight"] < configArray["height"]-20 ) {
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
		var mds:Array = new Array(mp3);
		// start mcv cycle
		controller.startMCV(mds);
	};


}
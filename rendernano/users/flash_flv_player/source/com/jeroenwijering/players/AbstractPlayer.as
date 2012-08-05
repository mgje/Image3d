/**
* Abstract player class, extended by all other players.
* Class loads config and file XML's and sets up MCV triangle.
*
* @author	Jeroen Wijering
* @version	1.03
**/


import com.jeroenwijering.players.*;
import com.jeroenwijering.utils.FeedParser;


class com.jeroenwijering.players.AbstractPlayer { 


	/** Array with all config values **/
	private var configArray:Object = {
		file:"",
		width:"",
		height:"",
		autostart:"",
		shuffle:"",
		repeat:"",
		backcolor:"",
		frontcolor:"",
		lightcolor:"",
		displayheight:"",
		showicons:"",
		logo:"",
		linkfromdisplay:"",
		linktarget:"",
		overstretch:"",
		showdigits:"",
		showfsbutton:"",
		fullscreenmode:"",
		fullscreenpage:"",
		fsreturnpage:"",
		bufferlength:"",
		volume:"",
		autoscroll:"",
		thumbsinplaylist:"",
		rotatetime:"",
		shownavigation:"",
		transition:"",
		callback:"",
		streamscript:"",
		enablejs:"",
		playerclip:""
	}
	/** Accepted types of mediafiles **/
	private var fileTypes:Array;
	/** reference to the XML parser **/
	private var fileParser:FeedParser;
	/** Array with all playlist items **/
	private var fileArray:Array;
	/** reference to the controller **/
	private var controller:AbstractController;


	/**
	* Player application startup
	*
	* @param tgt	movieclip that contains all player graphics
	* @param fil	file that should be played
	**/
	public function AbstractPlayer(tgt:MovieClip,fil:String) {
		configArray["playerclip"] = tgt;
		configArray["playerclip"]._visible = false;
		fil == undefined ? null: configArray["file"] = fil;
		loadConfig();
	};


	/** Set configArray variables or load them from flashvars. **/
	private function loadConfig() {
		configArray["width"] == "undefined" ? configArray["width"] = Stage.width: null;
		configArray["height"] == "undefined" ? configArray["height"] = Stage.height: null;
		configArray["displayheight"] == "undefined" ? configArray["displayheight"] = Stage.height-20: null;
		for(var cfv in configArray) {
			_root[cfv] == undefined ? null: configArray[cfv] = unescape(_root[cfv]);
		}
		if(configArray["fullscreenmode"] == "true") {
			var pso = SharedObject.getLocal("com.jeroenwijering.players", "/");
			configArray["file"] = pso.data.file;
		}
		loadFile(configArray["file"]);
		configArray["enablejs"] == "true" ? enableLoadFile(): null;
	};


	/** 
	* Load an XML playlist or single media file. 
	* 
	* @param fil	the file to load
	**/
	public function loadFile(fil) {
		configArray["file"] = fil;
		fileArray = new Array();
		var fnd = false;
		if(controller != undefined) {
			controller.getEvent("stop");
			delete controller;
			trace("killed");
		}
		for(var i in fileTypes) {
			if(fil.toLowerCase().indexOf(fileTypes[i].toLowerCase()) > -1) { 
				fnd = true;
			}
		}
		if (fnd == true) {
			fileArray[0] = new Object();
			fileArray[0]['file'] = fil;
			if(_root.title == undefined) {
				fileArray[0]["title"] = fileArray[0]["file"].substring(fileArray[0]["file"].lastIndexOf("/")+1,fileArray[0]["file"].length-4);
			} else {
				fileArray[0]["title"] = unescape(_root.title);
			}
			_root.image == undefined ? null: fileArray[0]["image"] = unescape(_root.image);
			_root.link == undefined ? null: fileArray[0]["link"] = unescape(_root.link);
			_root.id == undefined ? null: fileArray[0]["id"] = unescape(_root.id);
			_root.author == undefined ? null: fileArray[0]["author"] = unescape(_root.author);
			if(configArray["fullscreenmode"] == "true") {
				var pso = SharedObject.getLocal("com.jeroenwijering.players", "/");
				fileArray[0]["id"] = pso.data.id;
			}
			configArray["playerclip"]._visible = true;
			_root.activity._visible = false;
			setupMCV();
		} else { 
			var ref = this;
			fileParser = new FeedParser();
			fileParser.onParseComplete = function() { 
				ref.fileArray = this.parseArray;
				ref.configArray["playerclip"]._visible = true;
				_root.activity._visible = false;
				ref.setupMCV();
			};
			fileParser.parse(fil);	
		}	
	};


	/** Setup all necessary MCV blocks. **/
	private function setupMCV():Void {
		controller = new AbstractController(configArray,fileArray);
		var asv = new AbstractView(controller,configArray,fileArray);
		var vws:Array = new Array(asv);
		var asm = new AbstractModel(vws,controller,configArray,fileArray);
		var mds:Array = new Array(asm);
		controller.startMCV(mds);
	};


	/** Enable javascript access to loadFile command **/
	private function enableLoadFile() {
		if(flash.external.ExternalInterface.available) {
			var lfc:Boolean = flash.external.ExternalInterface.addCallback("loadFile",this,loadFile);
		}
	};


}
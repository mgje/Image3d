/**
* FLV model class of the players MCV pattern.
* Handles playback of FLV files, HTTP streams and RTMP streams.
*
* @author	Jeroen Wijering
* @version	1.5
**/


import com.jeroenwijering.players.*;


class com.jeroenwijering.players.FLVModel extends AbstractModel { 


	/** array with extensions used by this model **/
	private var activeExtensions:Array = new Array(".flv","rtmp://");
	/** NetConnection object reference **/
	private var connectObject:NetConnection;
	/** NetStream object reference **/
	private var streamObject:NetStream;
	/** Sound object reference **/
	private var soundObject:Sound;
	/** interval ID of the buffer update function **/
	private var loadedInterval:Number;
	/** current percentage of the video that's loaded **/
	private var currentLoaded:Number = 0;
	/** interval ID of the position update function **/
	private var positionInterval:Number;
	/** current position of the video that is playing **/
	private var currentPosition:Number;
	/** Duration metadata of the current video **/
	private var metaDuration:Number = 0
	/** current state of the video that is playing **/
	private var currentState:Number;
	/** Current volume **/
	private var currentVolume:Number;
	/** MovieClip with "display" video Object  **/
	private var videoClip:MovieClip;
	/** object with keyframe times and positions, saved for PHP streaming **/
	private var metaKeyframes:Object = new Object();
	/** Boolean to check whether a stop event is fired **/
	private var stopFired:Boolean = false;
	/** Switch for FLV type currently played **/
	private var flvType:String;


	/** Constructor **/
	function FLVModel(vws:Array,ctr:AbstractController,car:Object,far:Array,fcl:MovieClip) {
		super(vws,ctr,car,far);
		connectObject = new NetConnection();
		videoClip = fcl;
		videoClip.display.smoothing = true;
		videoClip.display.deblocking = 4;
		videoClip.createEmptyMovieClip("snd", videoClip.getNextHighestDepth());
		soundObject = new Sound(videoClip.snd);
	};


	/** Check which FLV type we use **/
	private function setItem(idx:Number) {
		super.setItem(idx);
		if(isActive == true) {
			if(configArray["streamscript"] != "undefined") { flvType = "HTTP"; } 
			else if (fileArray[currentItem]["file"].indexOf("rtmp://") !=  -1) { flvType = "RTMP"; } 
			else { flvType = "FLV"; }
		}
	};


	/** Start a specific video **/
	private function setStart(pos:Number) {
		if(pos < 1) { pos = 0; } else if (pos > metaDuration - 1) { pos = metaDuration - 1; }
		if (flvType == "RTMP" && fileArray[currentItem]["id"] != currentURL) {
			connectObject.connect(fileArray[currentItem]["file"]);
			currentURL = fileArray[currentItem]["id"];
			setStreamObject(connectObject);
			streamObject.play(currentURL);
		} else if(flvType != "RTMP" && fileArray[currentItem]["file"] != currentURL) {
			connectObject.connect(null);
			currentURL = fileArray[currentItem]["file"];
			if(flvType == "HTTP" ) {
				setStreamObject(connectObject);
				streamObject.play(configArray["streamscript"]+"?file="+currentURL);
			} else {
				setStreamObject(connectObject);
				streamObject.play(currentURL);
			}
		}
		streamObject.pause(false);
		videoClip._visible = true;
		if (pos != undefined) {
			currentPosition = pos;
			flvType == "HTTP" ? playKeyframe(pos): streamObject.seek(currentPosition);
			pos == 0 ? sendUpdate("time",0): null;
		}
		clearInterval(positionInterval);
		positionInterval = setInterval(this,"updatePosition",200);
		clearInterval(loadedInterval);
		loadedInterval = setInterval(this,"updateLoaded",200);
	};


	/** Read and broadcast the amount of the flv that's currently loaded **/
	private function updateLoaded() {
		if(flvType == "FLV") {
			var pct:Number = Math.round(streamObject.bytesLoaded/streamObject.bytesTotal*100);
		} else {
			var pct:Number = Math.round(streamObject.bufferLength/streamObject.bufferTime*100);
		}
		if(isNaN(pct)) { 
			currentLoaded = 0;
			sendUpdate("load",0);
		} else if (pct > 95) { 
			clearInterval(loadedInterval);
			currentLoaded = 100;
			sendUpdate("load",100);
		} else if (pct != currentLoaded) { 
			currentLoaded= pct;
			sendUpdate("load",currentLoaded);
		}
	};


	/** Read and broadcast the current position of the song **/
	private function updatePosition() {
		var pos = streamObject.time;
		if(pos == currentPosition && currentState != 1 && streamObject.bufferLength < configArray["bufferlength"]-1) {
			currentState = 1;
			sendUpdate("state",1);
		} else if (pos != currentPosition && currentState != 2) { 
			currentState = 2;
			sendUpdate("state",2);
		}
		if (pos != currentPosition) {
			currentPosition = pos;
			metaDuration < currentPosition ? metaDuration = currentPosition: null;
			sendUpdate("time",currentPosition,metaDuration-currentPosition);
		} else if (streamObject.bufferLength < 1 && (currentLoaded == 100 && stopFired == true)) {
			currentState = 3;
			videoClip._visible = false;
			sendUpdate("state",3);
			sendCompleteEvent();
			stopFired = false;
		}
	};


	/** Pause the video that's currently playing. **/
	private function setPause(pos:Number) {
		if(pos < 1) { pos = 0; } else if (pos > metaDuration - 1) { pos = metaDuration - 1; }
		clearInterval(positionInterval);
		if(pos != undefined) {
			currentPosition = pos;
			sendUpdate("time",currentPosition,metaDuration-currentPosition);
			streamObject.seek(currentPosition);
		}
		streamObject.pause(true);
		currentState = 0;
		sendUpdate("state",0);
	};


	/** Stop video and clear data. **/
	private function setStop(pos:Number) {
		clearInterval(loadedInterval);
		clearInterval(positionInterval);
		delete currentURL;
		delete currentPosition;
		delete metaKeyframes;
		metaDuration = 0;
		currentLoaded = 0;
		streamObject.close();
		delete streamObject;
		stopFired = false;
		videoClip._visible = false;
	};


	/** Set volume of the sound object. **/
	private function setVolume(vol:Number) {
		super.setVolume(vol);
		currentVolume = vol;
		soundObject.setVolume(vol);
	};


	/** Connect a new stream object to video/audio/callbacks **/
	private function setStreamObject(cnt:NetConnection) {
		var ref = this;
		currentLoaded = 0;
		sendUpdate("load",0);
		streamObject = new NetStream(cnt);
		streamObject.setBufferTime(configArray["bufferlength"]);
		streamObject.onMetaData = function(obj) {
			trace("meta: "+obj.duration+" / "+obj.width+"-"+obj.height);
			obj.duration > 1 ? ref.metaDuration = obj.duration: null;
			obj.width < 10 ? null: ref.scaleMovie(obj.width,obj.height);
			ref.metaKeyframes = obj.keyframes;
			delete obj;
			delete this.onMetaData;
		};
		streamObject.onStatus = function(object) {
			if(object.code == "NetStream.Play.Stop") { ref.stopFired = true; }
		};
		videoClip.display.attachVideo(streamObject);
		videoClip.snd.attachAudio(streamObject);
	};


	/** Scale movie according to overstretch setting **/
	private function scaleMovie(wid:Number,hei:Number):Void {
		var xsr:Number = configArray["width"]/wid;
		var ysr:Number = configArray["displayheight"]/hei;
		if (xsr < ysr && configArray["overstretch"] == "false" || ysr < xsr && configArray["overstretch"] == "true") { 
			videoClip._width = wid*xsr;
			videoClip._height = hei*xsr;
		} else if(configArray["overstretch"] == "none") {
			videoClip._width = wid;
			videoClip._height = hei;
		} else if (configArray["overstretch"] == "fit") {
			videoClip._width = configArray["width"];
			videoClip._height = configArray["displayheight"];
		} else { 
			videoClip._width = wid*ysr;
			videoClip._height = hei*ysr;
		}
		videoClip._x = configArray["width"]/2 - videoClip._width/2;
		videoClip._y = configArray["displayheight"]/2 - videoClip._height/2;
	};


	/** Play from keyframe position from metadata **/
	private function playKeyframe(pos:Number) {	
		for (var i=0; i< metaKeyframes.times.length; i++) {
			if((metaKeyframes.times[i] <= currentPosition) && (metaKeyframes.times[i+1] >= currentPosition)) {
				streamObject.play(configArray["streamscript"]+"?file="+currentURL+"&pos="+metaKeyframes.filepositions[i]);
				break;
			}
		}
	};


}
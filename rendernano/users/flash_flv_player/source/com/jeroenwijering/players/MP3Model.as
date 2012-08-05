/**
* MP3 model class of the players MCV pattern.
*
* @author	Jeroen Wijering
* @version	1.2
**/


import com.jeroenwijering.players.*;


class com.jeroenwijering.players.MP3Model extends AbstractModel { 


	/** array with extensions used by this model **/
	private var activeExtensions:Array = new Array(".mp3",".rbs");
	/** Sound instance **/
	private var soundObject:Sound;
	/** interval ID of the buffer update function **/
	private var loadedInterval:Number;
	/** currently loaded percentage **/
	private var currentLoaded:Number = 0;
	/** interval ID of the position update function **/
	private var positionInterval:Number;
	/** current position of the sound that is playing **/
	private var currentPosition:Number;
	/** Duration of the current sound **/
	private var soundDuration:Number = 0;
	/** current state of the sound that is playing **/
	private var currentState:Number;
	/** Current volume **/
	private var currentVolume:Number;


	/** Constructor **/
	function MP3Model(vws:Array,ctr:AbstractController,car:Object,far:Array) {
		super(vws,ctr,car,far);
	};



	/** Start a specific sound **/
	private function setStart(pos:Number) {
		if(pos < 1 ) { pos = 0; } else if (pos > soundDuration - 1) { pos = soundDuration - 1; }
		clearInterval(positionInterval);
		if(fileArray[currentItem]["file"] != currentURL) {
			var ref = this;
			currentURL = fileArray[currentItem]["file"];
			soundObject = new Sound(configArray["playerclip"]);
			soundObject.onSoundComplete = function() {
				ref.currentState = 3;
				ref.sendUpdate("state",3);
				ref.sendCompleteEvent();
			};
			soundObject.loadSound(currentURL,true);
			soundObject.setVolume(currentVolume);
			sendUpdate("load",0);
			loadedInterval = setInterval(this,"updateLoaded",200);
		}
		if(pos != undefined) { 
			currentPosition = pos;
			pos == 0 ? sendUpdate("time",0,soundDuration): null;
		}
		soundObject.start(currentPosition);
		updatePosition();
		positionInterval = setInterval(this,"updatePosition",200);
	};


	/** Read and broadcast the amount of the mp3 that's currently loaded **/
	private function updateLoaded() {
		var pct:Number = Math.round(soundObject.getBytesLoaded()/soundObject.getBytesTotal()*100);
		if(isNaN(pct)) { 
			currentLoaded = 0; 
			sendUpdate("load",0);
		} else if (pct != currentLoaded) { 
			sendUpdate("load",pct); 
			currentLoaded = pct;
		} else if(pct >= 100) { 
			clearInterval(loadedInterval);
			currentLoaded = 100;
			sendUpdate("load",100);
		}
	};


	/** Read and broadcast the current position of the song **/
	private function updatePosition() {
		var pos = soundObject.position/1000;
		soundDuration = soundObject.duration/(10*currentLoaded);
		if(pos == currentPosition && currentState != 1) {
			currentState = 1;
			sendUpdate("state",1);
		} else if (pos != currentPosition && currentState != 2) { 	
			currentState = 2;
			sendUpdate("state",2);
		}
		if (pos != currentPosition) {
			currentPosition = pos;
			sendUpdate("time",currentPosition,soundDuration-currentPosition);
		}
	};


	/** Pause the sound that's currently playing. **/
	private function setPause(pos:Number) {
		if(pos < 1) { pos = 0; } else if (pos > soundDuration - 1) { pos = soundDuration - 1; }
		soundObject.stop();
		clearInterval(positionInterval);
		currentState = 0;
		sendUpdate("state",0);
		if(pos != undefined) {
			currentPosition = pos;
			sendUpdate("time",currentPosition,soundDuration-currentPosition);
		}
	};


	/** stop and unload the sound **/
	private function setStop() {
		clearInterval(positionInterval);
		clearInterval(loadedInterval);
		delete currentURL;
		delete soundObject;
		soundDuration = 0;
		currentLoaded = 0;
	};


	/** Set volume of the sound object. **/
	private function setVolume(vol:Number) {
		super.setVolume(vol);
		currentVolume = vol;
		soundObject.setVolume(vol);
	};


}
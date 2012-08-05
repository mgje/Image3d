/**
* Image model class of the players MCV pattern.
*
* @author	Jeroen Wijering
* @version	1.2
**/


import com.jeroenwijering.players.*;
import com.jeroenwijering.utils.ImageLoader;


class com.jeroenwijering.players.ImageModel extends AbstractModel { 


	/** array with extensions used by this model **/
	private var activeExtensions:Array = new Array("jpg","gif","png","swf");
	/** ImageLoader instance **/
	private var imageLoader:ImageLoader;
	/** Clip to load the image into **/
	private var imageClip:MovieClip;
	/** image or SWF duration **/
	private var imageLength:Number;
	/** interval ID of image duration function **/
	private var currentPosition:Number = 0;
	/** interval ID of image duration function **/
	private var positionInterval:Number;
	/** current state **/
	private var currentState:Number;
	/** boolean to check for current SWF **/
	private var isSWF:Boolean;


	/** Constructor **/
	function ImageModel(vws:Array,ctr:AbstractController,car:Object,far:Array,imc:MovieClip) {
		super(vws,ctr,car,far);
		imageClip = imc;
		var ref = this;
		imageLength = configArray["rotatetime"];
		imageLoader = new ImageLoader(imageClip,configArray["overstretch"],configArray["width"],configArray["displayheight"]);
		imageLoader.onLoadFinished = function() {
			ref.currentState = 2;
			ref.sendUpdate("state",2);
			ref.sendUpdate("load",100);
			if(ref.isSWF == true) {
				ref.imageLength = ref.imageClip.mc._totalframes/20;
				ref.currentPosition = ref.imageClip.mc._currentframe/20 +1;
			}
		}
		imageLoader.onLoadProgress = function(tgt,btl,btt) {
			ref.sendUpdate("load",Math.round(btl/btt*100));
		}
	};


	/** Start display interval for a specific image **/
	private function setStart(pos:Number) {
		if(pos < 1 ) { pos = 0; } else if (pos > imageLength - 1) { pos = imageLength - 1; }
		clearInterval(positionInterval);
		if(fileArray[currentItem]["file"] != currentURL) {
			imageClip._visible = true;
			currentURL = fileArray[currentItem]["file"];
			imageLength = configArray["rotatetime"];
			fileArray[currentItem]["file"].indexOf(".swf") == -1 ? isSWF = false: isSWF = true;
			imageLoader.loadImage(fileArray[currentItem]["file"]);
			currentState = 1;
			sendUpdate("state",1);
			sendUpdate("load",0);
		} else {
			currentState = 2;
			sendUpdate("state",2);
		}
		if (pos != undefined) { 
			currentPosition = pos;
			isSWF == true ? imageClip.mc.gotoAndPlay(pos*20): null;
			pos == 0 ? sendUpdate("time",0,imageLength): null;
		} else { 
			isSWF == true ? imageClip.mc.play(): null;
		}
		positionInterval = setInterval(this,"updatePosition",200);
	};


	/** Read and broadcast the current position of the song **/
	private function updatePosition() {
		if(currentState == 2) { 
			currentPosition += 0.2;
			if(currentPosition >= imageLength || (isSWF == true && imageClip.mc._currentframe > imageClip.mc._totalframes - 5)) {
				currentState = 3;
				sendUpdate("state",3);
				sendCompleteEvent();
			} else {
				sendUpdate("time",currentPosition,imageLength-currentPosition);
			}
		}
	};


	/** stop the image display interval **/
	private function setPause(pos:Number) {
		if(pos < 1 ) { pos = 0; } else if (pos > imageLength - 1) { pos = imageLength - 1; }
		clearInterval(positionInterval);
		currentState = 0;
		sendUpdate("state",0);
		if(pos != undefined) {
			currentPosition = pos;
			sendUpdate("time",currentPosition,imageLength-currentPosition);
			isSWF == true ? imageClip.mc.gotoAndStop(pos*20+1): null;
		} else { 
			isSWF == true ? imageClip.mc.stop(): null;
		}
	};


	/** stop display of the item altogether **/
	private function setStop() {
		delete currentURL;
		clearInterval(positionInterval);
		imageLength = configArray["rotatetime"];
		currentPosition = 0;
		isSWF == true ? imageClip.mc.gotoAndStop(1): null;
		if (imageClip.bg == undefined) {
			imageClip.clear();
			imageClip._visible = false;
		}
	};


}
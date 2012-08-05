/**
* Rotator user interface View of the MCV cycle.
*
* @author	Jeroen Wijering
* @version	1.02
**/


import com.jeroenwijering.players.*;


class com.jeroenwijering.players.RotatorView extends AbstractView { 


	/** full width of the scrubbars **/
	private var currentItem:Number;
	/** clip that's currently active **/
	private var upClip:MovieClip;
	/** clip that's currently inactive **/
	private var downClip:MovieClip;
	/** boolean for whether to use the title display **/ 
	private var useTitle:Boolean;
	/** array with all transitions **/ 
	private var allTransitions:Array = new Array("fade","bgfade","blocks","circles","fluids","lines");
	/** boolean to see if the transition is done **/
	private var transitionDone:Boolean = false;
	/** boolean to detect first run **/ 
	private var firstRun:Boolean = true;


	/** Constructor **/
	function RotatorView(ctr:AbstractController,car:Object,far:Array) { 
		super(ctr,car,far);
	};


	/**
	* Sets up visibility, sizes and colors of all display and navigation items
	* (just an extremely long iteration of all controlbar items)
	**/
	private function onLoad() {
		var ref = this;
		var tgt:MovieClip = configArray["playerclip"];
		// set position, color  and link of background
		tgt.button._width = tgt.img1.bg._width = tgt.img2.bg._width = configArray["width"];
		tgt.button._height = tgt.img1.bg._height = tgt.img2.bg._height = configArray["height"];
		tgt.img1.col = new Color(tgt.img1.bg);
		tgt.img1.col.setRGB(configArray["backcolor"]);
		tgt.img2.col = new Color(tgt.img2.bg);
		tgt.img2.col.setRGB(configArray["backcolor"]);
		if(configArray["linkfromdisplay"] == "true") {
			tgt.button.onPress = function() { 
				ref.sendEvent("getlink",ref.currentItem);
			};
		} else {
			tgt.button.onPress = function() { 
				ref.sendEvent("next");
			};
		}
		// set depths of all items so the two images can be swapped by actionscript
		tgt.img1.swapDepths(1);
		tgt.img2.swapDepths(2);
		// depth 3 is for the masks
		tgt.playicn.swapDepths(4);
		tgt.activity.swapDepths(5);
		tgt.navigation.swapDepths(6);
		// set playicn and activity to middle
		tgt.playicn._x = tgt.activity._x = Math.round(configArray["width"]/2);
		tgt.playicn._y = tgt.activity._y = Math.round(configArray["height"]/2);
		// set sizes, colors, and clicks for navigation items
		if (configArray["shownavigation"] == "true") {
			tgt.navigation._y = configArray["height"] - 40;
			tgt.navigation._x = configArray["width"]/2 - 50;
			tgt.navigation.prevBtn.col1 = new Color(tgt.navigation.prevBtn.bck);
			tgt.navigation.prevBtn.col1.setRGB(configArray["backcolor"]);
			tgt.navigation.prevBtn.col2 = new Color(tgt.navigation.prevBtn.icn);
			tgt.navigation.prevBtn.col2.setRGB(configArray["frontcolor"]);
			tgt.navigation.itmBtn.col1 = new Color(tgt.navigation.itmBtn.bck);
			tgt.navigation.itmBtn.col1.setRGB(configArray["backcolor"]);
			tgt.navigation.itmBtn.txt.textColor = configArray["frontcolor"];
			tgt.navigation.nextBtn.col1 = new Color(tgt.navigation.nextBtn.bck);
			tgt.navigation.nextBtn.col1.setRGB(configArray["backcolor"]);
			tgt.navigation.nextBtn.col2 = new Color(tgt.navigation.nextBtn.icn);
			tgt.navigation.nextBtn.col2.setRGB(configArray["frontcolor"]);
			tgt.navigation.prevBtn.onRollOver = tgt.navigation.nextBtn.onRollOver = function() { 
				this.col2.setRGB(ref.configArray["lightcolor"]);
			};
			tgt.navigation.prevBtn.onRollOut = tgt.navigation.nextBtn.onRollOut = function() { 
				this.col2.setRGB(ref.configArray["frontcolor"]);
			};
			tgt.navigation.itmBtn.onRollOver = function() {
				this.txt.textColor = ref.configArray["lightcolor"];
			};
			tgt.navigation.itmBtn.onRollOut = function() {
				this.txt.textColor = ref.configArray["frontcolor"];
			};
			tgt.navigation.prevBtn.onPress = function() {
				ref.sendEvent("prev");
			};
			tgt.navigation.itmBtn.onPress = function() {
				ref.sendEvent("playpause");
			};
			tgt.navigation.nextBtn.onPress = function() {
				ref.sendEvent("next");
			};
			// set sizes, colors and buttons for image title
			if(fileArray[0]["title"] == undefined) {
				useTitle = false; 
				tgt.navigation.titleBtn._visible = false;
			} else {
				useTitle = true;
				tgt.navigation.titleBtn._x = 74;
				tgt.navigation.titleBtn.col1 = new Color(tgt.navigation.titleBtn.left);
				tgt.navigation.titleBtn.col1.setRGB(configArray["backcolor"]);
				tgt.navigation.titleBtn.col2 = new Color(tgt.navigation.titleBtn.mid);
				tgt.navigation.titleBtn.col2.setRGB(configArray["backcolor"]);
				tgt.navigation.titleBtn.col3 = new Color(tgt.navigation.titleBtn.right);
				tgt.navigation.titleBtn.col3.setRGB(configArray["backcolor"]);
				tgt.navigation.titleBtn.txt.autoSize = true;
				tgt.navigation.titleBtn.txt.textColor = configArray["frontcolor"];
				if(fileArray[0]["link"] != undefined) {
					tgt.navigation.titleBtn.onRollOver = function() {
						this.txt.textColor = ref.configArray["lightcolor"];
					};
					tgt.navigation.titleBtn.onRollOut = function() {
						this.txt.textColor = ref.configArray["frontcolor"];
					};
					tgt.navigation.titleBtn.onPress = function() {
						ref.sendEvent("getlink",ref.currentItem);
					};
				};
			}
		} else {
			tgt.navigation._visible = false;
		}
	};


	/** Override of the AbstractView's update receiver. **/
	public function getUpdate(typ:String,pr1:Number,pr2:Number):Void {
		switch(typ) {
			case "state": 
				switchState(pr1);
				break;
			case "item":
				setItem(pr1);
				break;
		}
	};


	/** New item: switch clips and ready transition **/
	private function setItem(pr1) {
		currentItem = pr1;
		transitionDone = false;
		configArray["playerclip"].navigation.itmBtn.txt.text = (currentItem+1)+" / "+fileArray.length;
		useTitle == true ? setTitle(): null;
		configArray["playerclip"].img1.swapDepths(configArray["playerclip"].img2);
		downClip = upClip;
		if (upClip == configArray["playerclip"].img1) {
			upClip = configArray["playerclip"].img2;
		} else {
			upClip = configArray["playerclip"].img1;
		}
	};


	/** Set new title in navigation bar. **/
	private function setTitle() {
		var tgt = configArray["playerclip"].navigation;
		tgt.titleBtn.txt.text = fileArray[currentItem]["title"];
		var len:Number = Math.ceil(tgt.titleBtn.txt._width);
		tgt.titleBtn.mid._width = len + 16;
		tgt.titleBtn.right._x = len + 20;
		tgt.nextBtn._x = len + 95;
		tgt._x = Math.round(configArray["width"]/2 - tgt._width/2);
	};


	/** 
	* State switch; show and hide the activity & play icon and start the transition
	*
	* @param stt	state (0:stop,1:buffer,2:play,3:complete)
	**/
	private function switchState(stt:Number) {
		switch(stt) {
			case 0:
				configArray["showicons"] == "true" ? configArray["playerclip"].playicn._visible = true: null;
				configArray["playerclip"].activity._visible = false;
				break;
			case 1:
				configArray["playerclip"].playicn._visible = false;
				configArray["showicons"] == "true" ? configArray["playerclip"].activity._visible = true: null;
				break;
			case 2:
				configArray["playerclip"].playicn._visible = false;
				configArray["playerclip"].activity._visible = false;
				transitionDone == false ? doTransition(): null;
				break;
		}
	};


	/** Start a transition **/
	private function doTransition() {
		transitionDone = true;
		if(firstRun == true) {
			configArray["playerclip"].img1._alpha = 100;
			configArray["playerclip"].img2._alpha = 0;
			firstRun = false;
		} else {
			var trs = configArray["transition"];
			trs == "random" ? trs = allTransitions[random(allTransitions.length)]: null;
			switch (trs) {
				case "fade":
					doFade();
					break;
				case "bgfade":
					doBGFade();
					break;
				case "blocks":
					doBlocks();
					break;
				case "circles":
					doCircles();
					break;
				case "fluids":
					doFluids();
					break;
				case "lines":
					doLines();
					break;
				default:
					doFade();
					break;
			}
		}
	};


	/** Function for the fade transition **/
	private function doFade() {
		upClip.ref = this;
		upClip._alpha = 0;
		upClip.onEnterFrame = function() {
			this._alpha +=5;
			if(this._alpha >= 100) {
				delete this.onEnterFrame;
				this.ref.downClip._alpha = 0;
			}
		};
	};


	/** Function for the bgfade transition **/
	private function doBGFade() {
		downClip.ref = upClip.ref = this;
		downClip.onEnterFrame = function() {
			this._alpha -=5;
			if(this._alpha <= 0) {
				delete this.onEnterFrame;
				this.ref.upClip.onEnterFrame = function() {
					if(this._alpha >= 100) {
						delete this.onEnterFrame;
					} else {
						this._alpha +=5;
					}
				};
			}
		};
	};


	/** Function for the circles transition **/
	function doCircles() {
		upClip._alpha = 100;
		configArray["playerclip"].attachMovie("circlesMask","mask",3);
		var msk:MovieClip = configArray["playerclip"].mask;
		upClip.setMask(msk);
		if (configArray["width"] > configArray["height"]) {
			msk._width = msk._height = configArray["width"];
		} else {
			msk._width = msk._height = configArray["height"];
		}
		msk.ref = this;
		msk._x = configArray["width"]/2;
		msk._y = configArray["height"]/2;
		msk.onEnterFrame = function() {
			this._rotation+=10;
			nextFrame();
			if(this._currentframe  == this._totalframes) {
				this.ref.downClip._alpha = 0;
				this.clear();
				this.unloadMovie();
				this.removeMovieClip();
			}
		};
	};


	/** Function for the blocks transition **/
	function doBlocks() {
		upClip._alpha = 100;
		configArray["playerclip"].attachMovie("blocksMask","mask",3);
		var msk:MovieClip = configArray["playerclip"].mask;
		if (configArray["width"] > configArray["height"]) {
			msk._width = msk._height = configArray["width"];
		} else {
			msk._width = msk._height = configArray["height"];
		}
		msk.ref = this;
		msk._rotation = random(4)*90;
		msk._rotation == 90 ? msk._x = configArray["width"]: null;
		msk._rotation == 180 ? msk._x = configArray["width"]: null;
		msk._rotation == 180 ? msk._y = configArray["height"]: null;
		msk._rotation == -90 ? msk._y = configArray["height"]: null;
		upClip.setMask(msk);
		msk.onEnterFrame = function() {
			nextFrame();
			if(this._currentframe  == this._totalframes) {
				this.ref.downClip._alpha = 0;
				this.clear();
				this.unloadMovie();
				this.removeMovieClip();
			}
		};
	}; 


	/** Function for the fluids transition **/
	function doFluids() {
		upClip._alpha = 100;
		configArray["playerclip"].attachMovie("fluidsMask","mask",3);
		var msk:MovieClip = configArray["playerclip"].mask;
		upClip.setMask(msk);
		msk.ref = this;
		msk._width = configArray["width"];
		msk._height = configArray["height"];
		msk.onEnterFrame = function() {
			nextFrame();
			if(this._currentframe  == this._totalframes) {
				this.ref.downClip._alpha = 0;
				this.clear();
				this.unloadMovie();
				this.removeMovieClip();
			}
		};
	};


	/** Function for the lines transition **/
	function doLines() {
		upClip._alpha = 100;
		configArray["playerclip"].attachMovie("linesMask","mask",3);
		var msk:MovieClip = configArray["playerclip"].mask;
		upClip.setMask(msk);
		msk.ref = this;
		msk._width = configArray["width"];
		msk._height = configArray["height"];
		msk.onEnterFrame = function() {
			nextFrame();
			if(this._currentframe  == this._totalframes) {
				this.ref.downClip._alpha = 0;
				this.clear();
				this.unloadMovie();
				this.removeMovieClip();
			}
		};
	};


}
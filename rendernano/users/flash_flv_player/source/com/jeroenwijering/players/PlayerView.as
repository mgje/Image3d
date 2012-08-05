/**
* Display and controlbar user interface management of the players MCV pattern.
*
* @author	Jeroen Wijering
* @version	1.5
**/


import com.jeroenwijering.players.*;
import com.jeroenwijering.utils.ImageLoader;


class com.jeroenwijering.players.PlayerView extends AbstractView { 


	/** reference to the  imageloader object **/
	private var  imageLoader:ImageLoader;
	/** full width of the scrubbars **/
	private var barWidths:Number;
	/** full width of the scrubbars **/
	private var currentItem:Number;
	/** duration of the currently playing item **/
	private var itemLength:Number;
	/** do not rescale loadbar on rebuffering **/
	private var wasLoaded:Boolean = false;


	/** Constructor **/
	function PlayerView(ctr:AbstractController,car:Object,far:Array) { 
		super(ctr,car,far);
		if(configArray["fullscreenmode"] == "true") { Stage.addListener(this); }
	};


	/** Sets up visibility, sizes and colors of all display and controlbar items. **/
	private function onLoad() {
		var ref = this;
		if(configArray["fullscreenmode"] == "true") { configArray["displayheight"] = configArray["height"]; }
		//
		// set position and color of background
		//
		var tgt = configArray["playerclip"].back;
		tgt._width = configArray["width"];
		tgt._height = configArray["height"];
		configArray["displayheight"] >= configArray["height"] - 20 ? tgt._height--: null;
		tgt.col = new Color(tgt);
		tgt.col.setRGB(configArray["backcolor"]);
		var col:Color = new Color(tgt.back);
		col.setRGB(configArray["backcolor"]);
		//
		// set position and color of display items
		//
		var tgt = configArray["playerclip"].display;
		if(configArray["displayheight"] == 0) { 
			tgt._visible = false;
		} else {
			configArray["playerclip"].displaymask._width = tgt.back._width = tgt.video._width = configArray["width"];
			configArray["playerclip"].displaymask._height = tgt.back._height = tgt.video._height = configArray["displayheight"];
			imageLoader = new ImageLoader(tgt.thumb,configArray["overstretch"],configArray["width"],configArray["displayheight"]);
			tgt.playicon._x = tgt.activity._x = Math.round(configArray["width"]/2);
			tgt.playicon._y = tgt.activity._y = Math.round(configArray["displayheight"]/2);
			if(configArray["logo"] != "undefined") {
				var lll = new ImageLoader(tgt.logo,"none",0,0);
				lll.loadImage(configArray["logo"]);
				lll.onLoadFinished = function() {
					var tgt = ref.configArray["playerclip"].display.logo;
					tgt._x = ref.configArray["width"] - Math.round(tgt._width/2) -10;
					tgt._y = ref.configArray["displayheight"] - Math.round(tgt._height/2) -10;
				};
				tgt.logo.onRelease = function() { ref.sendEvent("getlink",ref.currentItem); };
			}
			tgt.activity._visible = false;
			configArray["showicons"] == "false" ? tgt.playicon._visible = false: null;
			if(configArray["linkfromdisplay"] == "true") {
				tgt.playicon._visible = false;
				tgt.back.onRelease = function() { ref.sendEvent("getlink",ref.currentItem); };
			} else {
				tgt.back.onRelease = function() { ref.sendEvent("playpause"); };
			}
		}
		//
		// set position, color and click of controlbar back
		//
		var tgt = configArray["playerclip"].controlbar;
		if(configArray["fullscreenmode"] == "true") {
			tgt._y = configArray["height"] - 40;
			tgt._x = Math.round(configArray["width"]/2-200);
			var cbw = 400;
			tgt.back._alpha = 33;
		} else {	
			tgt._y = configArray["displayheight"];
			var cbw = configArray["width"];
		}
		tgt.back._width = cbw;
		tgt.col = new Color(tgt.back);
		tgt.col.setRGB(configArray["backcolor"]);
		//
		// play and pause buttons
		//
		tgt.playpause.col1 = new Color(tgt.playpause.ply);
		tgt.playpause.col1.setRGB(configArray["frontcolor"]);
		tgt.playpause.col2 = new Color(tgt.playpause.pas);
		tgt.playpause.col2.setRGB(configArray["frontcolor"]);
		tgt.playpause.onRollOver = function() { 
			this.col1.setRGB(ref.configArray["lightcolor"]);
			this.col2.setRGB(ref.configArray["lightcolor"]);
		};
		tgt.playpause.onRollOut = function() { 
			this.col1.setRGB(ref.configArray["frontcolor"]);
			this.col2.setRGB(ref.configArray["frontcolor"]);
		};
		tgt.playpause.onPress = function() { ref.sendEvent("playpause"); };
		//
		// previous and next buttons
		//
		if(fileArray.length == 1) {
			tgt.prev._visible = tgt.next._visible = false;
		} else { 
			tgt.prev._visible = tgt.next._visible = true;
			tgt.prev.col = new Color(tgt.prev.icn);
			tgt.prev.col.setRGB(configArray["frontcolor"]);
			tgt.prev.onRollOver = function() { this.col.setRGB(ref.configArray["lightcolor"]); };
			tgt.prev.onRollOut = function() { this.col.setRGB(ref.configArray["frontcolor"]); };
			tgt.prev.onPress = function() { ref.sendEvent("prev"); };
			tgt.next.col = new Color(tgt.next.icn);
			tgt.next.col.setRGB(configArray["frontcolor"]);
			tgt.next.onRollOver = function() { this.col.setRGB(ref.configArray["lightcolor"]); };
			tgt.next.onRollOut = function() { this.col.setRGB(ref.configArray["frontcolor"]); };
			tgt.next.onPress = function() { ref.sendEvent("next"); };
		}
		//
		// scrub button (including digits)
		//
		if(fileArray.length == 1) {
			tgt.scrub.shd._width = cbw-72;
			tgt.scrub._x = 17;
		} else {
			tgt.scrub.shd._width = cbw-106;
			tgt.scrub._x = 51;
		}
		configArray["showfsbutton"] == "true" ? null: tgt.scrub.shd._width += 18;
		if(configArray["showdigits"] == "false") {
			tgt.scrub.elpTxt._visible = tgt.scrub.remTxt._visible = false;
			tgt.scrub.bar._x = tgt.scrub.bck._x = tgt.scrub.icn._x = 5;
			barWidths = tgt.scrub.bck._width = tgt.scrub.bar._width = tgt.scrub.shd._width - 10;
		} else {
			barWidths = tgt.scrub.bck._width = tgt.scrub.bar._width = tgt.scrub.shd._width - 84;
			tgt.scrub.remTxt._x = tgt.scrub.shd._width - 39;
			tgt.scrub.elpTxt.textColor = tgt.scrub.remTxt.textColor = configArray["frontcolor"];
		}
		tgt.scrub.col = new Color(tgt.scrub.icn);
		tgt.scrub.col.setRGB(configArray["frontcolor"]);
		tgt.scrub.col2 = new Color(tgt.scrub.bar);
		tgt.scrub.col2.setRGB(configArray["frontcolor"]);
		tgt.scrub.col3 = new Color(tgt.scrub.bck);
		tgt.scrub.col3.setRGB(configArray["frontcolor"]);
		tgt.scrub.bck.onRollOver = function() { 
			this._parent.col.setRGB(ref.configArray["lightcolor"]);
		};
		tgt.scrub.bck.onRollOut = function() { 
			this._parent.col.setRGB(ref.configArray["frontcolor"]);
		};
		tgt.scrub.bck.onPress = function() { 
			this.onEnterFrame = function() {
				var xm = this._parent._xmouse;
				if(xm < this._parent.bck._width + this._parent.bck._x && xm > this._parent.bck._x) {
					this._parent.icn._x = this._parent._xmouse - 1;
				}
			}
		};
		tgt.scrub.bck.onRelease = tgt.scrub.bck.onReleaseOutside = function() {
			var sec = (this._parent._xmouse-this._parent.bar._x)/ref.barWidths*ref.itemLength;
			ref.sendEvent("scrub",Math.round(sec));
			delete this.onEnterFrame;
		};
		//
		// fullscreen button
		//
		if(configArray["showfsbutton"] == "true") {
			tgt.fs._x = cbw - 55;
			if (configArray["fullscreenmode"] == "true") { 
				tgt.fs.fs._visible = false;
				tgt.fs.col = new Color(tgt.fs.ns);
			} else { 
				tgt.fs.ns._visible = false;
				tgt.fs.col = new Color(tgt.fs.fs);
			}
			tgt.fs.col.setRGB(ref.configArray["frontcolor"]);
			tgt.fs.onRollOver = function() { this.col.setRGB(ref.configArray["lightcolor"]); };
			tgt.fs.onRollOut = function() { this.col.setRGB(ref.configArray["frontcolor"]); };
			tgt.fs.onPress = function() { ref.sendEvent("fullscreen"); };
		} else {
			tgt.fs._visible = false;
		}
		//
		// and volume button
		//
		cbw > 20 ? tgt.vol._x = cbw - 37: null;
		tgt.vol.col = new Color(tgt.vol.bar);
		tgt.vol.col.setRGB(configArray["frontcolor"]);
		tgt.vol.col2 = new Color(tgt.vol.icn);
		tgt.vol.col2.setRGB(configArray["frontcolor"]);
		tgt.vol.col3 = new Color(tgt.vol.bck);
		tgt.vol.col3.setRGB(configArray["frontcolor"]);
		tgt.vol.onRollOver = function() { 
			this.col.setRGB(ref.configArray["lightcolor"]);
			this.col2.setRGB(ref.configArray["lightcolor"]);
		};
		tgt.vol.onRollOut = function() { 
			this.col.setRGB(ref.configArray["frontcolor"]);
			this.col2.setRGB(ref.configArray["frontcolor"]);
		};
		tgt.vol.onPress = function() { 
			this.onEnterFrame = function() { this.msk._width = this._xmouse-12; }; 
		};
		tgt.vol.onRelease = tgt.vol.onReleaseOutside = function() { 
			ref.sendEvent("volume",(this._xmouse-12)*5);
			delete this.onEnterFrame; 
		};
	};


	/** Show and hide the play/pause button and show activity icon **/
	private function setState(stt:Number) {
		switch(stt) {
			case 0:
				configArray["playerclip"].controlbar.playpause.ply._visible = true;
				configArray["playerclip"].controlbar.playpause.pas._visible = false;
				if (configArray["linkfromdisplay"] == "false" && configArray["displayheight"] > 0 && configArray["showicons"] == "true") {
					configArray["playerclip"].display.playicon._visible = true;
					configArray["playerclip"].display.activity._visible = false;
				}
				break;
			case 1:
				configArray["playerclip"].controlbar.playpause.pas._visible = true;
				configArray["playerclip"].controlbar.playpause.ply._visible = false;
				if (configArray["displayheight"] > 0 && configArray["showicons"] == "true") {
					configArray["playerclip"].display.playicon._visible = false;
					configArray["playerclip"].display.activity._visible = true;
				}
				break;
			case 2:
				configArray["playerclip"].controlbar.playpause.pas._visible = true;
				configArray["playerclip"].controlbar.playpause.ply._visible = false;
				configArray["playerclip"].display.playicon._visible = false;
				configArray["playerclip"].display.activity._visible = false;
				break;
		}
	};


	/** Print current time to controlBar **/
	private function setTime(elp:Number,rem:Number) {
		itemLength = elp + rem;
		var tgt = configArray["playerclip"].controlbar.scrub;
		tgt.bar._width = Math.floor(elp/(elp+rem)*barWidths)-2;
		elp == 0 ? tgt.bar._width = 0: null;
		tgt.icn._x = tgt.bar._width + tgt.bar._x + 1;
		tgt.elpTxt.text = addLeading(elp/60)+":"+addLeading(elp%60);
		tgt.bck._width == barWidths ? tgt.remTxt.text = addLeading(rem/60)+":"+addLeading(rem%60): null;
	};


	/** Print current buffer amount to controlbar **/
	private function setLoad(pct:Number) {
		if(wasLoaded == false) {
			configArray["playerclip"].controlbar.scrub.bck._width = Math.round(barWidths*pct/100);
		}
		configArray["playerclip"].controlbar.scrub.remTxt.text = Math.round(pct)+" %";
		pct == 100 ? wasLoaded = true: null;
	};


	/** Reflect current volume in volumebar **/
	private function setVolume(pr1:Number) {
		configArray["playerclip"].controlbar.vol.msk._width = Math.round(pr1/5);
	};


	/** Load Thumbnail image if available. **/
	private function setItem(idx:Number) {
		currentItem = idx;
		wasLoaded = false;
		if(configArray["displayheight"] > 0) {
			if(fileArray[idx]["image"] == "undefined") { 
				configArray["playerclip"].display.thumb.clear();
			} else {
				imageLoader.loadImage(fileArray[idx]["image"]);
			}
		}
	};


	/** Add a leading zero and convert number to string **/
	private function addLeading(nbr:Number):String { 
		if(nbr < 10) {
			return "0"+Math.floor(nbr);
		} else {
			return Math.floor(nbr).toString();
		}
	};


	/** OnResize Handler: catches stage resizing in fullscreenmode **/
	public function onResize() {
		var tgt = configArray["playerclip"].controlbar;
		tgt._x = Math.round(Stage.width/2-150);
		tgt._y = Stage.height-40;
		configArray["playerclip"].display._width = configArray["playerclip"].displaymask._width = Stage.width;
		configArray["playerclip"].display._height = configArray["playerclip"].displaymask._height = Stage.height;
	};


}
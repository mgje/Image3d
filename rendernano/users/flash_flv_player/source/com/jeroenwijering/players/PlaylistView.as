/**
* Playlist view management of the players MCV pattern.
*
* @author	Jeroen Wijering
* @version	1.2
**/


import com.jeroenwijering.players.*;
import com.jeroenwijering.utils.Scroller;
import com.jeroenwijering.utils.ImageLoader;


class com.jeroenwijering.players.PlaylistView extends AbstractView { 


	/** ImageLoader **/
	private var thumbLoader:ImageLoader;
	/** Scroller instance **/
	private var listScroller:Scroller;
	/** Currently highlighted playlist item **/
	private var currentItem:Number;


	/** Constructor **/
	function PlaylistView(ctr:AbstractController,car:Object,far:Array) { super(ctr,car,far); };


	/** OnLoad event handler; sets up the playlist sizes and colors. **/
	private function onLoad() {
		var ref = this;
		var tgt = configArray["playerclip"].playlist;
		tgt.btn._visible = false;
		for (var i=99; i >=0; i--) { tgt["btn"+i].removeMovieClip(); }
		// iterate playlist and setup each button
		for(var i=0; i<fileArray.length; i++) {
			// set text and background
			tgt.btn.duplicateMovieClip("btn"+i,i);
			tgt["btn"+i].txt._width = configArray["width"] - 20;
			tgt["btn"+i].col = new Color(tgt["btn"+i].bck);
			tgt["btn"+i].col.setRGB(configArray["frontcolor"]);
			tgt["btn"+i].col2 = new Color(tgt["btn"+i].icn);
			tgt["btn"+i].col2.setRGB(configArray["frontcolor"]);
			tgt["btn"+i].bck._width = configArray["width"]-2;
			tgt["btn"+i].bck.onRollOver = function() { 
				this._parent.txt.textColor = ref.configArray["backcolor"];
				this._parent.col.setRGB(ref.configArray["lightcolor"]);
				this._parent.col2.setRGB(ref.configArray["backcolor"]);
				if(ref.currentItem != this._parent.getDepth()) {
					this._alpha = 85;
				}
			};
			tgt["btn"+i].bck.onRollOut = function() { 
				this._parent.col.setRGB(ref.configArray["frontcolor"]);
				if(ref.currentItem != this._parent.getDepth()) {
					this._parent.txt.textColor = ref.configArray["frontcolor"];
					this._parent.col2.setRGB(ref.configArray["frontcolor"]);
					this._alpha = 15;
				}
			};
			tgt["btn"+i].bck.onRelease = function() {
				ref.sendEvent("playitem",this._parent.getDepth());
			};
			// set thumbnails
			if(configArray["thumbsinplaylist"] == "true") {
				tgt["btn"+i].bck._height = 40;
				tgt["btn"+i].icn._y += 9;
				tgt["btn"+i].txt._x += 60;
				tgt["btn"+i].txt._width -= 60;
				tgt["btn"+i].txt._height += 20;
				tgt["btn"+i]._y = i*41;
				thumbLoader = new ImageLoader(tgt["btn"+i].img,"true",60,40);
				thumbLoader.loadImage(fileArray[i]["image"]);
				if(fileArray[i]["author"]  == undefined) {
					tgt["btn"+i].txt.htmlText = "<b>"+(i+1)+ "</b>:<br />" + fileArray[i]["title"];
				} else {
					tgt["btn"+i].txt.htmlText = "<b>"+fileArray[i]["author"] + "</b>:<br />" + fileArray[i]["title"];
				}
				tgt["btn"+i].img.setMask(tgt["btn"+i].msk);
			} else {
				tgt["btn"+i].msk._height = 10;
				tgt["btn"+i].img._visible = tgt["btn"+i].msk._visible = false;
				tgt["btn"+i]._y = i*23;
				if(fileArray[i]["author"]  == undefined) {
					tgt["btn"+i].txt.htmlText = fileArray[i]["title"];
				} else {
					tgt["btn"+i].txt.htmlText = fileArray[i]["author"] + " - " + fileArray[i]["title"];
				}
			}
			tgt["btn"+i].txt.textColor = configArray["frontcolor"];
			// set link icon
			if(fileArray[i]["link"] != undefined) {
				tgt["btn"+i].txt._width -= 20;
				tgt["btn"+i].icn._x = Number(configArray["width"]) - 24;
				tgt["btn"+i].icn.onRollOver = function() { 
					this._parent.col2.setRGB(ref.configArray["lightcolor"]);
				};
				tgt["btn"+i].icn.onRollOut = function() { 
					if(ref.currentItem == this._parent.getDepth()) {
						this._parent.col2.setRGB(ref.configArray["backcolor"]);
					} else {
						this._parent.col2.setRGB(ref.configArray["frontcolor"]);
					}
				};
				tgt["btn"+i].icn.onPress = function() { 
					ref.sendEvent("getlink",this._parent.getDepth());
				};
			} else { 
				tgt["btn"+i].icn._visible = false;
			}
		}
		// setup mask and scrollbar if needed
		var msk = configArray["playerclip"].playlistmask;
		msk._y = tgt._y = Number(configArray["displayheight"]) + 19;
		msk._width = Number(configArray["width"]-2);
		msk._height = Number(configArray["height"])-Number(configArray["displayheight"]) - 20;
		tgt.setMask(msk);
		if(tgt._height > msk._height && fileArray.length > 1) {
			if(configArray["autoscroll"] == "false") {
				msk._width -= 11;
				for(var i=0; i<fileArray.length; i++) {
					tgt["btn"+i].bck._width -= 11;
					tgt["btn"+i].icn._x -= 11;
				}
				listScroller = new Scroller(tgt,msk,false,configArray["frontcolor"],configArray["lightcolor"]);
			} else {	
				listScroller = new Scroller(tgt,msk,true,configArray["frontcolor"],configArray["lightcolor"]);
			}
		}
	};


	/** Set a new item as the current playing one **/
	private function setItem(itm:Number):Void {
		var tgt = configArray["playerclip"].playlist;
		tgt["btn"+currentItem].col.setRGB(configArray["frontcolor"]);
		tgt["btn"+currentItem].bck._alpha = 15;
		tgt["btn"+currentItem].col2.setRGB(configArray["frontcolor"]);
		tgt["btn"+currentItem].txt.textColor = configArray["frontcolor"];
		currentItem = itm;
		tgt["btn"+currentItem].txt.textColor = configArray["backcolor"];
		tgt["btn"+currentItem].col2.setRGB(configArray["backcolor"]);
		tgt["btn"+currentItem].bck._alpha = 85;
		configArray["autoscroll"] == "false" ? null: listScroller.scrollTo(tgt["btn"+currentItem]._y);
	};


}
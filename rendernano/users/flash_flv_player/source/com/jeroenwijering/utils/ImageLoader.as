/**
* Class for loading, scaling and smoothing images to a given MovieClip.
*
* @example 
* import com.jeroenwijering.utils.ImageLoader;
* var myLoader = new ImageLoader(this);
* myLoader.loadImage("somephoto.jpg");
* 
* @author	Jeroen Wijering
* @version	1.7
**/


import com.jeroenwijering.utils.*;


class com.jeroenwijering.utils.ImageLoader {


	/** MovieClip Loader Instance **/
	private var mcLoader:MovieClipLoader;
	/** Target MovieClip **/
	private var targetClip:MovieClip;
	/** Target Width **/
	private var targetWidth:Number;
	/** Target Height **/
	private var targetHeight:Number;
	/** Overstretch Boolean **/
	private var overStretch:String = "fit";
	/** Boolean that checks whether an SWF is loaded **/
	private var useSmoothing:Boolean;


	/**
	 * Constructor for the ImageLoader
	 *
	 * @param tgt	MovieClip to load the image into
	 * @param ost	Overstretch parameter (true/false/fit/none)
	 * @param wid	Width of the image target, defaults to target movieclip width
	 * @param hei	Height if the image target, defaults to target movieclip height
	 */
	function ImageLoader(tgt:MovieClip,ost:String,wid:Number,hei:Number) {
		targetClip = tgt;
		arguments.length > 1 ? overStretch = String(ost): null;
		if(arguments.length > 2) { 
			targetWidth = wid;
			targetHeight = hei;
		} else {
			targetWidth = targetClip._width;
			targetHeight = targetClip._height;
		}
		mcLoader = new MovieClipLoader();
		mcLoader.addListener(this);
	};


	/** Switch image with bitmaparray if possible. **/
	public function onLoadInit(inTarget:MovieClip):Void {
		if(useSmoothing  == true) {
			var bmp = new flash.display.BitmapData(targetClip.mc._width,targetClip.mc._height, true, 0x000000);
			bmp.draw(targetClip.mc);
			var bmc:MovieClip = targetClip.createEmptyMovieClip("smc", targetClip.getNextHighestDepth());
			bmc.attachBitmap(bmp, bmc.getNextHighestDepth(),"auto",true);
			targetClip.mc.unloadMovie();
			targetClip.mc.removeMovieClip();
			delete targetClip.mc;
			scaleImage(bmc);
		} else { 
			scaleImage(targetClip.mc);	
		}
		onLoadFinished();
	};


	/** Scale the image while maintaining aspectratio **/
	private function scaleImage(tgt:MovieClip):Void {
		var tcf = tgt._currentframe;
		tgt.gotoAndStop(1);
		var xsr:Number = targetWidth/tgt._width;
		var ysr:Number = targetHeight/tgt._height;
		if ((overStretch == "true" && xsr > ysr) || (overStretch == "false" && xsr < ysr)) { 
			tgt._xscale = tgt._yscale = xsr*100;
		} else if(overStretch == "none") {
			tgt._xscale = tgt._yscale = 100;
		} else if (overStretch == "fit") {
			tgt._width = targetWidth;
			tgt._height = targetHeight;
		} else { 
			tgt._xscale = tgt._yscale = ysr*100;
		}
		tgt._x = targetWidth/2 - tgt._width/2;
		tgt._y = targetHeight/2 - tgt._height/2;
		tgt.gotoAndPlay(tcf);
	};


	/**
	 * Start loading an image.
	 *
	 * @param img	URL of the image to load.
	 */
	public function loadImage(img:String):Void {
		targetClip.mc.clear();
		targetClip.smc.unloadMovie();
		targetClip.smc.removeMovieClip();
		delete targetClip.smc;
		checkSmoothing(img);
		var raw:MovieClip = targetClip.createEmptyMovieClip("mc",1);
		mcLoader.loadClip(img,raw);
	};


	/** Check whether smoothing can be enabled. **/
	private function checkSmoothing(img:String):Void {
		var idx:Number = _root._url.indexOf("/",8);
		var rot:String = _root._url.substring(0,idx);
		if(img.toLowerCase().indexOf(".swf") > -1 || _root._url.indexOf("file://") > -1) {
			useSmoothing = false;
		} else  if (img.indexOf("http://") > -1 && img.indexOf(rot) == -1) {
			useSmoothing = false;
		} else  if (System.capabilities.version.indexOf("7,0,") > -1) {
			useSmoothing = false;
		} else {
			useSmoothing = true;
		}
	};


	/** Event handler; invoked when loading is in progress. **/
	public function onLoadProgress(tgt:MovieClip,btl:Number,btt:Number) { };


	/** Event handler; invoked when image is loaded. **/
	public function onLoadFinished() { };


}
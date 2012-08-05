/**
* Abstract model class of the players MCV pattern, extended by all models.
*
* @author	Jeroen Wijering
* @version	1.2
**/


import com.jeroenwijering.players.*;


class com.jeroenwijering.players.AbstractModel {


	/** a list of all registered views **/
	private var registeredViews:Array;
	/** a reference to the controller (for completes) **/
	private var controller:AbstractController;
	/** reference to the config array **/
	private var configArray:Object;
	/** reference to the file array **/
	private var fileArray:Array;
	/** item that's currently playing **/
	private var currentItem:Number;
	/** url of the item that's currently used by this model **/
	private var currentURL:String;
	/** array with extensions used by a model **/
	private var activeExtensions:Array;
	/** boolean to check if a model is currently active **/
	private var isActive:Boolean;


	/**
	* Constructor
	*
	* @param vws	an array with all views to register
	* @param ply	reference to the mediaplayer (for file and config array)
	**/
	function AbstractModel(vws:Array,ctr:AbstractController,car:Object,far:Array) {
		registeredViews = vws;
		controller = ctr;
		configArray = car;
		fileArray = far;
	};


	/**
	* Receive changes from the PlayerController.
	* 
	* @param typ	event type
	* @param par	parameter value
	**/
	public function getChange(typ:String,prm:Number):Void {
		trace("model: "+typ+": "+prm);
		switch(typ) {
			case "item":
				setItem(prm);
				break;
			case "start":
				isActive == true ? setStart(prm): null;
				break;
			case "pause":
				isActive == true ? setPause(prm): null;
				break;
			case "stop":
				isActive == true ? setStop(): null;
				break;
			case "volume":
				setVolume(prm);
				break;
			default:
				trace("Model: incompatible change received");
				break;
		}
	};


	/**
	* Set new item and check if the model should be the active one.
	* If so, the model forwards the new item to the views.
	*
	* @param idx	fileArray index of the item to check
	**/
	private function setItem(idx:Number) {
		currentItem = idx;
		var fnd:Boolean = false;
		for (var i=0; i<activeExtensions.length; i++) {
			if(fileArray[idx]["file"].toLowerCase().indexOf(activeExtensions[i]) > -1 ) { 
				fnd = true;
			}
		}
		if(fnd == true) {
			isActive = true;
			sendUpdate("item",idx);
		} else {
			isActive = false;
		}
	};


	/** Start function. **/
	private function setStart(prm:Number) {};


	/** Pause function. **/
	private function setPause(prm:Number) {};


	/** Stop function. **/
	private function setStop() {};


	/** Set volume and pass through if active. **/
	private function setVolume(vol:Number) { isActive == true ? sendUpdate("volume",vol): null; };


	/** Send updates to the views. **/
	private function sendUpdate(typ:String,prm:Number,pr2:Number) {
		for(var i=0; i<registeredViews.length; i++) {
			registeredViews[i].getUpdate(typ,prm,pr2);
		}
	};


	/** Send a "complete" event directly to the controller. **/
	private function sendCompleteEvent() { controller.getEvent("complete"); };


}
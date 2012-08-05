/**
* Basic view class of the players MCV pattern, extended by all views.
* Create you own views by extending this one.
*
* @author	Jeroen Wijering
* @version	1.1
**/


import com.jeroenwijering.players.*;


class com.jeroenwijering.players.AbstractView { 


	/** Controller reference **/
	private var controller:AbstractController;
	/** reference to the config array **/
	private var configArray:Object;
	/** reference to the file array **/
	private var fileArray:Array;


	/**
	* Constructor
	*
	* @param ctr	reference to the PlayerController
	* @param car	reference to the player's config array
	* @param far	reference to the player's file array
	**/
	function AbstractView(ctr:AbstractController,car:Object,far:Array) {
		controller = ctr;
		configArray = car;
		fileArray = far;
		onLoad();
	};


	/** onLoad event handler; sets up the view. **/
	private function onLoad() {};


	/**
	* Receive updates from the models.
	* 
	* The updates events are catched (parameter between brackets):
	* state(0:'play',1:'pause',2:'buffer',3:conplete),buffer(percent),
	* time(elapsed,remaining),volume(percent),item(index)
	* 
	* @param typ	event type
	* @param prm	parameter value
	* @param pr2	second parameter value
	**/
	public function getUpdate(typ:String,pr1:Number,pr2:Number):Void {
		trace("view: "+typ+": "+pr1+","+pr2);
		switch(typ) {
			case "state":
				setState(pr1);
				break;
			case "load":
				setLoad(pr1);
				break;
			case "time":
				setTime(pr1,pr2);
				break;
			case "item":
				setItem(pr1);
				break;
			case "volume":
				setVolume(pr1);
				break;
			default:
				trace("View: incompatible update received");
				break;
		}
	};


	/** Empty state handler **/
	private function setState(pr1:Number) {};


	/** Empty load handler **/
	private function setLoad(pr1:Number) {};


	/** Empty time handler **/
	private function setTime(pr1:Number,pr2:Number) {};


	/** Empty item handler **/
	private function setItem(pr1:Number) {};


	/** Empty volume handler **/
	private function setVolume(pr1:Number) {};


	/** Send event to the controller. **/
	private function sendEvent(typ:String,prm:Number) { controller.getEvent(typ,prm); };


}
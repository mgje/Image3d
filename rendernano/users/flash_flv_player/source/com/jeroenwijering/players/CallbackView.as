/**
* Callback to serverside script for statistics handling.
* It sends the current file,title,id and state on start and complete of an item.
*
* @author	Jeroen Wijering
* @version	1.3
**/


import com.jeroenwijering.players.*;


class com.jeroenwijering.players.CallbackView extends AbstractView { 


	/** Currently playing item **/
	private var currentItem:Number;
	/** Currently playing item **/
	private var varsObject:LoadVars;
	/** Boolean for if a start call has already been sent for the current item. **/
	private var playSent:Boolean = true;
	/** Small interval so both a complete+play event won't be issued within 1/10 second  **/
	private var playSentInt:Number;
	/** Number of minutes elapsed **/
	private var elapsedMinute:Number;


	/** Constructor **/
	function CallbackView(ctr:AbstractController,car:Object,far:Array) {
		super(ctr,car,far);
		varsObject = new LoadVars();
	};


	/** Send a callback on state change **/
	private function setState(pr1:Number) {
		if(pr1 == 3) { 
			sendVars("complete");
			playSent = false;
		} else if (pr1 == 2 && playSent == false) {
			playSentInt = setInterval(this,"sendVars",200,"play");
			playSent = true;
		} else if (pr1 == 0 && playSent == true) {
			sendVars("paused");
		}
	};


	/** Check if an entire minute has elapsed. If so, fire a callback. **/
	private function setTime(elp:Number,rem:Number) {
		var emn = Math.floor(elp/60);
		if(emn != elapsedMinute && emn > 0) {
			elapsedMinute = emn;
			emn == 1 ? sendVars(emn+" minute done"): sendVars(emn+" minutes done");
		}
	};


	/** save the currently playing item **/
	private function setItem(pr1:Number) { currentItem = pr1; };


	/** sending the current file,title,id,state to an external callback location **/
	private function sendVars(stt:String) {
		clearInterval(playSentInt);
		varsObject.file = fileArray[currentItem]["file"];
		varsObject.title = fileArray[currentItem]["title"];
		varsObject.id = fileArray[currentItem]["id"];
		varsObject.state = stt;
		varsObject.sendAndLoad(configArray["callback"],varsObject,"POST");
	};


}
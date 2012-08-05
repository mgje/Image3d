/**
* Javascript user interface management of the players MCV pattern.
*
* @author	Jeroen Wijering
* @version	1.2
**/


import com.jeroenwijering.players.*;


class com.jeroenwijering.players.JavascriptView extends AbstractView { 


	/** Previous loading value **/
	private var oldLoad:Number;
	/** Previous elapsed value **/
	private var oldElapsed;
	/** Previous remaining value **/
	private var oldRemaining;


	/** Constructor **/
	function JavascriptView(ctr:AbstractController,car:Object,far:Array) {
		super(ctr,car,far);
		if(flash.external.ExternalInterface.available) {
			var scs:Boolean = flash.external.ExternalInterface.addCallback("sendEvent",this,sendEvent);
			flash.external.ExternalInterface.call("getUpdate","load",0);
		}
	};


	/** Override of the update receiver; rounding numbers and forwarding all to javascript **/
	public function getUpdate(typ:String,pr1:Number,pr2:Number):Void { 
		if(flash.external.ExternalInterface.available) {
			switch(typ) {
				case "state":
					flash.external.ExternalInterface.call("getUpdate",typ,pr1,pr2);
					break;
				case "load":
					if(Math.round(pr1) != oldLoad) {
						oldLoad = Math.round(pr1);
						flash.external.ExternalInterface.call("getUpdate",typ,oldLoad,pr2);
					}
					break;
				case "time":
					if(Math.round(pr1) != oldElapsed || Math.round(pr2) != oldRemaining) {
						oldElapsed = Math.round(pr1);
						oldRemaining = Math.round(pr2);
						flash.external.ExternalInterface.call("getUpdate",typ,oldElapsed,oldRemaining);
					}
					break;
				case "item":
					flash.external.ExternalInterface.call("getUpdate",typ,pr1,pr2);
					flash.external.ExternalInterface.call("itemData",fileArray[pr1]);
					break;
				case "volume":
						flash.external.ExternalInterface.call("getUpdate",typ,pr1,pr2);
					break;
			}
		}
	};


}
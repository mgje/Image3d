/**
* User input management of the players MCV pattern.
*
* @author	Jeroen Wijering
* @version	1.2
**/


import com.jeroenwijering.players.*;
import com.jeroenwijering.utils.*;


class com.jeroenwijering.players.RotatorController extends AbstractController {


	/** Which one of the models to send the changes to **/
	private var currentModel:Number;


	/** Constructor, inherited from super **/
	function RotatorController(car:Object,far:Array) { super(car,far); };


	/** Switch active model and send changes to the currently active image model. **/
	private function sendChange(typ:String,prm:Number):Void {
		if(typ == "item") { currentModel == 0 ? currentModel = 1: currentModel = 0; }
		registeredModels[currentModel].getChange(typ,prm);
	};


}
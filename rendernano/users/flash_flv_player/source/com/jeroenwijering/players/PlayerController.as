/**
* User input management of the players MCV pattern.
*
* @author	Jeroen Wijering
* @version	1.3
**/


import com.jeroenwijering.players.*;
import com.jeroenwijering.utils.*;


class com.jeroenwijering.players.PlayerController extends AbstractController {


	/** use SharedObject to save current file, item and volume **/
	private var playerSO:SharedObject;


	/** Constructor **/
	function PlayerController(car:Object,far:Array) {
		super(car,far);
		playerSO = SharedObject.getLocal("com.jeroenwijering.players", "/");
		if(configArray["fullscreenmode"] == "true" && playerSO.data.lastItem != undefined) { 
			currentItem = playerSO.data.lastItem;
			configArray["fsreturnpage"] = playerSO.data.fsreturnpage;
		}
	};


	/** Complete the build of the MCV cycle and start flow of events. **/
	public function startMCV(mar:Array) {
		super.startMCV(mar);
		if(playerSO.data.volume != undefined && _root.volume == undefined) {
			sendChange("volume",playerSO.data.volume);
		} else {
			sendChange("volume",Number(configArray["volume"]));
		}
	};


	/** Check volume percentage and forward to models. **/
	private function setVolume(prm) {
		if (prm < 0 ) { 
			prm = 0; 
		} else if (prm > 100) { 
			prm = 100;
		}
		playerSO.data.volume = prm;
		playerSO.flush();
		sendChange("volume",prm);
	};


	
	/** Fullscreen switch function. **/
	private function setFullscreen() {
		if(configArray["fullscreenmode"] == "true") { 
			getURL(unescape(configArray["fsreturnpage"]));
		} else {
			sendChange("stop");
			playerSO.data.lastItem = currentItem;
			playerSO.data.file = configArray["file"];
			playerSO.data.id = fileArray[0]["id"];
			playerSO.data.fsreturnpage = configArray["fsreturnpage"];
			playerSO.flush();
			getURL(unescape(configArray["fullscreenpage"]),configArray["linktarget"]);
		}
	};


}
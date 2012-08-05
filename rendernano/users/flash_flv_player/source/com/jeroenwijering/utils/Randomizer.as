/**
* Pick random indexes out of an array, without having the same index picked multiple times.
*
* @example 
* import com.jeroenwijering.utils.Randomizer;
* var myRandomizer = new Randomizer(myArray);
* var myRandomIndex = myRandomizer.pick();
* 
* @author	Jeroen Wijering
* @version	1.1
**/


class com.jeroenwijering.utils.Randomizer {


	/** a reference of the original array **/
	private var originalArray:Array;
	/** a copy of the original array **/
	private var bufferArray:Array;


	/**
	 * Constructor.
	 *
	 * @param  arr the array to pick random items from
	 */
	public function Randomizer(arr:Array) {
		originalArray = arr;
		bufferArray = new Array();
	};


	/**
	* Randomly pick an index from the array given.
	*
	* @return     The index that is randomly picked.
	**/
	public function pick():Number {
		if(bufferArray.length == 0) {
			for(var k=0; k<originalArray.length; k++) {
				bufferArray.push(k);
			}
		}
		var ran:Number = random(bufferArray.length);
		var idx:Number = bufferArray[ran];
		bufferArray.splice(ran,1);
		return idx;
	};


}
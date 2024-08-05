/**
* MochiServices
* Class that provides API access to MochiAds Scores Service
* @author Mochi Media
* @version 1.3
*/

package mochi;

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.text.TextField;
	
import mochi.MochiServices;

class MochiScores {

	public static function onClose (?args:Dynamic):Void {	
		if (args != null) {
			if (args.error != null) {
				if (args.error == true) {
					if (onErrorHandler != null) {
						if (args.errorCode == null) args.errorCode = "IOError";
						onErrorHandler(args.errorCode);
						MochiServices.doClose();
						return;
					}
				}
			}
		}	
		onCloseHandler();
		MochiServices.doClose();
	}
		
	public static var onCloseHandler:Dynamic;
	public static var onErrorHandler:Dynamic;
	private static var boardID:String;
		
	/**
	 * Method: setBoardID
	 * Sets the name of the mode to use for categorizing submitted and displayed scores.  The board ID is assigned in the online interface.
	 * @param 	boardID: The unique string name of the mode
	 */
	public static function setBoardID (boardID:String):Void { MochiScores.boardID = boardID; MochiServices.send("scores_setBoardID", { boardID: boardID } ); }
		

	/**
	 * Method: showLeaderBoard
	 * Displays the leaderboard GUI showing the current top scores.  The callback event is triggered when the leaderboard is closed.
	 * @param	options object containing variables representing the changeable parameters <see: GUI Options>
	 */
	public static function showLeaderboard (?options:Dynamic):Void { 
		
		if (options != null) {
			
			if (options.clip != null) {
				if (Std.is(options.clip,Sprite)) MochiServices.setContainer(options.clip);
				Reflect.deleteField(options,"clip");
			} else {
				MochiServices.setContainer();
			}
				
			MochiServices.stayOnTop();
				
			if (options.name != null) {
				if (Std.is(options.name,TextField)) {
					if (options.name.text.length > 0) {
						options.name = options.name.text;
					}
				}
			}
				
			if (options.score != null) {
				if (Std.is(options.score,TextField)) {
					if (options.score.text.length > 0) {
						options.score = options.score.text;
					}
				}
			}	
				
			if (options.onDisplay != null) {
				options.onDisplay();
			} else {
				if (MochiServices.getClip() != null) {
					if (Std.is(MochiServices.getClip(),MovieClip)) {
						MochiServices.getClip().stop();
					} else {
						trace("Warning: Container is not a MovieClip, cannot call default onDisplay.");
					}
				}
			}
		} else {
			options = { };
			if (Std.is(MochiServices.getClip(),MovieClip)) {
				MochiServices.getClip().stop();
			} else {
				trace("Warning: Container is not a MovieClip, cannot call default onDisplay.");
			}
		}
			
		if (options.onClose != null) {
			onCloseHandler = options.onClose;
		} else {
			onCloseHandler = function ():Void { 
				if (Std.is(MochiServices.getClip(),MovieClip)) {
					MochiServices.getClip().play(); 
				} else {
					trace("Warning: Container is not a MovieClip, cannot call default onClose.");
				}
			}
		}
				
		if (options.onError != null) {
			onErrorHandler = options.onError;
		} else {
			onErrorHandler = null;
		}
			
		if (options.boardID == null) {
			if (MochiScores.boardID != null) {
				options.boardID = MochiScores.boardID;
			}
		}
			
		MochiServices.send("scores_showLeaderboard", { options: options }, null, onClose ); 
			
	}
		
	/**
	 * Method: closeLeaderboard
	 * Closes the leaderboard immediately
	 */
	public static function closeLeaderboard ():Void { MochiServices.send("scores_closeLeaderboard"); }
			
		
	/**
	 * Method: getPlayerInfo
	 * Retrieves all persistent player data that has been saved in a SharedObject. Will send to the callback an object containing key->value pairs contained in the player cookie.
	 */
	public static function getPlayerInfo (callbackObj:Dynamic, ?callbackMethod:Dynamic ):Void { MochiServices.send("scores_getPlayerInfo", null, callbackObj, callbackMethod); }
		
		
	/**
	 * Method: submit
	 * Submits a score to the server using the current id and mode.
	 * @param	name - the string name of the user as entered or defined by MochiBridge.
	 * @param	score - the number representing a score.  Can be an integer or float.  If the score is time, send it in seconds - can be float
	 * @param 	callbackObj - the object or class instance containing the callback method
	 * @param 	callbackMethod - the string name of the method to call when the score has been sent
	 */
	public static function submit (score:Float, name:String, ?callbackObj:Dynamic, ?callbackMethod:Dynamic ):Void { MochiServices.send("scores_submit", {score: score, name: name}, callbackObj, callbackMethod); }

		
	/**
	 * Method: requestList
	 * Requests a listing from the server using the current game id and mode. Returns an array of at most 50 score objects. Will send to the callback an array of objects [{name, score, timestamp}, ...]
	 * @param	callbackObj the object or class instance containing the callback method
	 * @param	callbackMethod the string name of the method to call when the score has been sent. default: "onLoad"
	 */
	public static function requestList (callbackObj:Dynamic, ?callbackMethod:Dynamic ):Void { MochiServices.send("scores_requestList", null, callbackObj, callbackMethod); }
		
		
	/**
	 * Method: scoresArrayToObjects
	 * Converts the cols/rows array format retrieved from the server into an array of objects - one object for each row containing key-value pairs.
	 * @param	scores the scores object received from the server
	 * @return
	 */
	 /*
	public static function scoresArrayToObjects (scores:Dynamic):Dynamic {
			
		var so:Object = { };
		var i:Number;
		var j:Number;
		var o:Object;
		var row_obj:Object;
			
		for (var item:String in scores) {
			
			if (typeof(scores[item]) == "object") {
					
				if (scores[item].cols != null && scores[item].rows != null) {
						
					so[item] = [ ];
						
					o = scores[item];
						
					for (j = 0; j < o.rows.length; j++) {
						row_obj = { };
						for (i = 0; i < o.cols.length; i++) {
							row_obj[o.cols[i]] = o.rows[j][i];
						}
						so[item].push(row_obj);
					}
					
				} else {
						
					so[item] = { };
					for (var param:String in scores[item]) {
						so[item][param] = scores[item][param];
					}
					
				}
					
			} else {
					
				so[item] = scores[item];
					
			}
				
		}
			
		return so;
			
	}
	*/	
		
}
/**
* MochiServices
* Connection class for all MochiAds Remote Services
* @author Mochi Media
* @version 1.3
*/

package mochi;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.display.MovieClip;
import flash.events.StatusEvent;
import flash.events.TimerEvent;
import flash.system.Security;
import flash.display.Loader;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
import flash.net.LocalConnection;
import haxe.Timer;
//import flash.utils.getTimer;
	
class MochiServices {

	private static var _id(getId,null):String;
	private static var _container(getClip,null):Dynamic;
	private static var _clip(getChildClip,null):Dynamic;
	private static var _loader:Loader;
	private static var _timer:Timer;
	private static var _startTime:Float;
	private static var _gatewayURL:String = "http://www.mochiads.com/static/lib/services/services.swf";
	private static var _swfVersion:String;
		
	private static var _listenChannel:LocalConnection;
	private static var _listenChannelName:String = "__mochiservices";
	private static var _sendChannel:LocalConnection;
	private static var _sendChannelName:String;
	private static var _rcvChannel:LocalConnection;
	private static var _rcvChannelName:String;
		
	private static var _connecting:Bool = false;
	private static var _connected:Bool = false;
		
	public static var onError:Dynamic;
		
	//
	public static function getId ():String {
		return _id;
	}
		
	//
	public static function getClip ():Dynamic {
		return _container;
	}
		
	//
	public static function getChildClip ():Dynamic {
		return _clip;
	}

	//
	//
	public static function getVersion():String {
		return "1.2";
	}
		
	//
	//
    public static function allowDomains(server:String):String {

        flash.system.Security.allowDomain("*");
        flash.system.Security.allowInsecureDomain("*");
			
		if (server.indexOf("http://") != -1) {
			var hostname:String = server.split("/")[2].split(":")[0];
			flash.system.Security.allowDomain(hostname);
			flash.system.Security.allowInsecureDomain(hostname);
			return hostname;
		}
            
        return server;
    }
		
	//
	//
    public static function isNetworkAvailable():Bool {
        return Security.sandboxType != "localWithFile";
    }
		
	//
	public static function setComChannelName(val:String):Void {
		if (val != null) {
			if (val.length > 3) {
				_sendChannelName = val + "_fromgame";
				_rcvChannelName = val;
				initComChannels();
			}
		}
	}
		
	//
	public static function getConnected ():Bool {
		return _connected;
	}
		
	/**
	 * Method: connect
	 * Connects your game to the MochiServices API
	 * @param	id the MochiAds ID of your game
	 * @param	clip the MovieClip in which to load the API (optional for all but AS3, defaults to _root)
	 * @param	onError a function to call upon connection or IO error
	 */
	public static function connect (id:String, clip:Dynamic, ?onError:Dynamic):Void {
		if (Std.is(clip,DisplayObject)) {
			if (!_connected && _clip == null) {
				trace("MochiServices Connecting...");
				_connecting = true;
				init(id, clip);	
			}
		} else {
			trace("Error, MochiServices requires a Sprite, Movieclip or instance of the stage.");
		}
		if (onError != null) {
			MochiServices.onError = onError;
		} else if (MochiServices.onError == null) {
			MochiServices.onError = function (errorCode:String):Void { trace(errorCode); }
		}
	}
	
	public static function disconnect ():Void {
		if (_connected || _connecting) {
			if (_clip != null) {
				if (_clip.parent != null) {
					if (Std.is(_clip.parent,Sprite)) {
						_clip.parent.removeChild(_clip);
						_clip = null;
					}
				}
			}
			_connecting = _connected = false;
			flush(true);
			try {
				_listenChannel.close();
				_rcvChannel.close();
			} catch (error:Dynamic) { }
		}
		if (_timer != null) {
			try {
				_timer.stop();
			} catch (error:Dynamic) { }
		}
	}
		
    public static function createEmptyMovieClip(parent:Dynamic, name:String, depth:Int, ?doAdd:Bool ):MovieClip {
        var mc:MovieClip = new MovieClip();
		if (doAdd == null || doAdd == true ) {
			if (false && depth>0) {
				parent.addChildAt(mc, depth);
			} else {
				parent.addChild(mc);
			}
		}
        Reflect.setField(parent,name,mc);
        Reflect.setField(mc,"_name",name);
        return mc;
    }
		
	public static function stayOnTop ():Void {
		_container.addEventListener(Event.ENTER_FRAME, MochiServices.bringToTop, false, 0, true);
		if (_clip != null) { _clip.visible = true; }
	}
		
		
	public static function doClose ():Void {
		_container.removeEventListener(Event.ENTER_FRAME, MochiServices.bringToTop);
		if (_clip.parent != null) {
			_clip.parent.removeChild(_clip);
		}
	}
		
		
	public static function bringToTop (e:Event):Void {
		if (MochiServices.getClip() != null) {
			if (MochiServices.getChildClip() != null) {
				try {
					if (MochiServices.getClip().numChildren > 1) {
						MochiServices.getClip().setChildIndex(MochiServices.getChildClip(), MochiServices.getClip().numChildren - 1);
					}
				} catch (errorObject:Dynamic) {
					trace("Warning: Depth sort error.");
					_container.removeEventListener(Event.ENTER_FRAME, MochiServices.bringToTop);
				}
			}
		}
	}
		
	//
	//
	private static function init (id:String, clip:Dynamic):Void {
		_id = id;
		if (clip != null) {
			_container = clip;
			loadCommunicator(id, _container);
		}
		
	}
		
	//
	//
	public static function setContainer ( ?container:Dynamic, ?doAdd:Bool ):Void {
			
		if (container != null) {
			if (Std.is(container,Sprite)) _container = container;
		}
			
		if ( doAdd == null || doAdd == true ) {
			if (Std.is(_container,Sprite)) {
				_container.addChild(_clip);
			}
		}
			
	}
		
		
	//
	//
	private static function loadCommunicator (id:String, clip:Dynamic):MovieClip {
				
		var clipname:String = '_mochiservices_com_' + id;
			
		if (_clip != null) {
			return _clip;
		}
			
		if (!MochiServices.isNetworkAvailable()) {
			return null;
		}
			
		MochiServices.allowDomains(_gatewayURL);
			
		_clip = createEmptyMovieClip(clip, clipname, 10336, false);
			 
		// load com swf into container

		_loader = new Loader();
		_timer = new haxe.Timer(10000);
		_timer.run = connectWait;
			
        var f:Dynamic->Void = function (ev:Dynamic):Void { 
			_clip._mochiad_ctr_failed = true;
			trace("MochiServices could not load.");
			MochiServices.disconnect();
			MochiServices.onError("IOError");
		}
			
		_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, f);
			 
		var req:URLRequest = new URLRequest(_gatewayURL);
        _loader.load(req);
			
        _clip.addChild(_loader);
		_clip._mochiservices_com = _loader;

		// init send channel
		_sendChannel = new LocalConnection();
		_clip._queue = [];
			
		// init rcv channel
		_rcvChannel = new LocalConnection();
        _rcvChannel.allowDomain("*", "localhost");
        _rcvChannel.allowInsecureDomain("*", "localhost");
		_rcvChannel.client = _clip;
		_clip._nextcallbackID = 0;
		_clip._callbacks = { dummy: 0 };
		listen();
		return _clip;
	}
		
	//
	//
	public static function connectWait ():Void { 
		if (!_connected) {
			_clip._mochiad_ctr_failed = true;
			trace("MochiServices could not load.");
			MochiServices.disconnect();
			MochiServices.onError("IOError");
		}
		_timer.run = function() { };
	}

	//
	//
	private static function onStatus (event:StatusEvent):Void {
		switch (event.level) {	
			case 'error' :
				_connected = false;
				_listenChannel.connect(_listenChannelName);
		}
	}
		
	//
	//
	private static function listen ():Void {
		_listenChannel = new LocalConnection();
		_listenChannel.client = _clip;
		_clip.handshake = function (args:Dynamic):Void { MochiServices.setComChannelName( args.newChannel ); }
		_listenChannel.allowDomain("*", "localhost");
		_listenChannel.allowInsecureDomain("*", "localhost");
		_listenChannel.connect(_listenChannelName);
		trace("Waiting for MochiAds services to connect...");
	}
		
	//
	//
	private static function initComChannels ():Void {	
		if (!_connected) {	
			_sendChannel.addEventListener(StatusEvent.STATUS, MochiServices.onStatus);
			_sendChannel.send(_sendChannelName, "onReceive", {methodName: "handshakeDone"});
			_sendChannel.send(_sendChannelName, "onReceive", { methodName: "registerGame", id: _id, clip: _container, version: getVersion() } );
			_rcvChannel.addEventListener(StatusEvent.STATUS, MochiServices.onStatus);
			_clip.onReceive = function (pkg:Dynamic):Void {
				var cb:String = pkg.callbackID;
				var cblst:Dynamic = Reflect.field(_rcvChannel.client._callbacks,cb);
				if (!cblst) return;
				var method:Dynamic = cblst.callbackMethod;
				var obj:Dynamic = cblst.callbackObject;
				if (obj && Std.is(method,String)) {
					if (obj[method] != null) { 
						method = obj[method];
					} else {
						trace("Error: Method  " + method + " does not exist.");
					}
				}
				if (method) {
					try { 
						method.apply(obj, pkg.args); 
					} catch (error:Dynamic) {
						trace("Unable to invoke callback method.");
					}
				} else if (obj != null) {
					try { 
						obj(pkg.args);
					} catch (error:Dynamic) {
						trace("Unable to invoke callback method on object.");
					}
				}
				Reflect.deleteField(_rcvChannel.client._callbacks,cb);
			}
			_clip.onError = function ():Void { MochiServices.onError("IOError"); };
			_rcvChannel.connect(_rcvChannelName);
			trace("connected!");
			_connecting = false;
			_connected = true;
			_listenChannel.close();
			while(_clip._queue.length > 0) {
				_sendChannel.send(_sendChannelName, "onReceive", _clip._queue.shift());
			}
		}	
	}
		
			
	//
	//
	private static function flush (error:Bool):Void {

		var request:Dynamic;
		var cb:Dynamic;
		
		if (_clip != null) {
			if (_clip._queue != null) {
				while (_clip._queue.length > 0) {
					
					request = _clip._queue.shift();
					cb = null;
						
					if (request != null) {
							
						if (request.callbackID != null) cb = _clip._callbacks[request.callbackID];
						Reflect.deleteField( _clip._callbacks, request.callbackID );
						
						if (error && cb != null) {
							handleError(request.args, cb.callbackObject, cb.callbackMethod);
						}
						
					}
						
				}	
			}
		}
			
	}
		
	//
	//
	private static function handleError (args:Dynamic, callbackObject:Dynamic, callbackMethod:Dynamic):Void {
			
		if (args != null) {
			if (args.onError != null) {
				args.onError.apply(null, ["NotConnected"]);
			} 
		}
		
		if (callbackMethod != null) {
				
			args = { };
			args.error = true;
			args.errorCode = "NotConnected";
			
			if (callbackObject != null && Std.is(callbackMethod,String)) {
				try {
					callbackObject[callbackMethod](args);
				} catch (error:Dynamic) { }
			} else if (callbackMethod != null) {
				try {
					callbackMethod.apply(args);
				} catch (error:Dynamic) { }
			}	
			
		}
			
	}
		
	//
	//
	public static function send (methodName:String, ?args:Dynamic, ?callbackObject:Dynamic, ?callbackMethod:Dynamic ):Void {
		if (_connected) {
			_sendChannel.send(_sendChannelName, "onReceive", {methodName: methodName, args: args, callbackID: _clip._nextcallbackID});
		} else if (_clip == null || !_connecting) {
			onError("NotConnected");
			handleError(args, callbackObject, callbackMethod);
			flush(true);
			return;
		} else {
			_clip._queue.push({methodName: methodName, args: args, callbackID: _clip._nextcallbackID});
		}
		if (_clip != null) {
			if (_clip._callbacks != null && _clip._nextcallbackID != null) {
				Reflect.setField(_clip._callbacks,_clip._nextcallbackID,{callbackObject: callbackObject, callbackMethod: callbackMethod});
				_clip._nextcallbackID++;
			}
		}
	}
		
}

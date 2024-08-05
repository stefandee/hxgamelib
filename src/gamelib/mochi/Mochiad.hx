/*
Mochiads.com ActionScript 3 code, version 2.1

Flash movies should be published for Flash 9 or later.

Copyright(C) 2006-2007 Mochi Media, Inc. All rights reserved.
*/

package gamelib.mochi;

import flash.system.Security;
import flash.display.MovieClip;
import flash.display.Loader;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
import flash.net.LocalConnection;
import flash.Lib;
import Type;
import StringTools;

class Mochiad
{
	public static function getVersion(): String{
		return "2.1";
	}

	public static function doOnEnterFrame(mc: Dynamic)
	{
		var f: Dynamic;
		f = function(ev: Dynamic) {
			if(mc.onEnterFrame != null){
				mc.onEnterFrame();
			} else{
				// karg: seems kind of pointless to remove the event listener if there isnt one
        //mc.removeEventListener(Event.ENTER_FRAME, f);
			}
		}
		mc.addEventListener(Event.ENTER_FRAME, f);
	}

	public static function createEmptyMovieClip(parent: Dynamic, name: String, depth: Float): MovieClip
	{
    var mc: MovieClip = new MovieClip();

		try
    {
		if(false){
			parent.addChildAt(mc, depth);
		}else{
			parent.addChild(mc);
		}
		Reflect.setField(parent, name, mc);
		Reflect.setField(mc, "_name", name);
    }
    catch(e : Dynamic)
    {
      trace(e);
    }

		return mc;
	}


	public static function showPreGameAd(options: Dynamic){
		/*
			This function will stop the clip, load the Mochiad in a
			centered position on the clip, and then resume the clip
			after a timeout or when this movie is loaded, whichever
			comes first.

			options:
			An Dynamic with keys and values to pass to the server.
			These options will be passed to Mochiad.load, but the
			following options are unique to showPreGameAd.

			clip is a MovieClip reference to place the ad in.
			clip must be dynamic.

			ad_timeout is the number of milliseconds to wait
			for the ad to start loading (default: 2000).

			ad_timeout is the Float of milliseconds to wait
			for the ad to start loading(default: 2000).

			color is the color of the preloader bar
			as a Float(default: 0xFF8A00)

			background is the inside color of the preloader
			bar as a Float(default: 0xFFFFC9)

			outline is the outline color of the preloader
			bar as a Float(default: 0xD58B3C)

			fadeout_time is the Float of milliseconds to
			fade out the ad upon completion(default: 250).

			ad_started is the function to call when the ad
			has started(may not get called if network down)
			(default: function(){ this.clip.stop() }).

			ad_finished is the function to call when the ad
			has finished or could not load
			(default: function(){ this.clip.play() }).
		*/
		var DEFAULTS: Dynamic = {
			clip: Lib.current,
			ad_timeout: 3000,
			fadeout_time: 250,
			regpt: "o",
			method: "showPreloaderAd",
			color: 0xFF8A00,
			background: 0xFFFFC9,
			outline: 0xD58B3C,
			ad_started: function(){Lib.current.stop();},
			ad_finished: function(){Lib.current.play();}
		};
		options = Mochiad.parseOptions(options, DEFAULTS);

    //trace(options);

		var clip: Dynamic = options.clip;
		var ad_msec: Float = 11000;
		var ad_timeout: Float = options.ad_timeout;
		options.ad_timeout = null;
		var fadeout_time: Float = options.fadeout_time;
		options.fadeout_time = null;

		if(Mochiad.load(options) == null)
    {
      trace("something is wrong");

			options.ad_finished();
			return;
		}

		options.ad_started();

		var mc: Dynamic = clip._mochiad;
		var t = new flash.utils.Timer(100.0, 1);
		mc.onUnload = function(){
			var fn = function(?_){
				options.ad_finished();
			};
			//setTimeout(fn, 100);
			t.addEventListener(flash.events.TimerEvent.TIMER, fn);
			t.start();
		}

		/* Center the clip */
		var wh: Array<Int> = Mochiad.getRes(options, clip);

		var w: Float = wh[0];
		var h: Float = wh[1];
		mc.x = w * 0.5;
		mc.y = h * 0.5;

		var chk: Dynamic = createEmptyMovieClip(mc, "_mochiad_wait", 3);
		chk.x = w * -0.5;
		chk.y = h * -0.5;

		var bar: MovieClip = createEmptyMovieClip(chk, "_mochiad_bar", 4);
		bar.x = 10;
		bar.y = h - 20;

		var bar_color: Float = options.color;
		options.color = null;
		var bar_background: Float = options.background;
		options.background = null;
		var bar_outline: Float = options.outline;
		options.outline = null;

		var backing_mc: MovieClip = createEmptyMovieClip(bar, "_outline", 1);
		var backing: Dynamic = backing_mc.graphics;
		backing.beginFill(bar_background);
		backing.moveTo(0, 0);
		backing.lineTo(w - 20, 0);
		backing.lineTo(w - 20, 10);
		backing.lineTo(0, 10);
		backing.lineTo(0, 0);
		backing.endFill();

		var inside_mc: MovieClip = createEmptyMovieClip(bar, "_inside", 2);
		var inside: Dynamic = inside_mc.graphics;
		inside.beginFill(bar_color);
		inside.moveTo(0, 0);
		inside.lineTo(w - 20, 0);
		inside.lineTo(w - 20, 10);
		inside.lineTo(0, 10);
		inside.lineTo(0, 0);
		inside.endFill();
		inside_mc.scaleX = 0;

		var outline_mc: MovieClip = createEmptyMovieClip(bar, "_outline", 3);
		var outline: Dynamic = outline_mc.graphics;
		outline.lineStyle(0, bar_outline, 100);
		outline.moveTo(0, 0);
		outline.lineTo(w - 20, 0);
		outline.lineTo(w - 20, 10);
		outline.lineTo(0, 10);
		outline.lineTo(0, 0);

		chk.ad_msec = ad_msec;
		chk.ad_timeout = ad_timeout;
		chk.started = Lib.getTimer();
		chk.showing = false;
		chk.last_pcnt = 0.0;
		chk.fadeout_time = fadeout_time;
		chk.fadeFunction = function(){
			var p: Float = 100 *(1 -
				((Lib.getTimer() - chk.fadeout_start) / chk.fadeout_time));

			if(p > 0){
				chk.parent.alpha = p * 0.01;
			} else{
				Mochiad.unload(clip);
				chk.onEnterFrame = null;
			}
		};

		var complete = false;
		var unloaded = false;

		var f = function(e:Event):Void {
			complete = true;
			if(unloaded){
				Mochiad.unload(clip);
			}
		};
		clip.loaderInfo.addEventListener(Event.COMPLETE, f);

		if(Std.is(clip.root, MovieClip)){
			var r:Dynamic = clip.root;
			if (r.framesLoaded >= r.totalFrames)
			complete = true;
		}

		mc.unloadAd = function(){
			unloaded = true;
			if(complete){
				Mochiad.unload(clip);
			}
		}

		mc.adjustProgress = function(msec: Float){
			var _chk: Dynamic = mc._mochiad_wait;
			_chk.server_control = true;
			_chk.started = Lib.getTimer();
			_chk.ad_msec = msec;
		};

		chk.onEnterFrame = function(){
			if(!chk.parent.parent){
				chk.onEnterFrame = null;
				return;
			}
			var _clip: Dynamic = chk.parent.parent.root;
			var ad_clip: Dynamic = chk.parent._mochiad_ctr;
			var elapsed: Float = Lib.getTimer() - chk.started;
			var finished: Bool = false;
			var clip_total: Float = _clip.loaderInfo.bytesTotal;
			var clip_loaded: Float = _clip.loaderInfo.bytesLoaded;
			var clip_pcnt: Float = (100.0 * clip_loaded) / clip_total;
			var ad_pcnt: Float = (100.0 * elapsed) / chk.ad_msec;
			var _inside: Dynamic = chk._mochiad_bar._inside;
			//var pcnt: Float = Math.min(100.0, Math.min((clip_pcnt || 0.0), ad_pcnt)); // what is "clip_pcnt || 0.0"?
			var pcnt: Float = Math.min(100.0, Math.min((clip_pcnt), ad_pcnt));
			pcnt = Math.max(chk.last_pcnt, pcnt);
			chk.last_pcnt = pcnt;
			_inside.scaleX = pcnt * 0.01;

			if(!chk.showing){
				var total: Float = ad_clip.loaderInfo.bytesTotal;
				if(total > 0 || Type.typeof(total) == ValueType.TUnknown){
					chk.showing = true;
					chk.started = Lib.getTimer();
				}else if(elapsed > chk.ad_timeout){
					finished = true;
				}
			}

			if(elapsed > chk.ad_msec || chk.parent._mochiad_ctr_failed){
				finished = true;
			}

			if(complete && finished){
				if(chk.server_control){
					chk.onEnterFrame = null;
				}else{
					chk.fadeout_start = Lib.getTimer();
					chk.onEnterFrame = chk.fadeFunction;
				}
			}
		};
		doOnEnterFrame(chk);

    trace("showing the preloader ads!");
	}

	public static function load(options: Dynamic): MovieClip{
		/*
			Load a Mochiad into the given MovieClip
			
			options:
				An Dynamic with keys and values to pass to the server.
				clip is a MovieClip reference to place the ad in.
				id should be the unique identifier for this Mochiad.
				server is the base URL to the Mochiad server.

				res is the resolution of the container clip or movie
				as a string, e.g. "500x500"

				no_page disables page detection.
		*/

    trace("load - options");

    try
    {

		var DEFAULTS: Dynamic = {
			server: "http://x.mochiads.com/srv/1/",
			method: "load",
			depth: 10333,
			id: "_UNKNOWN_"
		};
		options = Mochiad.parseOptions(options, DEFAULTS);
		// This isn't accessible yet for some reason:
		// options.clip.loaderInfo.swfVersion;
		options.swfv = 9;
		options.mav = Mochiad.getVersion();

		var clip: Dynamic = options.clip;

    trace("load...0 = " + Security.sandboxType);

		if(!(Security.sandboxType != "localWithFile"))
    {
      trace("done!");
			return null;
		}

    trace("load...00");

    if (clip == null)
    {
      trace("clip is null!");

      return null;
    }

		if(clip._mochiad_loaded != null && clip._mochiad_loaded){
			return null;
		}

    trace("load...1");

		var depth: Float = options.depth;
		options.depth = null;
		var mc: Dynamic = createEmptyMovieClip(clip, "_mochiad", depth);

		var wh: Array<Int> = Mochiad.getRes(options, clip);
		options.res = wh[0] + "x" + wh[1];

    trace("load...2 " + options.res);

		options.server += options.id;
		options.id = null;

		clip._mochiad_loaded = true;
		
    trace("load...3");

		// karg: seems that this code is filling in the swf url :)
    try
    {
      if (clip.loaderInfo.loaderURL.indexOf("http") == 0) 
      {
           
        options.as3_swf = clip.loaderInfo.loaderURL;
       
      }
    }
    catch(e : Dynamic)
    {
      trace(e);
    }

    trace("load...4..." + options.as3_swf);

		var lv: Dynamic = new URLVariables();
		for(k in Reflect.fields(options)){
			var v: Dynamic = Reflect.field(options,k);
			if(!(Reflect.isFunction(v))){
				Reflect.setField(lv,k,v);
			}
		}

		// karg: commented atm until i figure out if it's useful
    /*
		if(clip.loaderInfo.loaderURL.indexOf("http") != 0){
			options.no_page = true;
		}
    */
  	options.no_page = false;

		var server: String = lv.server;
		lv.server = null;
		var hostname: String = allowDomains(server);

		mc.onEnterFrame = function(){
			if(!mc._mochiad_ctr){
				mc.onEnterFrame = null;
				Mochiad.unload(mc.parent);
			};
		};
		doOnEnterFrame(mc);

		//var lc: LocalConnection = new LocalConnection();
		var lc:Dynamic = new LocalConnection();
		lc.client = mc;
		var name: String = [
			"", Math.floor((Date.now()).getTime()), Math.floor(Math.random() * 999999)
		].join("_");
		lc.allowDomain("*", "localhost");
		lc.allowInsecureDomain("*", "localhost");
		lc.connect(name);
		mc.lc = lc;
		lv.lc = name;

		lv.st = Lib.getTimer();
		var loader: Loader = new Loader();

		var f: Dynamic = function(ev: Dynamic)
    {
      trace("f - loading failed callback");
			mc._mochiad_ctr_failed = true;
		}
		loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, f);

		var req: URLRequest = new URLRequest(server + ".swf");
		req.contentType = "application/x-www-form-urlencoded";
		req.method = URLRequestMethod.POST;
		req.data = lv;
		var context = new flash.system.LoaderContext(true);
		loader.load(req, context);
		mc.addChild(loader);
		mc._mochiad_ctr = loader;

		trace("load is succesful!");
    return mc;
    }
    catch(e : Dynamic)
    {
      trace(e);
    }

    return null;
	}


	public static function unload(clip: Dynamic): Bool{
		/*
			Unload a Mochiad from the given MovieClip

			clip:
				a MovieClip reference(e.g. this.stage)
		*/
		
		if(clip.clip && clip.clip._mochiad){
			clip = clip.clip;
		}
		if(!clip._mochiad)
		{
			return false;
		}
		if(clip._mochiad.onUnload)
		{
			clip._mochiad.onUnload();
		}
		clip.removeChild(clip._mochiad);
		clip._mochiad_loaded = null;
		clip._mochiad = null;
		return true;
	}

	private static function allowDomains(server: String): String{
		// I believe this whole function is unnecessary, but am keeping it around anyway.
		var hostname: String = server.split("/")[2].split(": ")[0];
		flash.system.Security.allowDomain("*");
		flash.system.Security.allowDomain(hostname);
		flash.system.Security.allowInsecureDomain("*");
		flash.system.Security.allowInsecureDomain(hostname);
		return hostname;
	}

	private static function getRes(options: Dynamic, clip: Dynamic): Array<Int>{
		var b: Dynamic = clip.getBounds(clip.root);
		var w: Int = 0;
		var h: Int = 0;
		if(Type.typeof(options.res) != ValueType.TUnknown){
			var xy: Array<Dynamic> = options.res.split("x");
			w = Std.parseInt(xy[0]);
			h = Std.parseInt(xy[1]);
		} else{
			w = Std.int(b.xMax - b.xMin);
			h = Std.int(b.yMax - b.yMin);
		}
		if(w == 0 || h == 0)
		{
			w = clip.stage.stageWidth;
			h = clip.stage.stageHeight;
		}

		return [w, h];
	}

	public static function parseOptions(options: Dynamic, defaults: Dynamic): Dynamic
	{
		var optcopy = {};//Reflect.empty();
		var k: String;
		for(k in Reflect.fields(defaults))
		{
			Reflect.setField(optcopy,k,Reflect.field(defaults,k));
		}
		if(options)
		{
			for(k in Reflect.fields(options))
			{
				Reflect.setField(optcopy,k,Reflect.field(options,k));
			}
		}
		options = Reflect.field(optcopy,"clip.loaderInfo.parameters.mochiad_options");
		if(options)
		{
			var pairs: Array<String> = options.split("&");
			for(i in 0...pairs.length)
			{
				var kv: Array<String> = pairs[i].split("=");
				Reflect.setField(optcopy,StringTools.htmlUnescape(kv[0]),StringTools.htmlUnescape(kv[1]));
			}
		}
		return optcopy;
	}

	public static function showPreloaderAd(options:Dynamic):Void {
		/* Compatibility stub for MochiAd 1.5 terminology */
		Mochiad.showPreGameAd(options);
	}

	public static function showTimedAd(options:Dynamic):Void {
		/* Compatibility stub for MochiAd 1.5 terminology */
		Mochiad.showInterLevelAd(options);
	}

	public static function showInterLevelAd(options: Dynamic){
		/*
			This function will stop the clip, load the Mochiad in a
			centered position on the clip, and then resume the clip
			after a timeout.

			options:
				An object with keys and values to pass to the server.
				These options will be passed to Mochiad.load, but the
				following options are unique to showInterLevelAd.

				clip is a MovieClip reference to place the ad in.

				ad_timeout is the number of milliseconds to wait
				for the ad to start loading (default: 2000).

				ad_timeout is the number of milliseconds to wait
				for the ad to start loading(default: 2000).

				fadeout_time is the number of milliseconds to
				fade out the ad upon completion(default: 250).
		*/

		var DEFAULTS ={
			ad_timeout: 2000,
			fadeout_time: 250,
			regpt: "o",
			method: "showTimedAd",
			ad_started: function(){untyped{this.clip.stop();} },
			ad_finished: function(){untyped{this.clip.play();} }
		};

		options = Mochiad.parseOptions(options, DEFAULTS);

		var clip = options.clip;
		var ad_msec = 4000;/*11000;*/
		var ad_timeout = options.ad_timeout;
		Reflect.deleteField(options,"ad_timeout");
		var fadeout_time = options.fadeout_time;
		Reflect.deleteField(options,"fadeout_time");

    trace("...0!");

		if(Mochiad.load(options)==null)
    {
      trace("load failed!");

			options.ad_finished();
			return;
		}

    trace("...1!");
		options.ad_started();
    trace("ad_started!");

		var mc = clip._mochiad;
		Reflect.setField(mc,"onUnload", function(){
			options.ad_finished();
		});


		/* Center the clip */
		var wh = Mochiad.getRes(options, clip);
		var w = wh[0];
		var h = wh[1];
		mc.x = w * 0.5;
		mc.y = h * 0.5;

    trace("...2!");

		var chk:Dynamic = createEmptyMovieClip(mc, "_mochiad_wait", 3);

    try
    {
    trace("...3!");

		chk.ad_msec = ad_msec;
		chk.ad_timeout = ad_timeout;
		chk.started = Lib.getTimer();
		chk.showing = false;
		chk.fadeout_time = fadeout_time;
		chk.fadeFunction = function(){
			var p = 100 * (1 -
				((Lib.getTimer() - chk.fadeout_start) / chk.fadeout_time));
			if(p > 0){
				chk.parent.alpha = p * 0.01;
			} else{
				Mochiad.unload(clip);
				chk.onEnterFrame = null;
			}
		};

		mc.unloadAd = function(){
			Mochiad.unload(clip);
		}

		mc.adjustProgress = function(msec: Float){
			var _chk = mc._mochiad_wait;
			_chk.server_control = true;
			_chk.started = Lib.getTimer();
			_chk.ad_msec = msec - 250;
		};

		chk.onEnterFrame = function(){
			var ad_clip = chk.parent._mochiad_ctr;
			var elapsed = Lib.getTimer() - chk.started;
			var finished = false;
			if(!chk.showing){
				var total = ad_clip.loaderInfo.bytesTotal;
				if(total > 0 || Type.typeof(total) == ValueType.TUnknown){
					chk.showing = true;
					chk.started = Lib.getTimer();
				}else if(elapsed > chk.ad_timeout){
					finished = true;
				}
			}
			if(elapsed > chk.ad_msec || chk.parent._mochiad_ctr_failed){
				finished = true;
			}
			if(finished){
				if(chk.server_control){
					chk.onEnterFrame = null;
				} else{
					chk.fadeout_start = Lib.getTimer();
					chk.onEnterFrame = chk.fadeFunction;
				}
			}
		};

		doOnEnterFrame(chk);
    }
    catch(e : Dynamic)
    {
      trace(e);
    }
	}	

//public static function fetchHighScores(options: Dynamic, callbackObj: Dynamic, ?callbackMethod: Dynamic): Bool{
/*
Fetch the high scores from Mochiads. Returns false if a connection
to Mochiads can not be established due to the security sandbox.

options:
An object with keys and and values to pass to the
server.

clip is a MovieClip reference to place the(invisible)
communicator in.

id should be the unique identifier for this Mochiad.

callback(scores):

scores is an array of at most 50 high scores, highest score
first, with a millisecond epoch timestamp(for the Date
constructor). [[name, score, timestamp], ...]
*/
/* var lc: Dynamic = Mochiad._loadCommunicator({clip: options.clip, id: options.id});
if(!lc){
return false;
}

lc.doSend(['fetchHighScores', options], callbackObj, callbackMethod);
return true;
}*/


//public static function sendHighScore(options: Dynamic, callbackObj: Dynamic, ?callbackMethod: Dynamic): Bool{
/*
Send a high score to Mochiads. Returns false if a connection
to Mochiads can not be established due to the security sandbox.

options:
An object with keys and and values to pass to the
server.

clip is a MovieClip reference to place the(invisible)
communicator in.

id should be the unique identifier for this Mochiad.

name is the name to be associated with the high score, e.g.
"Player Name"

score is the value of the high score, e.g. 100000.

callback(scores, index):

scores is an array of at most 50 high scores, highest score
first, with a millisecond epoch timestamp(for the Date
constructor). [[name, score, timestamp], ...]

index is the array index of the submitted high score in
scores, or -1 if the submitted score did not rank top 50.
*/
/*var lc: Dynamic = Mochiad._loadCommunicator({clip: options.clip, id: options.id});
if(!lc){
return false;
}

lc.doSend(['sendHighScore', options], callbackObj, callbackMethod);
return true;
}*/

/*public static function _loadCommunicator(options: Dynamic): Dynamic{
var DEFAULTS ={
com_server: "http://x.mochiads.com/com/1/",
method: "loadCommunicator",
depth: 10337,
id: "_UNKNOWN_"
};
options = Mochiad.parseOptions(options, DEFAULTS);
options.swfv = 9;
options.mav = Mochiad.getVersion();

var clip = options.clip;
var clipname: String = '_mochiad_com_' + options.id;

if(!(Security.sandboxType != "localWithFile")){
return null;
}

if(Reflect.hasField(clip,clipname)){
return clip.clipname;
}

var server: String = options.com_server + options.id;
Mochiad.allowDomains(server);
Reflect.deleteField(options,"id");
Reflect.deleteField(options,"com_server");

var depth = options.depth;
Reflect.deleteField(options,"depth");
var mc: MovieClip = createEmptyMovieClip(clip, clipname, depth);
var lv: URLVariables = new URLVariables();
for(k in Reflect.fields(options)){
Reflect.setField(lv,k, Reflect.field(options,k));
}

var lc: LocalConnection = new LocalConnection();
lc.client = mc;
var name: String = [
"", Math.floor((Date.now()).getTime()), Math.floor(Math.random() * 999999)
].join("_");
lc.allowDomain("*", "localhost");
lc.allowInsecureDomain("*", "localhost");
lc.connect(name);

#if flash9

untyped
{
mc.name = name;
mc.lc = lc;
lv.lc = name;
mc._id = 0;
mc._queue = [];
mc.rpcResult = function(cb: Dynamic){

// __arguments__ is "magic" and may change in later versions of haxe
// __typeof__ is also "magic"
untyped
{
cb = Std.parseInt(cb.toString());
var cblst: Array<Dynamic> = mc._callbacks[cb];
if(__typeof__(cblst) == "undefined"){
return;
}
Reflect.deleteField(mc._callbacks,cb);
var args: Array<Dynamic> = [];
for(i in 2...cblst.length){
args.push(cblst[i]);
}
for(i in 1...__arguments__.length){
args.push(__arguments__[i]);
}
var method : Dynamic = cblst[1];
var obj : Dynamic = cblst[0];
if(obj && __typeof__(method) == "string"){
method = obj[method];
}
if(__typeof__(method) == "function"){
method.apply(obj, args);
}
}
}
mc._didConnect = function(endpoint: String){
Lib.eval("
mc._endpoint = endpoint;
var q: Array = mc._queue;
delete mc._queue;
var ds: Function = mc.doSend;
for(var i: Number = 0; i < q.length; i++){
var item: Array = q[i];
ds.apply(this, item);
}
");
}
mc.doSend = function(args: Array<Dynamic>, cbobj: Dynamic, cbfn: Dynamic){
Lib.eval("
if(mc._endpoint == null){
var qargs: Array = [];
for(var i: Number = 0; i < arguments.length; i++){
qargs.push(arguments[i]);
}
mc._queue.push(qargs);
return;
}
mc._id += 1;
var id: Number = mc._id;
mc._callbacks[id] = [cbobj, cbfn || cbobj];
var slc: LocalConnection = new LocalConnection();
slc.send(mc._endpoint, 'rpc', id, args);
");
}
#end
}

untyped
{

mc._callbacks = Reflect.empty();
mc._callbacks[0] = [mc, '_didConnect'];

lv.st = Lib.getTimer();
var req: URLRequest = new URLRequest(server + ".swf");
req.contentType = "application/x-www-form-urlencoded";
req.method = URLRequestMethod.POST;
req.data = lv;
var loader: Loader = new Loader();
loader.load(req);
mc.addChild(loader);
mc._mochiad_com = loader;
}

return mc;

}*/

}


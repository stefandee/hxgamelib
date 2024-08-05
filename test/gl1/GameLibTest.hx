// as3.0
import flash.display.Sprite;
import flash.events.Event;

// app
import data.StringPackages;
import data.AllStrings;
import Data;
import GLStringManager;
import gamelib.sentry.SentrySprite;
import gamelib.sentry.SentrySpriteTemplate;

class GameLibTest
{
  // may also be a MovieClip, but... 
  var AppRoot  : Sprite;
  var StrMgr   : GLStringManager;

  public function new ()
  {
    // seems to cause freezes on certain firefox versions/configurations
    #if debug
    if( haxe.Firebug.detect() )
    {
      haxe.Firebug.redirectTraces();
    }
    #end
    
    AppRoot = new Sprite();
    
    flash.Lib.current.addChild(AppRoot);

    AppRoot.stage.frameRate = 25;

    AppRoot.stage.stageFocusRect = false;
    
    // TODO: seems that setting these doesnt have any effect
    AppRoot.stage.stageWidth = 480;
    AppRoot.stage.stageHeight = 480;
    
    AppRoot.addEventListener(Event.ENTER_FRAME, OnEnterFrame);

    //
    // String Manager test
    //
    StrMgr = new GLStringManager();
    trace(StrMgr.GetString(StringPackages.AllStrings, AllStrings.kStringID_AskDataOverwrite));

    StrMgr.Lang = Language_RO;
    trace(StrMgr.GetString(StringPackages.AllStrings, AllStrings.kStringID_AskDataOverwrite));

    var sprTmpl : SentrySpriteTemplate = new SentrySpriteTemplate();
    sprTmpl.Init(new SpriteData_Spee());

    var spr : SentrySprite;

    try
    {
      spr = new SentrySprite(sprTmpl);
    }
    catch(e : Dynamic)
    {
      trace(e);
    }

    AppRoot.addChild(spr);

    spr.EnableEvents(true);
  
    //AppRoot.addChild(new flash.display.Bitmap(sprTmpl.modules[2].bitmapData));

    spr.x = 240;
    spr.y = 240;
  }

  private function OnEnterFrame(e : Event)
  {
  }

  public static function main ()
  {
    new GameLibTest();
  }
}
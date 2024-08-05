package gamelib.sentry;

// as3.0
import flash.display.MovieClip;
import flash.display.DisplayObjectContainer;
import flash.events.Event;

// app
import gamelib.sentry.SentrySpriteTemplate;

class SentryModule extends flash.display.Bitmap
{
  private var moduleTemplate : SentryModuleTemplate;

  public function new(moduleTemplate : SentryModuleTemplate)
  {
    super();

    this.moduleTemplate = moduleTemplate;

    this.bitmapData = moduleTemplate.bitmapData;

    //trace("SentryModule::new");
  }
}

class SentryAFrame extends flash.display.Sprite
{
  var modules : Array<SentryModule>;

  public function new()
  {
    super();

    modules = new Array();
  }

  public function Init(template : SentrySpriteTemplate, templateAFrame : SentryAFrameTemplate)
  {
    //trace("SentryAFrame::init");

    // clear the display list
    while(numChildren > 0)
    {
      removeChild(getChildAt(0));
    }

    modules = new Array();

    var aFrameMatrix : flash.geom.Matrix = templateAFrame.GetMatrix();

    //trace("SentryAFrame::Init");
    var tempFrames = template.frames[templateAFrame.frameIndex];

    if (tempFrames == null)
    {
      trace("tempFrames is null! " + templateAFrame.frameIndex + "/" + template.frames.length);
      return;
    }

    if (template.frames[templateAFrame.frameIndex].fModules == null)
    {
      trace("TEMPLATE BLAH IS NULL!");
      return;
    }

    for(fModule in template.frames[templateAFrame.frameIndex].fModules)
    {
      var fModuleMatrix : flash.geom.Matrix = fModule.GetMatrix();

      var module : SentryModule = new SentryModule(template.modules[fModule.moduleIndex]);

      //trace("module index: " + fModule.moduleIndex);

      var moduleMatrix : flash.geom.Matrix = new flash.geom.Matrix();

      moduleMatrix.identity();
      moduleMatrix.concat(fModuleMatrix);
      moduleMatrix.concat(aFrameMatrix);

      addChild(module);

      module.transform.matrix = moduleMatrix;

      //module.x = 0;
      //module.y = 0;

      modules.push(module);
    }
  }
}

class SentryAnim
{
  public var aFrames : Array<SentryAFrame>;

  public function new()
  {
    aFrames = new Array();
  }

  public function Init(template : SentrySpriteTemplate, templateAnim : SentryAnimTemplate)
  {
    aFrames = new Array();

    for(aFrameTemplate in templateAnim.aFrames)
    {
      var aFrame : SentryAFrame = new SentryAFrame();

      aFrame.Init(template, aFrameTemplate);

      aFrames.push(aFrame);
    }
  }
}

// 
// This is a flash friendly SentrySprite
//
// All visual data (bitmapdata) is shared through a template (so that we wont duplicate data
// and fill memory)
//
class SentrySprite extends flash.display.Sprite
{
  // used to have the same BitmapData contained in a ModuleTemplate for all sprites,
  // but in a flash-friendly form - that can be operated by a flash DisplayObjectContainer
  public var anims : Array<SentryAnim>;

  // used for frames and anims data
  public var template : SentrySpriteTemplate;

  // anim data
  public var CurrentAnim   (GetCurrentAnim, SetCurrentAnim)     : Int;
  public var CurrentAFrame (GetCurrentAFrame, SetCurrentAFrame) : Int;

  public var loop  : Bool;
  public var animFinished (getAnimFinished, null) : Bool;
  public var pause (default, setPause) : Bool;

  private var TimeStamp : Float;

  public function new(tmpl : SentrySpriteTemplate)
  {
    //trace("SentrySprite::new");

    super();

    this.template = tmpl;

    anims = new Array();

    for(animTemplate in template.anims)
    {
      var anim : SentryAnim = new SentryAnim();

      anim.Init(template, animTemplate);

      anims.push(anim);
    }

    CurrentAnim = 0;

    loop = true;

    TimeStamp = gamelib.Clock.instance.simTime;//Date.now().getTime();
  }

  private function GetCurrentAnim() : Int
  {
    return CurrentAnim;
  }

  private function SetCurrentAnim(anim : Int) : Int
  {
    if (anim < 0 || anim > template.anims.length)
    {
      return CurrentAnim;
    }

    CurrentAnim   = anim;
    CurrentAFrame = 0;

    return CurrentAnim;
  }

  private function GetCurrentAFrame() : Int
  {
    return CurrentAFrame;
  }

  private function SetCurrentAFrame(aFrameIndex : Int) : Int
  {
    //trace("SetCurrentAFrame: " + aFrameIndex);

    // TODO: alias the template.anims[CurrentAnim] here or in setter for anim
    if (aFrameIndex < 0 || aFrameIndex >= template.anims[CurrentAnim].aFrames.length)
    {
      //trace("invalid aframe!");
      return CurrentAFrame;
    }

    CurrentAFrame = aFrameIndex;
    TimeStamp     = gamelib.Clock.instance.simTime;//Date.now().getTime();

    // TODO: rebuild the display list

    // first, clear the display list
    while(numChildren > 0)
    {
      removeChild(getChildAt(0));
    }

    // build the new display list
    // dont even bother to ask about the redirections :)
    addChild(anims[CurrentAnim].aFrames[CurrentAFrame]);

    return CurrentAFrame;
  }

  public function update()
  {
    if (pause)
    {
      return;
    }
    
    if (gamelib.Clock.instance.simTime/*Date.now().getTime()*/ - TimeStamp > template.anims[CurrentAnim].aFrames[CurrentAFrame].time)
    {
      // to avoid strange problems
      if ((CurrentAFrame + 1) >= template.anims[CurrentAnim].aFrames.length)
      {
        if (loop)
        {
          CurrentAFrame = 0;
        }
      }
      else
      {
        CurrentAFrame++;
      }

#if (ImprovedAnimFinished)
      if (loop)
      {
        TimeStamp = gamelib.Clock.instance.simTime;//Date.now().getTime();
      }
#else
        TimeStamp = gamelib.Clock.instance.simTime;//Date.now().getTime();
#end

    }
  }

  public function GetAFramesCount(anim : Int) : Int
  {
    if (anim < 0 || anim > template.anims.length)
    {
      return -1;
    }

    return template.anims[anim].aFrames.length;
  }

  public function clone() : SentrySprite
  {
    var sprite : SentrySprite = new SentrySprite(template);

    sprite.loop = this.loop;
    sprite.CurrentAnim = this.CurrentAnim;

    return sprite;
  }

  public function setPause(v : Bool) : Bool
  {
    //trace("SentrySprite::pause - not implemented!");

    pause = v;

    // TODO: set a timeStampPause, so that we keep the timing difference
    if (!pause)
    {
      TimeStamp = gamelib.Clock.instance.simTime;
    }

    return pause;
  }

  private function getAnimFinished() : Bool
  {
    if (loop)
    {
      return false;
    }

#if (ImprovedAnimFinished)
    return ((CurrentAFrame + 1) >= template.anims[CurrentAnim].aFrames.length) && (gamelib.Clock.instance.simTime - TimeStamp > template.anims[CurrentAnim].aFrames[CurrentAFrame].time);
#else
    return ((CurrentAFrame + 1) >= template.anims[CurrentAnim].aFrames.length);
#end
  }

  public function getFLogicItemAsPoint(animIndex : Int, aFrameIndex : Int, fLogicIndex : Int, fLogicItemIndex : Int) : flash.geom.Point
  {
    if (template == null)
    {
      trace("getFLogicItemAsPoint - template is null.");
      return null;
    }

    if (template.anims.length <= animIndex)
    {
      return null;
    }

    var animTmpl = template.anims[animIndex];

    if (animTmpl.aFrames.length <= aFrameIndex)
    {
      return null;
    }

    var pos : flash.geom.Point = null;
    var frameIndex = animTmpl.aFrames[aFrameIndex].frameIndex;
    var frameTmpl = template.frames[frameIndex];

    if (frameTmpl.fLogics.length > fLogicIndex)
    {
      if (frameTmpl.fLogics[fLogicIndex].items.length > fLogicItemIndex)
      {
        var fLogicItemTmpl = frameTmpl.fLogics[fLogicIndex].items[fLogicItemIndex];

        pos = new flash.geom.Point(fLogicItemTmpl.rect.left, fLogicItemTmpl.rect.top);
      }
    }

    return pos;
  }

  public function getFLogicItemAsRect(animIndex : Int, aFrameIndex : Int, fLogicIndex : Int, fLogicItemIndex : Int) : flash.geom.Rectangle
  {
    if (template == null)
    {
      trace("getFLogicItemAsRe - template is null.");
      return null;
    }

    if (template.anims.length <= animIndex)
    {
      return null;
    }

    var animTmpl = template.anims[animIndex];

    if (animTmpl.aFrames.length <= aFrameIndex)
    {
      return null;
    }

    var rect : flash.geom.Rectangle = null;
    var frameIndex = animTmpl.aFrames[aFrameIndex].frameIndex;
    var frameTmpl = template.frames[frameIndex];

    if (frameTmpl.fLogics.length > fLogicIndex)
    {
      if (frameTmpl.fLogics[fLogicIndex].items.length > fLogicItemIndex)
      {
        var fLogicItemTmpl = frameTmpl.fLogics[fLogicIndex].items[fLogicItemIndex];

        rect = new flash.geom.Rectangle();
        
        rect.left   = fLogicItemTmpl.rect.left;
        rect.top    = fLogicItemTmpl.rect.top;
        rect.right  = fLogicItemTmpl.rect.right;
        rect.bottom = fLogicItemTmpl.rect.bottom;
      }
    }

    return rect;
  }

  public function computeBounds() : flash.geom.Rectangle
  {
    var bounds = new flash.geom.Rectangle();

    bounds.width = 1;
    bounds.height = 1;
    
    for(i in 0...numChildren)
    {
      //trace(getChildAt(i).getBounds(this));

      var childBounds = getChildAt(i).getBounds(this);

      if (childBounds.left < bounds.left)
      {
        bounds.left = childBounds.left;
      }

      if (childBounds.right > bounds.right)
      {
        bounds.right = childBounds.right;
      }

      if (childBounds.top < bounds.top)
      {
        bounds.top = childBounds.top;
      }

      if (childBounds.bottom > bounds.bottom)
      {
        bounds.bottom = childBounds.bottom;
      }

      //bounds.union();
    }

    return bounds;
  }
}
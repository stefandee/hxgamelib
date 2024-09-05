package gamelib.sentry;

// as3.0
import flash.display.MovieClip;
import flash.display.DisplayObjectContainer;
import flash.events.Event;

// app
import gamelib.sentry.SentrySpriteTemplate;

// 
// This is a sprite that can render itself to a Bitmapdata buffer
//
// All visual data (bitmapdata) is shared through a template (so that we wont duplicate data
// and fill memory)
//
class SentrySpriteBuffer
{
  // used for frames and anims data
  public var template : SentrySpriteTemplate;

  // anim data
  public var CurrentAnim   (GetCurrentAnim, SetCurrentAnim)     : Int;
  public var CurrentAFrame (GetCurrentAFrame, SetCurrentAFrame) : Int;

  public var loop  : Bool;
  public var animFinished (getAnimFinished, null) : Bool;
  public var pause (default, setPause) : Bool;

  private var TimeStamp : Float;

  private var cachedMatrix : flash.geom.Matrix;
  private var moduleMatrix : flash.geom.Matrix;

  public function new(tmpl : SentrySpriteTemplate)
  {
    this.template = tmpl;

    CurrentAnim = 0;

    loop = true;

    cachedMatrix = new flash.geom.Matrix();
    moduleMatrix = new flash.geom.Matrix();

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
    // TODO: alias the template.anims[CurrentAnim] here or in setter for anim
    if (aFrameIndex < 0 || aFrameIndex >= template.anims[CurrentAnim].aFrames.length)
    {
      return CurrentAFrame;
    }

    CurrentAFrame = aFrameIndex;
    TimeStamp     = gamelib.Clock.instance.simTime;//Date.now().getTime();

    return CurrentAFrame;
  }

  public function update()
  {
    if (pause)
    {
      return;
    }
    
    if (gamelib.Clock.instance.simTime - TimeStamp > template.anims[CurrentAnim].aFrames[CurrentAFrame].time)
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

  public function clone() : SentrySpriteBuffer
  {
    var sprite : SentrySpriteBuffer = new SentrySpriteBuffer(template);

    sprite.loop = this.loop;
    sprite.CurrentAnim = this.CurrentAnim;

    return sprite;
  }

  public function setPause(v : Bool) : Bool
  {
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

    // TODO: !!
    
    return bounds;
  }

  public function draw(buffer : flash.display.BitmapData, animIndex : Int, aframeIndex : Int, posX : Float, posY : Float, ?scaleX : Float = 1.0, ?scaleY : Float = 1.0)
  {
    var animTmpl   : SentryAnimTemplate   = template.anims[animIndex];
    var aframeTmpl : SentryAFrameTemplate = animTmpl.aFrames[aframeIndex];

    cachedMatrix.identity();

    cachedMatrix.tx = posX;
    cachedMatrix.ty = posY;
    cachedMatrix.a  = scaleX;
    cachedMatrix.d  = scaleY;

    // TODO: cache this matrix or elimiate it directly?
    var aFrameMatrix : flash.geom.Matrix = aframeTmpl.cachedMatrix;//aframeTmpl.GetMatrix();

    var tempFrames = template.frames[aframeTmpl.frameIndex];

    if (tempFrames == null)
    {
      return;
    }

    if (template.frames[aframeTmpl.frameIndex].fModules == null)
    {
      return;
    }

    for(fModule in template.frames[aframeTmpl.frameIndex].fModules)
    {
      var fModuleMatrix : flash.geom.Matrix = fModule.cachedMatrix;//fModule.GetMatrix();

      var moduleTmpl = template.modules[fModule.moduleIndex];

      // prepare the matrix
      moduleMatrix.identity();
      moduleMatrix.concat(fModuleMatrix);
      moduleMatrix.concat(aFrameMatrix);
      moduleMatrix.concat(cachedMatrix);

      // do the actual draw
      buffer.draw(moduleTmpl.bitmapData, moduleMatrix);
    }
  }
}
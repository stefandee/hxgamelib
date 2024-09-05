package gamelib.sentry;

// as3.0
import flash.utils.ByteArray;
import flash.display.BitmapData;

enum TFLogicItemType
{
  FLogicItemType_Point;
  FLogicItemType_Rect;
}

class SentryModuleTemplate
{
  public var bitmapData : BitmapData;
  public var moduleId : Int;

  public function new()
  {
    moduleId = -1;
  }

  public function Init(data : ByteArray) : Bool
  {
    // read the moduleId from the stream
    moduleId = data.readInt();

    // read the width x height
    var width  : Int = data.readInt();
    var height : Int = data.readInt();

    // read the validity byte
    var valid : Int = data.readByte();

    if (valid == 0)
    {
      bitmapData = new BitmapData(width, height, false, 0xFF000000);

      return false;
    }

    bitmapData = new BitmapData(width, height, true);

    var pixelData : ByteArray = new ByteArray();

    data.readBytes(pixelData, 0, width * height * 4);

    bitmapData.setPixels(new flash.geom.Rectangle(0, 0, width, height), pixelData);

    return true;
  }
}

class SentryFModuleTemplate
{
  public var moduleIndex : Int;
  public var pos         : flash.geom.Point;
  public var flags       : Int;

  public var cachedMatrix(default, null) : flash.geom.Matrix;

  public function new()
  {
    cachedMatrix = new flash.geom.Matrix();
  }

  public function Init(data : ByteArray) : Bool
  {
    moduleIndex = data.readInt();

    pos = new flash.geom.Point(data.readInt(), data.readInt());

    flags = data.readInt();

    cachedMatrix.identity();
    cachedMatrix.translate(pos.x, pos.y);

    return true;
  }

  public function GetMatrix() : flash.geom.Matrix
  {
    var matrix : flash.geom.Matrix = new flash.geom.Matrix();

    matrix.translate(pos.x, pos.y);

    // TODO: add the flags to the matrix

    return matrix;
  }
}

class SentryFlogicItemTemplate
{
  public var type : TFLogicItemType;
  public var rect : flash.geom.Rectangle;

  public function new()
  {
  }

  public function Init(data : ByteArray) : Bool
  {
    switch(data.readInt())
    {
      case 0:
        type = FLogicItemType_Point;
        rect = new flash.geom.Rectangle(data.readInt(), data.readInt(), 0, 0);

      case 1:
        type = FLogicItemType_Rect;
        rect = new flash.geom.Rectangle(data.readInt(), data.readInt(), data.readInt(), data.readInt());
    }

    return true;
  }
}

class SentryFLogicTemplate
{
  public var items : Array<SentryFlogicItemTemplate>;

  public function new()
  {
  }

  public function Init(data : ByteArray) : Bool
  {
    var itemsCount : Int = data.readInt();
    var itemIndex : Int;

    items = new Array();

    for(itemIndex in 0...itemsCount)
    {
      var fLogicItem : SentryFlogicItemTemplate = new SentryFlogicItemTemplate();

      fLogicItem.Init(data);

      items.push(fLogicItem);
    }

    return true;
  }
}

class SentryFrameTemplate
{
  public var fLogics   : Array<SentryFLogicTemplate>;
  public var fModules  : Array<SentryFModuleTemplate>;
  public var id        : Int;
  public var boundRect : flash.geom.Rectangle;

  public function new()
  {
  }

  public function Init(data : ByteArray) : Bool
  {
    var fModuleIndex : Int;
    var fLogicIndex  : Int;

    id = data.readInt();

    boundRect = new flash.geom.Rectangle(data.readInt(), data.readInt(), data.readInt(), data.readInt());

    //
    // Read the fmodules
    //

    fModules = new Array();

    var fModulesCount : Int = data.readInt();

    for(fModuleIndex in 0...fModulesCount)
    {
      var fModule : SentryFModuleTemplate = new SentryFModuleTemplate();

      fModule.Init(data);

      fModules.push(fModule);
    }

    //
    // read the flogics
    // 

    fLogics = new Array();

    var fLogicCount : Int = data.readInt();

    for(fLogicIndex in 0...fLogicCount)
    {
      var fLogic : SentryFLogicTemplate = new SentryFLogicTemplate();

      fLogic.Init(data);

      fLogics.push(fLogic);
    }

    return true;
  }
}

class SentryAFrameTemplate
{
  public var frameIndex : Int;
  public var pos : flash.geom.Point;
  public var flags : Int;
  public var time : Int; // delay between frames in miliseconds

  public var cachedMatrix(default, null) : flash.geom.Matrix;

  public function new()
  {
    cachedMatrix = new flash.geom.Matrix();
  }

  public function Init(data : ByteArray) : Bool
  {
    frameIndex = data.readInt();

    pos = new flash.geom.Point(data.readInt(), data.readInt());

    flags = data.readInt();

    time = data.readInt();

    cachedMatrix.identity();
    cachedMatrix.translate(pos.x, pos.y);

    return true;
  }

  public function GetMatrix() : flash.geom.Matrix
  {
    var matrix : flash.geom.Matrix = new flash.geom.Matrix();

    matrix.translate(pos.x, pos.y);

    // TODO: add the flags to the matrix

    return matrix;
  }
}

class SentryAnimTemplate
{
  public var aFrames : Array<SentryAFrameTemplate>;

  public function new()
  {
  }

  public function Init(data : ByteArray) : Bool
  {
    aFrames = new Array();

    var aFrameCount : Int = data.readInt();
    var aFrameIndex : Int;

    for(aFrameIndex in 0...aFrameCount)
    {
      var aFrame : SentryAFrameTemplate = new SentryAFrameTemplate();

      aFrame.Init(data);

      aFrames.push(aFrame);
    }

    return true;
  }
}

class SentrySpriteTemplate
{
  public var modules : Array<SentryModuleTemplate>;
  public var frames  : Array<SentryFrameTemplate>;
  public var anims   : Array<SentryAnimTemplate>;

  public function new()
  {
    modules = new Array();
    frames  = new Array();
    anims   = new Array();
  }

  public function Init(data : ByteArray) : Bool
  {
    data.endian = flash.utils.Endian.LITTLE_ENDIAN;

    //
    // read the modules
    //
    modules = new Array();

    var moduleCount : Int = data.readInt();

    for(moduleIndex in 0...moduleCount)
    {
      var module : SentryModuleTemplate = new SentryModuleTemplate();

      module.Init(data);

      modules.push(module);
    }

    //
    // read the frames
    //
    frames  = new Array();

    var frameCount : Int = data.readInt();

    for(frameIndex in 0...frameCount)
    {
      var frame : SentryFrameTemplate = new SentryFrameTemplate();

      frame.Init(data);

      frames.push(frame);
    }

    //
    // read the anims
    //
    anims   = new Array();

    var animCount : Int = data.readInt();

    for(animIndex in 0...animCount)
    {
      var anim : SentryAnimTemplate = new SentryAnimTemplate();

      anim.Init(data);

      anims.push(anim);
    }

    return true;
  }
}

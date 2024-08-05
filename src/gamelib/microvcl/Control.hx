package gamelib.microvcl;

enum HelpType
{
  HelpType_Context;
  HelpType_Keyword;
}

enum BiDiMode
{
  BiDiMode_LeftToRight;
  BiDiMode_RightToLeft;
  BiDiMode_RightToLeftNoAlign;
  BiDiMode_RightToLeftReadingOnly;
}

class Control extends flash.display.Sprite
{
  //
  // Properties
  //
  public var enabled (getEnabled, setEnabled)    : Bool;
  public var parentControl(getParentControl, setParentControl) : Control;

  public var controlName (getControlName, setControlName) : String;
  public var caption (getCaption, setCaption)    : String;
  public var text (getText, setText)             : String;

  public var hint (getHint, setHint)             : String;
  public var showHint (getShowHint, setShowHint) : Bool;
  public var parentShowHint (getParentShowHint, setParentShowHint) : Bool;

  public var helpContext (getHelpContext, setHelpContext) : Int;
  public var helpKeyword (getHelpKeyword, setHelpKeyword) : String;
  public var helpType    (getHelpType, setHelpType)       : HelpType;

  public var bidiMode (getBiDiMode, setBiDiMode) : BiDiMode;
  public var parentBiDiMode (getParentBiDiMode, setParentBiDiMode) : Bool;

  public var displayTactics : DisplayTactics;

  public var autoAdd        : Bool;

  //
  // Events
  //
  public var onClickEvent(getOnClickEvent, setOnClickEvent) : Dynamic -> Void;

  public function new(parentControl : gamelib.microvcl.Control, controlName : String, displayTactics : DisplayTactics, autoAdd : Bool)
  {
    super();

    this.parentControl = parentControl;

    this.autoAdd = autoAdd;
    
    if (autoAdd && parentControl != null)
    {
      parentControl.addChild(this);
    }

    enabled   = true;

    this.controlName = controlName;

    hint     = "";
    caption  = "";
    text     = "";
    showHint = false;
    parentShowHint = false;

    helpContext = -1;
    helpKeyword = "";
    helpType    = HelpType_Context;

    bidiMode = BiDiMode_LeftToRight;
    parentBiDiMode = false;    

    if (displayTactics != null)
    {
      //trace("control::ctor - dt start");
      this.displayTactics = displayTactics;
      displayTactics.target = this;
      displayTactics.init();
      displayTactics.update();
      //trace("control::ctor - dt end");
    }
  }

  private function getEnabled() : Bool
  {
    return enabled;
  }

  private function setEnabled(v : Bool) : Bool
  {
    enabled = v;

    // TODO: add more mouse events, depending on the application needs
    if (enabled)
    {
      // register the events
      addEventListener(flash.events.Event.ENTER_FRAME, onEnterFrame);
      addEventListener(flash.events.MouseEvent.CLICK, onClick);

      // TODO: iterate over the Control children and enable them
    }
    else
    {
      // unregister the events
      removeEventListener(flash.events.Event.ENTER_FRAME, onEnterFrame);
      removeEventListener(flash.events.MouseEvent.CLICK, onClick);

      // TODO: iterate over the Control children and disable them
    }

    for(index in 0...numChildren)
    {
      try
      {
        var control : gamelib.microvcl.Control = cast getChildAt(index);

        control.enabled = enabled;
      }
      catch(e : Dynamic)
      {
      }
    }

    return enabled;
  }

  private function getControlName() : String
  {
    return controlName;
  }

  private function setControlName(v : String) : String
  {
    controlName = v;

    return controlName;
  }
  
  private function getHint() : String
  {
    return hint;
  }

  private function setHint(v : String) : String
  {
    hint = v;

    return hint;
  }

  private function getCaption() : String
  {
    return caption;
  }

  private function setCaption(v : String) : String
  {
    caption = v;

    return caption;
  }

  private function getText() : String
  {
    return text;
  }

  private function setText(v : String) : String
  {
    text = v;

    return text;
  }

  private function getShowHint() : Bool
  {
    return showHint;
  }

  private function setShowHint(v : Bool) : Bool
  {
    showHint = v;

    return showHint;
  }

  private function getParentShowHint() : Bool
  {
    return parentShowHint;
  }

  private function setParentShowHint(v : Bool) : Bool
  {
    parentShowHint = v;

    return parentShowHint;
  }

  private function getHelpContext() : Int
  {
    return helpContext;
  }

  private function setHelpContext(v : Int) : Int
  {
    helpContext = v;

    return helpContext;
  }

  private function getHelpKeyword() : String
  {
    return helpKeyword;
  }

  private function setHelpKeyword(v : String) : String
  {
    helpKeyword = v;

    return helpKeyword;
  }

  private function getHelpType() : HelpType
  {
    return helpType;
  }

  private function setHelpType(v : HelpType) : HelpType
  {
    helpType = v;

    return helpType;
  }

  private function getBiDiMode() : BiDiMode
  {
    return bidiMode;
  }

  private function setBiDiMode(v : BiDiMode) : BiDiMode
  {
    bidiMode = v;

    return bidiMode;
  }

  private function getParentBiDiMode() : Bool
  {
    return parentBiDiMode;
  }

  private function setParentBiDiMode(v : Bool) : Bool
  {
    parentBiDiMode = v;

    return parentBiDiMode;
  }

  private function getParentControl() : Control
  {
    return parentControl;
  }

  private function setParentControl(control : Control) : Control
  {
    if (parentControl != null)
    {
      if (parentControl.contains(this))
      {
        parentControl.removeChild(this);
      }
    }
    
    parentControl = control;

    if (parentControl != null)
    {
      if (!parentControl.contains(this) && this.autoAdd)
      {
        parentControl.addChild(this);
      }
    }

    return parentControl;
  }

  //
  // Events
  //
  private function getOnClickEvent() : Dynamic -> Void
  {
    return onClickEvent;
  }

  private function setOnClickEvent(v : Dynamic -> Void) : Dynamic -> Void
  {
    onClickEvent = v;

    return onClickEvent;
  }

  private function onEnterFrame(e : flash.events.Event)
  {
    //trace("onenterframe: " + controlName);
  }

  private function onClick(e : flash.events.Event)
  {
    //trace("onClick " + controlName);
    
    if (onClickEvent != null && enabled)
    {
      onClickEvent(e);
    }
  }

  // TODO: find a better way to implement this - maybe with an event listener
  // override this in child classes to update accordingly when the language changes
  public function onLanguageChange(?strMgr : gamelib.stringmanager.StringManager = null)
  {
    if (displayTactics != null)
    {
      displayTactics.onLanguageChange(strMgr);
    }
    
    // also notify the children that the language changed; it's not a fast operation
    for(index in 0...numChildren)
    {
      try
      {
        var control : gamelib.microvcl.Control = cast getChildAt(index);

        control.onLanguageChange(strMgr);
      }
      catch(e : Dynamic)
      {
      }
    }
  }
}
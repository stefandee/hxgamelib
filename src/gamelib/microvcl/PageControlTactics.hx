package gamelib.microvcl;

enum PageControlStyle
{
  PageControlStyle_Button;
  PageControlStyle_Tab;
}

enum PageControlPosition
{
  PageControlPosition_Left;
  PageControlPosition_Right;
  PageControlPosition_Top;
  PageControlPosition_Bottom;
}

class PageControlTactics extends gamelib.microvcl.DisplayTactics
{  
  public var multiline : Bool;
  public var stretch   : Bool;
  public var style     : PageControlStyle;
  public var position  : PageControlPosition;

  public function new()
  {
    super();

    multiline = false;
    stretch   = false;
    style     = PageControlStyle_Tab;
    position  = PageControlPosition_Bottom;
  }

  public function notifyAddPage(page : PageSheet)
  {
  }

  public function notifyRemovePage(page : PageSheet)
  {
  }

  public function notifyActivePage(page : PageSheet)
  {
  }
}
package gamelib.microvcl;

class PageSheet extends gamelib.microvcl.Control
{
  public var index(default, default) : Int;
  
  public function new(parentControl : gamelib.microvcl.PageControl, controlName : String, displayTactics : DisplayTactics, autoAdd : Bool)
  {
    super(parentControl, name, displayTactics, autoAdd);    

    index = 0;
  }

  /*
  private override function setParentControl(control : Control) : Control
  {
    super.setParentControl(control);

    if (parentControl != null)
    {
      var temp : PageControl = cast parentControl;

      index = temp.getPageIndex(this);
    }

    return parentControl;
  }
  */
}

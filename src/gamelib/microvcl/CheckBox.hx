package gamelib.microvcl;

class CheckBox extends ButtonControl
{
  public function new(parentControl : microvcl.Control, name : String, displayTactics : DisplayTactics, autoAdd : Bool)
  {
    super(parentControl, name, displayTactics, autoAdd);
  }

  private override function onClick(e : flash.events.Event)
  {
    if (clicksDisabled)
    {
      return;
    }

    checked = !checked;

    if (onClick != null)
    {
      onClick(e);
    }
  }
}
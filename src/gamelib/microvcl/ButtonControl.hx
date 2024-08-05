package gamelib.microvcl;

class ButtonControl extends Control
{
  public var checked (getChecked, setChecked) : Bool;
  public var clicksDisabled (getClicksDisabled, setClicksDisabled) : Bool;

  public function new(parentControl : gamelib.microvcl.Control, name : String, displayTactics : DisplayTactics, autoAdd : Bool)
  {
    super(parentControl, name, displayTactics, autoAdd);

    checked = false;
    clicksDisabled = false;

    //mouseChildren = false;
  }

  private function getChecked() : Bool
  {
    return checked;
  }

  private function setChecked(v : Bool) : Bool
  {
    checked = v;

    return checked;
  }

  private function getClicksDisabled() : Bool
  {
    return clicksDisabled;
  }

  private function setClicksDisabled(v : Bool) : Bool
  {
    clicksDisabled = v;

    return clicksDisabled;
  }
}
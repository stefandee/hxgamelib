package gamelib.microvcl;

class SpinButtonControl extends ButtonControl
{
  public var onClickUpEvent(default, default)   : Dynamic -> Void;
  public var onClickDownEvent(default, default) : Dynamic -> Void;

  public function new(parentControl : gamelib.microvcl.Control, name : String, displayTactics : DisplayTactics, autoAdd : Bool)
  {
    super(parentControl, name, displayTactics, autoAdd);
  }
}
  
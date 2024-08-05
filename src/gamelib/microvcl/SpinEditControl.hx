package gamelib.microvcl;

class SpinEditControl extends Control
{
  public var value     (default, setValue)     : Float;
  public var increment (default, setIncrement) : Float;
  public var minValue  (default, setMinValue)  : Float;
  public var maxValue  (default, setMaxValue)  : Float;

  public var onChangeEvent(default, default)   : Dynamic -> Void;

  public function new(parentControl : gamelib.microvcl.Control, name : String, displayTactics : DisplayTactics, autoAdd : Bool)
  {
    super(parentControl, name, displayTactics, autoAdd);

    value     = 0.0;
    increment = 1.0;
    minValue  = 0.0;
    maxValue  = 10.0;
  }

  private function setValue(v : Float) : Float
  {
    var oldValue : Float = value;
    
    value = gamelib.MathUtils.clamp(gamelib.MathUtils.correctFloatingPointError(v), minValue, maxValue);

    //var t : Float = 0.05;
    //var x : Float = 0.01;

    //trace(value + "..." + v + "..." + increment + "..." + (0.05 + 0.01) + "..." + (t + x));

    if (oldValue != value)
    {
      if (onChangeEvent != null)
      {
        onChangeEvent(this);
      }
    }

    if (displayTactics != null)
    {
      displayTactics.update();
    }

    return value;
  }

  private function setIncrement(v : Float) : Float
  {
    if (v < 0)
    {
      v = 0;
    }

    increment = v;

    return increment;
  }

  private function setMinValue(v : Float) : Float
  {
    if (v > maxValue)
    {
      minValue = maxValue;
      maxValue = v;
    }
    else
    {
      minValue = v;
    }

    value = gamelib.MathUtils.clamp(value, minValue, maxValue);

    return minValue;
  }

  private function setMaxValue(v : Float) : Float
  {
    if (v < minValue)
    {
      maxValue = minValue;
      minValue = v;
    }
    else
    {
      maxValue = v;
    }

    value = gamelib.MathUtils.clamp(value, minValue, maxValue);

    return maxValue;
  }
}
  
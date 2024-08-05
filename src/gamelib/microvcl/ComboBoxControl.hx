package gamelib.microvcl;

enum ComboBoxCharCase
{
  ComboBoxCharCase_Default;
  ComboBoxCharCase_Upper;
  ComboBoxCharCase_Lower;
}

class ComboBoxControl extends Control
{
  public var items (default, null)             : Array<String>;
  public var sorted (default, setSorted)       : Bool;
  public var itemIndex (default, setItemIndex) : Int;
  public var charCase (default, setCharCase)   : ComboBoxCharCase;

  public var onChangeEvent (default, default) : Dynamic -> Void;
  
  public function new(parentControl : gamelib.microvcl.Control, name : String, displayTactics : DisplayTactics, autoAdd : Bool)
  {
    super(parentControl, name, displayTactics, autoAdd);

    items         = new Array();
    sorted        = false;
    itemIndex     = 0;
    charCase      = ComboBoxCharCase_Default;

    onChangeEvent = null;
  }

  public function addItem(item : String)
  {
    if (item != null)
    {
      if (sorted)
      {
        var index = -1;

        for(i in 0...items.length)
        {
          if (item < items[i])
          {
            index = i;

            break;
          }
        }

        if (index == -1)
        {
          items.push(item);
        }
        else
        {
          items.insert(index, item);
        }
      }
      else
      {
        trace("item pushed: " + item);
        items.push(item);
      }

      // update the display
      if (displayTactics != null)
      {
        displayTactics.update();
      }
    }
  }

  public function clearItems()
  {
    items = new Array();

    itemIndex = -1;
  }

  public function removeItem(index : Int)
  {
    if (index < 0 || index >= items.length)
    {
      return;
    }
    
    items.splice(index, 1);

    if (items.length == 0)
    {
      itemIndex = -1;
    }
    else if (itemIndex >= items.length)
    {
      itemIndex = items.length - 1;
    }
  }

  public function setItemIndex(v : Int) : Int
  {
    // TODO: add custom box type (fixed, default, etc) and set the itemindex accordingly
    itemIndex = Std.int(gamelib.MathUtils.clamp(v, -1, items.length));

    if (displayTactics != null)
    {
      displayTactics.update();
    }

    return itemIndex;
  }

  public function setCharCase(v : ComboBoxCharCase) : ComboBoxCharCase
  {
    charCase = v;

    if (displayTactics != null)
    {
      displayTactics.update();
    }

    return charCase;
  }

  public function setSorted(v : Bool) : Bool
  {
    if (sorted)
    {
      items.sort(itemsSortCallback);
    }

    if (displayTactics != null)
    {
      displayTactics.update();
    }
    
    return sorted;
  }

  private function itemsSortCallback(a : String, b : String)
  {
    if (a == b)
    {
      return 0;
    }
    else if (a > b)
    {
      return 1;
    }
    else
    {
      return -1;
    }
  }

  public function searchItem(v : String) : Int
  {
    for(i in 0...items.length)
    {
      if (items[i] == v)
      {
        //trace("search item " + v + " found at " + i);
        return i;
      }
    }

    //trace("search item " + v + " not found!");
    return -1;
  }
}
package gamelib.stringmanager;

class StringPackage
{
  private var Strings : Array<String>;

  /*
  public function new(strings : Array<String>)
  {
    Strings = new Array();

    for(string in strings)
    {
      Strings.push(new String(string));
    }
  }
  */

  public function new(data : flash.utils.ByteArray)
  {
    data.endian = flash.utils.Endian.LITTLE_ENDIAN;

    Strings = new Array();

    // build the strings from the bytearray coming from the StringTool
    try
    {
      var stringCount : Int = data.readInt();

      for(i in 0...stringCount)
      {
        Strings.push(data.readUTFBytes(data.readInt()));
      }
    }
    catch(e : Dynamic)
    {
      trace(e);
    }
  }
  
  public function GetString(index : Int) : String
  {
    if (index < 0 || index >= Strings.length)
    {
      return "<STRING NOT FOUND!>";
    }

    return Strings[index];
  }
}

class StringManager
{
  private var StringPackages : Array<StringPackage>;

  private function new()
  {
    StringPackages = new Array();
  }

  public function GetString(packageIndex : Int, stringIndex : Int) : String
  {
    if (packageIndex < 0 || packageIndex >= StringPackages.length)
    {
      return "<PACKAGE NOT FOUND!>";
    }

    return StringPackages[packageIndex].GetString(stringIndex);
  }

  public function GetString2(stringIndex : Int) : String
  {
    if (StringPackages.length == 0)
    {
      return "<NO PACKAGES LOADED!>";
    }

    return StringPackages[0].GetString(stringIndex);
  }
}



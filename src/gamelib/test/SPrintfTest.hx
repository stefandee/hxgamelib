package gamelib.test;

class Test1 extends haxe.unit.TestCase 
{    
    public function testBasic()
    {
      assertEquals( gamelib.PopSprintf.format("O%%o", [1, 2, 3, 4]), "O%o");
    }    
}

class Test2 extends haxe.unit.TestCase 
{    
    public function testBasic()
    {
      assertEquals( gamelib.PopSprintf.format("%d", ['C']), "67");
    }    
}

class Test3 extends haxe.unit.TestCase 
{    
    public function testBasic()
    {
      assertEquals( gamelib.PopSprintf.format("%d", [12345]), "12345");
    }    
}

class Test4 extends haxe.unit.TestCase 
{    
    public function testBasic()
    {
      assertEquals( gamelib.PopSprintf.format("%+d", [12345]), "+12345");
    }    
}

class Test5 extends haxe.unit.TestCase 
{    
    public function testBasic()
    {
      assertEquals( gamelib.PopSprintf.format("%10d", [12345]), "     12345");
    }    
}

class Test6 extends haxe.unit.TestCase 
{    
    public function testBasic()
    {
      assertEquals( gamelib.PopSprintf.format("%-10d", [12345]), "12345     ");
    }    
}

class Test7 extends haxe.unit.TestCase 
{    
    public function testBasic()
    {
      assertEquals( gamelib.PopSprintf.format("%010d", [12345]), "0000012345");
    }    
}

class Test8 extends haxe.unit.TestCase 
{    
    public function testBasic()
    {
      assertEquals( gamelib.PopSprintf.format("%3d", [12345]), "12345");
    }    
}

class Test9 extends haxe.unit.TestCase 
{    
    public function testBasic()
    {
      assertEquals( gamelib.PopSprintf.format("%-3d", [12345]), "12345");
    }    
}

class Test10 extends haxe.unit.TestCase 
{    
    public function testBasic()
    {
      assertEquals( gamelib.PopSprintf.format("%d,%*d", [8, 10, 12345]), "8,     12345");
    }    
}

class Test11 extends haxe.unit.TestCase 
{    
    public function testBasic()
    {
      assertEquals( gamelib.PopSprintf.format("%*3$d %d %d", [12345, 8, 10, 8]), "     12345 8 10");
    }    
}

class Test12 extends haxe.unit.TestCase 
{    
    public function testBasic()
    {
      assertEquals( gamelib.PopSprintf.format("%c", [97]), "a");
    }    
}

class Test13 extends haxe.unit.TestCase 
{    
    public function testBasic()
    {
      assertEquals( gamelib.PopSprintf.format("%c", [0x2000 + 97]), "a");
    }    
}

class Test14 extends haxe.unit.TestCase 
{    
    public function testBasic()
    {
      assertEquals( gamelib.PopSprintf.format("%x", [0x12345a]), "12345a");
    }    
}

class Test15 extends haxe.unit.TestCase 
{    
    public function testBasic()
    {
      assertEquals( gamelib.PopSprintf.format("%#x", [0x12345a]), "0x12345a");
    }    
}

class Test16 extends haxe.unit.TestCase 
{    
    public function testBasic()
    {
      assertEquals( gamelib.PopSprintf.format("%#x", [0xcafebabe]), "0xcafebabe");
    }    
}

class Test17 extends haxe.unit.TestCase 
{    
    public function testBasic()
    {
      assertEquals( gamelib.PopSprintf.format("%X", [0x12345a]), "12345A");
    }    
}

class Test18 extends haxe.unit.TestCase 
{    
    public function testBasic()
    {
      assertEquals( gamelib.PopSprintf.format("%#X", [0x12345a]), "0X12345A");
    }    
}

class Test19 extends haxe.unit.TestCase 
{    
    public function testBasic()
    {
      assertEquals( gamelib.PopSprintf.format("%#X", [0xdeadbeef]), "0XDEADBEEF");
    }    
}

class Test20 extends haxe.unit.TestCase 
{    
    public function testBasic()
    {
      assertEquals( gamelib.PopSprintf.format("%o", [031416]), "31416");
    }    
}

class Test21 extends haxe.unit.TestCase 
{    
    public function testBasic()
    {
      assertEquals( gamelib.PopSprintf.format("%#o", [031416]), "031416");
    }    
}

class Test22 extends haxe.unit.TestCase 
{    
    public function testBasic()
    {
      assertEquals( gamelib.PopSprintf.format("%-05d", [123]), "123  ");
      assertEquals( gamelib.PopSprintf.format("%-05d", [-123]), "-123 ");
    }    
}

class Test23 extends haxe.unit.TestCase 
{    
    public function testBasic()
    {
      assertEquals( gamelib.PopSprintf.format("%.6d", [123]), "000123");
      assertEquals( gamelib.PopSprintf.format("%.6d", [-123]), "-000123");
    }    
}

class Test24 extends haxe.unit.TestCase 
{    
    public function testBasic()
    {
      assertEquals( gamelib.PopSprintf.format("%08.5d", [123]), "   00123");
      assertEquals( gamelib.PopSprintf.format("%08.5d", [-123]), "  -00123");
    }    
}

class Test25 extends haxe.unit.TestCase 
{    
    public function testBasic()
    {
      assertEquals( gamelib.PopSprintf.format("%-08.5d", [123]), "00123   ");
      assertEquals( gamelib.PopSprintf.format("%-08.5d", [-123]), "-00123  ");
    }    
}

class Test26 extends haxe.unit.TestCase 
{    
    public function testBasic()
    {
      assertEquals( gamelib.PopSprintf.format("%g", [1.5]), "1.5");
      assertEquals( gamelib.PopSprintf.format("%lg", [1.5]), "1.5");
      assertEquals( gamelib.PopSprintf.format("%Lg", [1.5]), "1.5");
    }    
}

/*
class Test2 extends haxe.unit.TestCase 
{    
    public function testBasic()
    {
      assertEquals( gamelib.PopSprintf.format(), );
    }    
}
*/

class SprintfTest
{
  public function new()
  {
    var r = new haxe.unit.TestRunner();

    r.add(new Test1());
    r.add(new Test2());
    r.add(new Test3());
    r.add(new Test4());
    r.add(new Test5());
    r.add(new Test6());
    r.add(new Test7());
    r.add(new Test8());
    r.add(new Test9());
    r.add(new Test10());
    r.add(new Test11());
    r.add(new Test12());
    r.add(new Test13());
    r.add(new Test14());
    r.add(new Test15());
    r.add(new Test16());
    r.add(new Test17());
    r.add(new Test18());
    r.add(new Test19());
    r.add(new Test20());
    r.add(new Test21());
    r.add(new Test22());
    r.add(new Test23());
    r.add(new Test24());
    r.add(new Test25());
    r.add(new Test26());

    r.run();
  }
}
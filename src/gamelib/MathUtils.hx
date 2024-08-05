package gamelib;

class MathUtils
{
  public static function centerAngle(_x : Float, _y : Float) : Int
  {   
	  if ((_x == 0) && (_y == 0)) return 0;
	
	  if (_y == 0)
	  {
	    if (_x < 0) return 180;
	    else return 0;
	  }
	
	  if (_x == 0)
	  {
	    if (_y < 0) return 270;
	    else return 90;
	  }
	  
  	return Math.round((((Math.atan2(_y, _x) + Math.PI) * 180.0) / Math.PI) + 180) % 360;
  }
  
  // used to convert an angle to the ActionScript DisplayObject rotation
  public static function fixAngle(angle : Int) : Int
  {
    angle = (angle + 90) % 360;
    
    if (angle > 180)
    {
      angle = angle - 360;
    }
    
    if (angle < -180)
    {
      angle = angle + 360;
    }
      
    return angle;
  }  

  public static function randomSign() : Int
  {
    if (Std.random(2) == 0)
    {
      return -1;
    }

    return 1;
  }
  
  public static function clamp(val : Float, min : Float, max : Float) : Float
  {
    if (val < min)
    {
      val = min;
    }
    
    if (val > max)
    {
      val = max;
    }
    
    return val;
  }

  public static function clampAbove(v : Float, upperLimit : Float) : Float
  {
    if (v > upperLimit)
    {
      v = upperLimit;
    }

    return v;
  }

  public static function sign(v : Float) : Float
  {
    if (v < 0)
    {
      return -1;
    }
    
    if (v > 0)
    {
      return 1;
    }
    
    return 0;
  }

  public static function interpolate(alpha : Float, x0 : Float, x1 : Float) : Float
  {
    return x0 + alpha * (x1 - x0);
  }

  public static function remapInterval(x : Float, in0 : Float, in1 : Float, out0 : Float, out1 : Float) : Float
  {
    if (in1 - in0 == 0)
    {
      return Math.POSITIVE_INFINITY;
    }

    // uninterpolate: what is x relative to the interval in0:in1?
    var relative = (x - in0) / (in1 - in0);

    // now interpolate between output interval based on relative x
    return interpolate (relative, out0, out1);
  }

  public static function remapIntervalClamp (x : Float, in0 : Float, in1 : Float, out0 : Float, out1 : Float) : Float
  {
    if (in1 - in0 == 0)
    {
      return Math.POSITIVE_INFINITY;
    }

    // uninterpolate: what is x relative to the interval in0:in1?
    var relative = (x - in0) / (in1 - in0);

    // now interpolate between output interval based on relative x
    return interpolate (clamp(relative, 0, 1), out0, out1);
  }

  // example usage: blendIntoAccumulator (dt * 0.4f, currentFPS, smoothedFPS);
  public static function blendIntoAccumulator(smoothRate : Float, newValue : Float, smoothedAccumulator : Float) : Float
  {
    return interpolate (clamp (smoothRate, 0, 1), smoothedAccumulator, newValue);
  }

  // specify the segment1 and segment2 to perform combinations of ray/segment collisions
  //public static function rayIntersection (segment1 : Bool, x1 : Float, y1 : Float, x2 : Float, y2 : Float, segment2 : Bool, x3 : Float, y3 : Float, x4 : Float, y4 : Float) : flash.geom.Point
  public static function rayIntersection (segment1 : Bool, ax : Float, ay : Float, bx : Float, by : Float, segment2 : Bool, cx : Float, cy : Float, dx : Float, dy : Float) : flash.geom.Point
  {
    var d : Float = (bx-ax) * (dy-cy)-(by-ay) * (dx-cx);

    if (d == 0) return null;

    var r : Float = ((ay-cy) * (dx-cx) - (ax-cx) * (dy-cy)) / d;
    var s : Float = ((ay-cy) * (bx-ax) - (ax-cx) * (by-ay)) / d;

    if (segment1)
    {
      if (r < 0 || r > 1) return null;
    }

    if (segment2)
    {
      if (s < 0 || s > 1) return null;
    }

    return new flash.geom.Point(ax + (bx - ax) * r, ay + (by - ay) * r);
        
    /*
    var xi : Float = ((x3-x4)*(x1*y2-y1*x2)-(x1-x2)*(x3*y4-y3*x4)) / d;
    var yi : Float = ((y3-y4)*(x1*y2-y1*x2)-(y1-y2)*(x3*y4-y3*x4)) / d;
    
    var p = new flash.geom.Point(xi, yi);

    if (segment1)
    {
      if ( xi < Math.min(x1, x2) || xi > Math.max(x1, x2) ) return null;
    }

    if (segment2)
    {
      if ( xi < Math.min(x3, x4) || xi > Math.max(x3, x4) ) return null;
    }

    //if ((xi < Math.min(x1, x2) || xi > Math.max(x1, x2)) && segment1) return null;
    //if ((xi < Math.min(x3, x4) || xi > Math.max(x3, x4)) && segment2) return null;

    //if ((yi < Math.min(y1, y2) || yi > Math.max(y1, y2)) && segment1) return null;
    //if ((yi < Math.min(y3, y4) || yi > Math.max(y3, y4)) && segment2) return null;

    return p;
    */
  }

  /**
  * Corrects errors caused by floating point math.
  */
  public static function correctFloatingPointError(number : Float, precision : Int = 5) : Float
  {
      //default returns (10000 * number) / 10000
      //should correct very small floating point errors

      var correction : Float = Math.pow(10, precision);
      return Math.round(correction * number) / correction;
  }

  public static function computeSqrDist(x1 : Float, y1 : Float, x2 : Float, y2 : Float)
  {
    var dx = x2-x1;
    var dy = y2-y1;

    return dx * dx + dy * dy;
  }

  public static function toScientific(num : Float, ?precision : Int = 20) : String
  {
    if (precision > 20)
    {
      precision = 20;
    }

    if (precision < 0)
    {
      precision = 0;
    }
    
    var sign : String = (num < 0) ? "-" : "";

    num = Math.abs(num);
    
    var e = Math.floor(Math.log(num) / Math.log(10));
    var mult = Math.pow(10, e);

    num = num / mult;

    if (num < 1) 
    {
        num = 1;
    }
    else if ((num < 10) && (num > 9.999999999)) {
        num = 10;
    }
    else if ((num < 100) && (num > 99.99999999)) {
        num = 100;
    }

    // for example: 3000 yields extraChar == 1
    // 3001 yields extraChar == 2
    // not very necessary :)
    var extraChar = (Std.string(num).length == 1) ? 1 : 2;

    var tmpCh = "";
    
    if (extraChar == 1 && precision > 0)
    {
      extraChar = 2;
      tmpCh = ".0";
    }

    var tmp = StringTools.rpad(Std.string(num) + tmpCh, "0", precision + extraChar);
    
    return sign + tmp.substr(0, precision + extraChar) + "e" + ((e >= 0) ? "+" : "") + e;
  }
}
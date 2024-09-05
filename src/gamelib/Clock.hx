package gamelib;

class Timer
{
  public var time : Float;
  public var paused : Bool;

  public function new()
  {
    time   = 0;
    paused = false;
  }

  public function update(dt : Float)
  {
    if (!paused)
    {
      time += dt;
    }
  }

  public function reset()
  {
    time   = 0;
    paused = false;
  }
}

class Clock
{
  public static var instance : gamelib.Clock;
  
  public var simTime (default, null)               : Float;
  public var realTime (default, null)              : Float;
  public var pauseTime (default, null)             : Float;
  public var elapsedSimTime (default, null)        : Float;
  public var elapsedRealTime (default, null)       : Float;
  public var advanceTime (default, setAdvanceTime) : Float;
  public var totalAdvanceTime (default, null)      : Float;
  public var paused (default, setPaused)           : Bool;

  public var speedFactor(default, setSpeedFactor)  : Float;

  public var timer(default, null) : Timer;

  private var timeStamp      : Float;
  private var timeStampPause : Float;
  
  public function new()
  {
    simTime          = 0;
    realTime         = 0;
    elapsedSimTime   = 0;
    elapsedRealTime  = 0;
    advanceTime      = 0;
    totalAdvanceTime = 0;
    pauseTime        = 0;

    timer           = new Timer();

    paused          = false;
    timeStamp       = Date.now().getTime();
  }

  public function reset()
  {
    elapsedSimTime   = 0;
    simTime          = 0;
    advanceTime      = 0;
    totalAdvanceTime = 0;
    pauseTime        = 0;
    realTime         = 0;

    speedFactor      = 1;

    paused           = false;
    timeStamp        = Date.now().getTime();

    timer.reset();
  }

  public function update()
  {
    var prevRealTime = realTime;
    var timeDiff     = speedFactor * MathUtils.clamp(Date.now().getTime() - timeStamp, 0, 100);

    realTime += timeDiff;
    timeStamp = Date.now().getTime();

    // update the elapsed real time
    elapsedRealTime = realTime - prevRealTime;

    if (paused)
    {
      pauseTime += timeDiff;
    }

    /*
    if (!paused)
    {
      var oldSimTime = simTime;
      
      simTime = realTime + totalAdvanceTime - pauseTime;

      timer.update(simTime - oldSimTime);
    }
    else
    {
      pauseTime += MathUtils.clamp(timeDiff, 0, 100);
    }
    */

    // update the elapsed sim time
    var prevSimTime = simTime;
    simTime = realTime + totalAdvanceTime - pauseTime;
    elapsedSimTime = simTime - prevSimTime;

    timer.update(elapsedSimTime);

    // reset the advance time
    totalAdvanceTime += advanceTime;
    advanceTime = 0;
  }

  private function setAdvanceTime(v : Float) : Float
  {
    if (v < 0)
    {
      v = 0;
    }

    advanceTime = v;

    return advanceTime;
  }

  private function setPaused(v : Bool) : Bool
  {
    if (v && !paused)
    {
      //timeStampPause = Date.now().getTime();
    }

    if (!v && paused)
    {
      //pauseTime += Date.now().getTime() - timeStampPause;
    }

    paused = v;

    return paused;
  }

  private function setSpeedFactor(v : Float) : Float
  {
    speedFactor = v;

    if (speedFactor < 1)
    {
      speedFactor = 1.0;
    }

    return speedFactor;
  }
}
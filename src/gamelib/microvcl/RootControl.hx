package gamelib.microvcl;

class RootControl extends gamelib.microvcl.Control
{
	private var theRoot : flash.display.MovieClip;
  
  public function new(controlName : String)
  {
    super(null, controlName, new gamelib.microvcl.DisplayTactics(), false);

    // setup the root
    theRoot = flash.Lib.current;

		// setup the stage
    var stage : flash.display.Stage = theRoot.stage;

		stage.scaleMode      = flash.display.StageScaleMode.NO_SCALE;
    stage.stageFocusRect = false;

		stage.addEventListener(flash.events.Event.ENTER_FRAME, onEnterFrame);

    theRoot.addChild(this);
  }

	private override function onEnterFrame(e : flash.events.Event) 
  {
  }
}

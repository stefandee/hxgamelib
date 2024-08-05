package gamelib.microvcl;

class Application
{
  public var title (getTitle, setTitle) : String;
	public static var instance : Application;

	public var root : gamelib.microvcl.RootControl;

  public function new(title : String)
  {
    this.title = title;

    try
    {
      root = new gamelib.microvcl.RootControl("ApplicatonRootControl");
    }
    catch(e : Dynamic)
    {
      trace(e);
    }
  }

  private function getTitle() : String
  {
    return title;
  }

  private function setTitle(v : String) : String
  {
    title = v;

    return title;
  }

  public function getRoot() : gamelib.microvcl.RootControl
  {
    return root;
  }

  public function run()
  {
  }
}
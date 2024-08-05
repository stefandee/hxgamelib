package gamelib.microvcl;

import gamelib.microvcl.Button;

class Form extends Control
{
  public var modalResult (getModalResult, setModalResult) : ModalResult;

  public function new(parentControl : gamelib.microvcl.Control, name : String, displayTactics : DisplayTactics, autoAdd : Bool)
  {
    super(parentControl, name, displayTactics, autoAdd);

    modalResult = ModalResult_None;
  }

  //
  // Members
  //
  private function getModalResult() : ModalResult
  {
    return modalResult;
  }

  private function setModalResult(v : ModalResult) : ModalResult
  {
    modalResult = v;

    return modalResult;
  }

  //
  // Methods
  //
  public function showModal()
  {
  }

  // for convenience only :)
  public function show()
  {
    visible = true;
  }

  public function hide()
  {
    visible = false;
  }
}
class Game extends Screen {
  Game() {
    engine=new Engine();
    state=new Main();
    engine.step();
  }
  void upd() {
    if (bg!=null)
      image(bg,0,0,width,height);
    else
      background(255);
    state.upd();
    super.upd();
  }
  void mPressed() {
    state.mPressed();
  }
}
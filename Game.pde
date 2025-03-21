class Game extends Screen {
  Game() {
    engine=new Engine();
    loadData(dataPath("AUTO.JSON"));
    state=new Main();
    //engine.step();
  }
  void upd() {
    if (bg!=null)
      image(bg,0,0,width,height);
    else
      background(bgc);
    state.upd();
    super.upd();
  }
  void mPressed() {
    state.mPressed();
  }
  void bPressed() {
    state.bPressed();
  }
}
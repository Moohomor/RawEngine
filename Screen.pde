class Screen {
  Pane pane;
  Screen() {
    pane=new Pane(0,0,width,height);
  }
  void upd() {
    pane.upd(0,0);
  }
  void mPressed() {
    pane.mPressed();
  }
  void bPressed() {
    System.exit(0);
  }
}
class Menu extends Screen {
  Menu() {
    Button b1=new Button(20,height/2-50,"Play") {
      void draw_bg(int x,int y) {
        fill(bgcol);noStroke();
        rect(x,y,sx,sy,10,10,0,0);
      }
      void mPressed() {
        screen=new MiddleScreen(new ColorTrans(new Game(),0,100),500);
        if (new File(dataPath("GAME.JSON")).exists())
          loadData("GAME.JSON");
      }
    },
           b2=new Button(20,height/2+50,"Reset") {
      void draw_bg(int x,int y) {
        fill(bgcol);noStroke();
        rect(x,y,sx,sy,0,10,10,10);
      }
      void mPressed() {
        background(255,0,0);
      }
    };
    pane.ui.add(b1);
    pane.ui.add(b2);
  }
  void upd() {
    background(255);
    super.upd();
  }
}
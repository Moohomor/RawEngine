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
    /*Pane pan=new Pane(300,300,300,300);
    pan.ui.add(new Button(0,0,"penis"));
    pane.ui.add(pan);*/
  }
  void upd() {
    background(255);
    /*fill(0);
    textSize(70);
    textAlign(LEFT,TOP);
    text("Play",20,height/2-50);
    text("Reset",20,height/2+50);*/
    super.upd();
  }
}
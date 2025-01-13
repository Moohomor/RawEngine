class Screen {
  Screen() {}
  void upd() {}
  void mPressed() {}
  void bPressed() {
    System.exit(0);
  }
}
class Menu extends Screen {
  Menu() {}
  void upd() {
    background(255);
    fill(0);
    textSize(70);
    textAlign(LEFT,TOP);
    text("Play",20,height/2-50);
    text("Reset",20,height/2+50);
  }
  void mPressed() {
    if (mousein(20,height/2-50,width,60)) {
      screen=new MiddleScreen(new ColorTrans(new Game(),0,500),2500);
      new PAudio("burp.mp3").start();
    } else if (mousein(20,height/2+50,width,60))
      background(255,0,0);
  }
}
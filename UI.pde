class Ui {
  Action mPressed;
  int x,y,sx=100,sy=100;
  Ui(int xx,int yy) {x=xx;y=yy;}
  Ui(int xx,int yy,int sxx,int syy) {
    x=xx;y=yy;
    sx=sxx;sy=syy;
  }
  void upd() {}
  void mPressed() {
    if (mPressed!=null)
      mPressed.run();
  }
}
interface Action {
  void run();
}
class Pane extends Ui {
  ArrayList<Ui> ui=new ArrayList<Ui>();
  Pane(int x,int y) {super(x,y);}
  Pane(int x,int y,int sx,int sy) {super(x,y,sx,sy);}
  void upd() {
    for (Ui i:ui) i.upd();
  }
}
class Button extends Ui {
  color txcol=color(240,240,240),
        bgcol=color(0,0,0,200);
  String text;
  Button(int x,int y) {super(x,y);}
  Button(int x,int y,int sx,int sy) {super(x,y,sx,sy);}
  Button(int x,int y,String t) {
    super(x,y);
    sx=int(textWidth(t))+20;sy=int(textAscent())*2;
  }
  void upd() {
    fill(bgcol);noStroke();
    rect(x,y,sx,sy,10);
    textAlign(CENTER,CENTER);
    fill(txcol);
    text(text,x+sx/2,y+sy/2);
  }
}
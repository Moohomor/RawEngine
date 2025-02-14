class Ui {
  Action mPressed;
  int x,y,sx=100,sy=100;
  Ui(int xx,int yy) {x=xx;y=yy;}
  Ui(int xx,int yy,int sxx,int syy) {
    x=xx;y=yy;
    sx=sxx;sy=syy;
  }
  void upd(int shx,int shy) {}
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
  void upd(int shx,int shy) {
    for (Ui i:ui) i.upd(x+shx,y+shy);
  }
  void mPressed() {
    for (Ui i:ui)
      if (mousein(i.x,i.y,i.sx,i.sy))
        i.mPressed();
  }
}
class Button extends Ui {
  color txcol=color(240,240,240),
        bgcol=color(0,0,0,180);
  String text;int textsize=70;
  PImage img;
  Button(int x,int y) {super(x,y);}
  Button(int x,int y,int sx,int sy) {super(x,y,sx,sy);}
  Button(int x,int y,String t) {
    super(x,y);
    text=t;
    textSize(textsize);
    sx=int(textWidth(t))+20;sy=int(textAscent()*1.9);
  }
  void upd(int shx,int shy) {
    if (text==null)
      image(img,shx+x,shy+y,sx,sy);
    else {
      textSize(textsize);
      draw_bg(x+shx,y+shy);
      textAlign(CENTER,CENTER);
      fill(txcol);
      text(text,x+shx+sx/2,y+shy+sy/2);
    }
  }
  void draw_bg(int x,int y) {
    fill(bgcol);noStroke();
    rect(x,y,sx,sy,10);
  }
}
class Ui {
  int x,y,sx=100,sy=100;
  Ui(int xx,int yy) {x=xx;y=yy;}
  Ui(int xx,int yy,int sxx,int syy) {
    x=xx;y=yy;
    sx=sxx;sy=syy;
  }
  void upd(int shx,int shy) {}
  void mPressed() {}
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
class Toast {
  color txcol=color(240,240,240),
        bgcol=color(0,0,0,180);
  int textsize=40,titleh;
  int sx=width-40,sy=200;
  String title,text;PImage img;
  long born;
  Toast(String titl,String body,String image) {
    title=titl;
    text=body;
    img=imdata.get(image);
    textSize(textsize);
    titleh=int(textAscent()*1.9);
    if (img!=null)
      img.resize(sy-10-titleh,sy-10-titleh);
    //sx=int(textWidth(title+text))+20;sy=int(textAscent()*1.9);
    born=millis();
  }
  void upd(int x,int y) {//10+40*sin(x*PI/120)
    int t=(int)min(millis()-born,700)/7;
    x-=sx/2;
    y=y*t/100;
    textSize(textsize);
    fill(bgcol);noStroke();
    rect(x,y,textWidth(title)+30,titleh-10,15,15,0,0);
    rect(x,y+titleh-10,sx,sy-titleh+5,0,15,15,15);
    fill(txcol,255);
    textAlign(LEFT,TOP);
    text(title,x+15,y+10);
    textSize(textsize-15);
    textAlign(LEFT,CENTER);
    text(text,x+15,y+titleh,sx-30-(img==null?0:sy-titleh+20),sy-titleh-15);
    if (img!=null)
      image(img,sx-sy+titleh+10,y+titleh);
  }
  void mPressed() {
    
  }
}
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
  byte statee=0;
  String title,text,intro;PImage img;
  long born,introt,lifetime=10000;
  Toast(String titl,String body,String image) {
    init(titl,body,image,null);
    statee=2;
  }
  Toast(String titl,String body,String image,String intro) {
    init(titl,body,image,intro);
  }
  void init(String titl,String body,String image,String intr) {
    title=titl;
    text=body;
    intro=intr;
    introt=born+lifetime/3;
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
    t=int(10+165*sin(t*PI/108.5));
    x-=sx/2;
    y=y*t/100;
    fill(bgcol);noStroke();
    /*rect(x,y,textWidth(title)+30,titleh-10,15,15,0,0);
    rect(x,y+titleh-10,sx,sy-titleh+5,0,15,15,15);*/
    rect(x,y,sx,sy,20);
    fill(txcol,255);
    switch (statee) {
      case 0:
      drawIntro(x,y,100);break;
      case 1:
      drawTrans(x,y);break;
      case 2:
      drawToast(x,y,100);
    }
  }
  private void drawIntro(int x,int y,int lit) {
    textSize(60);
    textAlign(CENTER,CENTER);
    fill(txcol,255*lit/100);
    text(intro,x,y,sx,sy);
    if (millis()>introt)
      statee=1;
  }
  private void drawToast(int x,int y,int lit) {
    textAlign(LEFT,TOP);
    textSize(textsize);
    fill(txcol,255*lit/100);
    text(title,x+15,y+20);
    textSize(textsize-15);
    textAlign(LEFT,CENTER);
    text(text,x+15,y+titleh,sx-30-(img==null?0:sy-titleh+20),sy-titleh-15);
    tint(255,255*lit/100);
    if (img!=null)
      image(img,x+sx-sy+titleh,y+titleh);
    tint(255,255);
    fill(255,255);
  }
  private void drawTrans(int x,int y) {
    int ilit=int((millis()-introt))/2;
    println(ilit);
    drawIntro(x-ilit/4,y,max(0,100-ilit));
    drawToast(x+20-ilit/4,y,ilit-10);
    if (millis()-introt>190)
      statee=2;
  }
  void mPressed() {
    
  }
}
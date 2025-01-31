PImage getMirror(PImage img) {
  PGraphics pg = createGraphics(img.width, img.height, JAVA2D);
  pg.beginDraw();
  pg.scale(-1, 1);
  pg.image(img, -img.width, 0);
  pg.endDraw();
  return pg.get();
}
class ZeroDivisionException extends RuntimeException
  {ZeroDivisionException(){}}
class SyntaxError extends RuntimeException
  {SyntaxError(String msg){super(msg);}}
boolean mousein(int x,int y,int sizex,int sizey) {
  return mouseX>x&&mouseX<x+sizex&&
         mouseY>y&&mouseY<y+sizey;
}
boolean isDigit(String s) {
  try {
    new Float(s);
    return true;
  } catch (NumberFormatException e) {
    return false;
  }
/*if (s.equals("")||s.charAt(0)!='-'&&!Character.isDigit(s.charAt(0))) return false;
  for (char c:s.substring(1).toCharArray())
    if (!Character.isDigit(c)&&c!='.')
      return false;*/
  //return true;
}
/*boolean isIntegerStr(String s) {
  if (s.equals("")) return false;
  for (char c:s.toCharArray())
    if (!Character.isDigit(c))
      return false;
  return true;
}*/

void setst(Screen st) {screen=new MiddleScreen(st,200);}
class MiddleScreen extends Screen  {
  Screen s2;
  PImage sh1,sh2;
  long time,born;
  MiddleScreen(Screen st2,int tm) {
    s2=st2;
    time=tm;
    born=millis();
    sh1=get();
    st2.upd();
    sh2=get();
    background(sh1);
  }
  void upd() {
    long lifetime=millis()-born;
    tint(255,lifetime*255/time);
    image(sh2,0,0);
    if (lifetime>time)
      screen=s2;
  }
}
class MiddleState extends State {
  State s2;
  PImage sh1,sh2;
  long time,born;
  MiddleState(State st2,int tm) {
    s2=st2;
    time=tm;
    born=millis();
    sh1=get();
    st2.upd();
    sh2=get();
    background(sh1);
  }
  void upd() {
    long lifetime=millis()-born;
    tint(255,lifetime*255/time);
    image(sh2,0,0);
    if (lifetime>time)
      state=s2;
  }
}
class ColorTrans extends Screen {
  Screen scr;long time,born;
  color col;
  ColorTrans(Screen s,color c,long t) {
    scr=s;
    time=t;
    col=c;
    born=millis();
  }
  void upd() {
    background(col);
    if (millis()-born>time)
      screen=scr;
  }
}
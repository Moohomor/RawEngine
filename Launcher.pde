import java.util.ArrayDeque;
import java.util.Map;
Engine engine;
Screen screen;
State state;
PImage prev;
long prevtap=millis();
ArrayList<String> chrs=new ArrayList<String>();
int avchr;
PImage bg;
HashMap<String,Module> mods=new HashMap<String,Module>();
HashMap<String,PImage> imdata=new HashMap<String,PImage>();
HashMap<String,Float> nvars=new HashMap<String,Float>();
HashMap<String,String> vars=new HashMap<String,String>();
color cbg=0;
void setup() {
  opPriority.put("=",0);
  opPriority.put("!=",0);
  opPriority.put("|",1);
  opPriority.put("&",2);
  opPriority.put(">",3);
  opPriority.put("<",3);
  opPriority.put("<=",3);
  opPriority.put(">=",3);
  opPriority.put("+",4);
  opPriority.put("-",4);
  opPriority.put("*",5);
  opPriority.put("/",5);
  opPriority.put("%",5);
  nvars.put("PI",PI);
  //loadData();
  screen=new Menu();
  prev=createImage(width,height,RGB);
}

void draw() {
  screen.upd();
  if (millis()-prevtap<200) {
    tint(255,255*50/(millis()-prevtap));
    image(prev,0,0);
  }
  tint(255,255);
  textAlign(CENTER,CENTER);
  fill(0,120);
  noStroke();
  rect(20,20,200,80,20);
  fill(255,210);
  textSize(40);
  text("FPS: "+int(frameRate),20,20,200,80);
}
void mousePressed() {
  prev=get();
  prevtap=millis();
  screen.mPressed();
}
@Override
public void onBackPressed() {
  screen.bPressed();
}
void setbg(PImage im) {
  bg=im;
  bg.resize(width,height);
}
/*void loadData() {
  for (String name:new File(
    sketchPath("")).list()) {
    String naml=name.toLowerCase();
    if (naml.endsWith(".png")||
        naml.endsWith(".jpg")) {
      imdata.put(name,loadImage(name));
    }
  }
}*/
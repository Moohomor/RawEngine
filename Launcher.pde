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
ArrayList<Toast> toasts=new ArrayList<Toast>();
ArrayDeque<Module> modstack=new ArrayDeque<Module>();
HashMap<String,Module> mods=new HashMap<String,Module>();
HashMap<String,PImage> imdata=new HashMap<String,PImage>();
HashMap<String,Float> nvars=new HashMap<String,Float>();
HashMap<String,String> vars=new HashMap<String,String>();
HashMap<String,PAudio> audio=new HashMap<String,PAudio>();
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
  vars.put("Engine.bg_name","");
  nvars.put("Math.pi",PI);
  nvars.put("Math.e",exp(1));
  for (String i: NECESSARY_IMAGES)
    imdata.put(i,loadImage(i));
  //loadData();
  screen=new Menu();
  prev=createImage(width,height,RGB);
}

void draw() {
  screen.upd();
  int ty=40;
  for (int i=0;i<toasts.size();i++) {
    Toast t=toasts.get(i);
    t.upd(width/2,ty);
    ty+=t.sy+20;
  }
  while (toasts.contains(null))
    toasts.remove(null);
  if (millis()-prevtap<200) {
    tint(255,255*50/(millis()-prevtap));
    image(prev,0,0);
    tint(255,255);
  }
  if (SHOW_FPS) {
    tint(255,255);
    textAlign(CENTER,CENTER);
    fill(0,120);
    noStroke();
    rect(20,20,200,80,20);
    fill(255,210);
    textSize(40);
    text("FPS: "+int(frameRate),20,20,200,80);
  }
}
void mousePressed() {
  trans();
  screen.mPressed();
}
void trans() {
  prev=get();
  prevtap=millis()-1;
}
@Override
public void onBackPressed() {
  screen.bPressed();
}
void setbg(String name) {
  vars.put("Engine.bg_name",name);
  if (imdata.containsKey(name))
    setbg_(imdata.get(name));
  else bg=null;
}
void setbg_(PImage im) {
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
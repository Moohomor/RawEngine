import java.util.ArrayDeque;
import java.util.Map;
import java.util.HashSet;
import java.util.Arrays;
Engine engine;
Screen screen;
State state;
PImage prev;
long prevtap=millis();
ArrayList<String> chrs=new ArrayList<String>();
int avchr;
PImage bg;
color bgc=color(0);
ArrayList<Toast> toasts=new ArrayList<Toast>();
ArrayDeque<Module> modstack=new ArrayDeque<Module>();
HashMap<String,Module> mods=new HashMap<String,Module>();
SafeMap<String,PImage> imdata=new SafeMap<String,PImage>();
HashMap<String,Float> nvars=new HashMap<String,Float>();
HashMap<String,String> vars=new HashMap<String,String>();
SafeMap<String,PAudio> audio=new SafeMap<String,PAudio>();
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
  vars.put("Engine.text","");
  nvars.put("Math.pi",PI);
  nvars.put("Math.e",exp(1));
  nvars.put("choice",-1.);
  for (String i: NECESSARY_IMAGES)
    imdata.put(i,loadImage(i));
  println(imdata);
  loadAchievements();
  for (String i:loadStrings("achievements.csv")) {
    String name=i.split(";")[3].trim();
    imdata.put(name,loadImage(name));
  }
  screen=new Menu();
  dfsMods("main");
  println(mods);
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
  if (millis()-prevtap<TRANSITION_DURATION) {
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
  PImage nbg=imdata.get(name);
  if (nbg!=null) {
    vars.put("Engine.bg_name",name);
    setbg_(nbg);
  } else bg=null;
  /*if (imdata.containsKey(name))
    setbg_();
  else bg=null;*/
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
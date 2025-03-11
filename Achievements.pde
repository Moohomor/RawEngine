HashMap<String,Achievement> achs=new HashMap<String,Achievement>();
void loadAchievements() {
  String[] rows=loadStrings("achievements.csv");
  String [][] list=new String[rows.length][3];
  for (int i=0;i<rows.length;i++)
    list[i]=rows[i].split(";");
  for (int i=0;i<list.length;i++) {
    println(i,list[i].length);
    Achievement a=new Achievement();
    a.title=list[i][1];
    a.body=list[i][2];
    list[i][3]=list[i][3].trim();
    //if (!imdata.containsKey(list[i][3])) {
      imdata.put(list[i][3],loadImage(list[i][3]));
      a.img=imdata.get(list[i][3]);
      a.imgn=list[i][3];
    //}
    achs.put(list[i][0],a);
  }
  
  File file=new File(dataPath("done_achievements"));
  if (!file.exists())
    saveStrings("done_achievements",new String[0]);
  ArrayList<String> dones = new ArrayList<String>(Arrays.asList(loadStrings("done_achievements")));
  for (String s:dones)
    achs.get(s).done=true;
}
void saveAchievements() {
  HashSet<String> dones=new HashSet<String>();
  for (String name:achs.keySet()) {
    if (achs.get(name).done)
      dones.add(name);
  }
  saveStrings(dataPath("done_achievements"),(String[])dones.toArray(new String[0]));
}
class Achievement {
  String intro="NEW ACHIEVEMENT",title,body;
  PImage img;
  String imgn;
  boolean done=false;
}
class AchievementsScreen extends Screen {
  String[][] list;
  int shift=-100,length;
  AchievementsScreen() {
    super();
    int i=0;
    for (Achievement a: achs.values()) {
      final String title=a.title,text=a.body;
      final PImage img=a.img;
      final int textsize=35;
      final boolean done=a.done;
      textSize(textsize);
      final int titleh=int(textAscent()*1.9);
      Pane pn=new Pane(20,20+i*220,width-40,200) {
        color txcol=color(240,240,240);
        void upd(int shx,int shy) {
          shy-=shift;
          fill(0,220);
          rect(x+shx,y+shy,sx,sy,10);
          textAlign(LEFT,TOP);
          textSize(textsize);
          fill(txcol,done?255:128);
          text(title,x+10+shx,y+20+shy);
          textSize(textsize-15);
          textAlign(LEFT,CENTER);
          text(text,x+shx+10,y+shy+titleh,sx-30-sy+titleh,sy-titleh-15);
          if (img!=null) {
            if (!done)
              tint(255,128);
            image(img,x+shx+sx+10-sy+titleh,y+shy+titleh+10,sy-20-titleh,sy-20-titleh);
            tint(255,255);  
          }
          fill(255,255);
          super.upd(x,y);
        }
      };
      pane.ui.add(pn);
      i++;
    }
    length=20+achs.size()*220;
  }
  void upd() {
    background(255);
    fill(0);
    textAlign(CENTER,CENTER);
    textSize(60);
    text("That's all!",width/2,1100+length-shift);
    
    super.upd();
    textAlign(CENTER,CENTER);
    textSize(60);
    fill(0);
    rect(0,0,width,100);
    fill(255);
    text("❌ Close",width/2,50);
    //shift=(mouseY-prevy)-prevs;
    //prevy=mouseY;
  }
  void mPressed() {
    /*prevy=mouseY;
    prevs=shift;*/
    if (mouseY<100)
      screen=new Menu();
    else if (mouseY>height/2) {
      if (shift<length)
        shift+=500;}
    else if (shift!=-100)
      shift-=500;
  }
  void bPressed() {
    screen=new Menu();
    trans();
  }
}
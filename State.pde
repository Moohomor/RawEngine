class State {
  void upd() {}
  void mPressed() {}
  void bPressed() {}
}
class Main extends State {
  Main() {}
  void upd() {
    for (int i=0;i<chrs.size();i++) {
      PImage img=imdata.get(chrs.get(i));
      int w=int(map(img.width,0,img.height,0,height*.3)),
          h=int(map(img.height,0,img.height,0,height*0.3));
      image(img,30+i*avchr/chrs.size(),height*.6+20-h,w,height*.3);
    }
    fill(0,170);
    noStroke();
    rect(20,height*0.6,width-40,height*0.3,15);
    fill(255);
    textSize(40);
    textAlign(LEFT,TOP);
    text(vars.get("Engine.text"),50,height*0.6+10,width-70,height*.3-20);
  }
  void mPressed() {
    engine.step();
  }
}
class Choice extends State {
  String q;
  String[] chooses;
  int vpos=int(height*.7)-90;
  final int qpos=height/2-100,
            bpos=int(height*0.85)-100;
  Choice(String[] c) {
    q = c[0];
    chooses=new String[c.length-1];
    for (int i=1;i<c.length;i++)
      chooses[i-1]=c[i];
  }
  void upd() {
    if (!q.equals("")) {
      fill(0,170);
      noStroke();
      rect(20,qpos,width-40,height*0.2-10,10);
      fill(255);
      textSize(40);
      textAlign(CENTER,CENTER);
      text(q,20,qpos,width-40,height*0.2-10);
    }
    if (chooses.length==0) {
      tint(255,200);
      image(imdata.get("choicebg.png"),0,bpos-50,width,300);
      tint(255,180);
      image(imdata.get("yes.png"),60,bpos,200,200);
      image(imdata.get("no.png"),width-300,bpos,200,200);
      tint(255,255);
    } else {
      for (int i=0;i<chooses.length;i++) {
        fill(0,170);
        noStroke();
        rect(20,vpos+110*i,width-40,100,10);
        fill(255);
        textSize(40);
        textAlign(CENTER,CENTER);
        text(chooses[i],20,vpos+110*i-10,width-40,110);
      }
    }
  }
  void mPressed() {
    if (chooses.length==0) {
      if (mousein(60,bpos,200,200)) {
        nvars.put("choice",1.);
        state=new Main();
      } else if (mousein(width-300,bpos,200,200)) {
        nvars.put("choice",0.);
        state=new Main();
      }
    } else {
      int p=(mouseY-vpos)/110;
      if (0<=p&&p<chooses.length) {
        nvars.put("choice",(float)p);
        state=new Main();
      }
    }
    if (nvars.containsKey("choice")) {
      engine.step();
      println("Choosed",nvars.get("choice"));
    }
  }
}
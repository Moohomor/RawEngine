void choose_minigame(String[] tokens) {
  String name=tokens[1];
  if (name.equals("quick_tap"))
    state=new InternalMG();
}
class Minigame extends State {
  void upd() {}
}
class InternalMG extends Minigame {
  long end,born,tap;int ww,hh,score=0;
  byte state_=0;
  InternalMG() {
    born=millis();
    end=millis()+int(random(500,4400));
    ww=width/2;
    hh=height/2;
  }
  void upd() {
    switch (state_) {
    case 0:
      tap=millis();
      if (millis()<end) {
        background(240,10,10);
        fill(255);
        textSize(60);
        textAlign(CENTER);
        text("When screen will become green, tap as quick as it possible",0,height-200,width,height);
      } else {
        background(10,230,10);
        stroke(255);
        strokeWeight(50);
        line(ww-250,hh+300,ww+250+max(-1000,end-millis())/2,hh+300);
      }
    break;
    case 1:
      stroke(255);
      background(20,220,20);
      strokeWeight(50);
      noFill();
      //line(ww-200,hh,ww,hh+200);
      //line(ww,hh+200,ww+200,hh-300);
      ellipse(ww,hh,600,600);
      noStroke();
      fill(245,245,245);
      textSize(160);
      textAlign(CENTER, CENTER);
      text(str(score),ww,hh);
      break;
    case 2:
      stroke(255);
      background(220,20,20);
      strokeWeight(50);
      line(ww-200,hh-200,ww+200,hh+200);
      line(ww+200,hh-200,ww-200,hh+200);
      noStroke();
    }
    if (state_>0) {
      if (millis()-tap>1000) {
        end=millis()+int(random(500,5000));
        state_=0;
      }
      else if (score>20||millis()-born>40000) {
        state=new Main();
        nvars.put("quick_tap.score",score+0.0);
      }
    }
    super.upd();
  }
  void mPressed() {
    if (state_==0) {
      if (millis()<end) state_=2;
      else {
        state_=1;
        score+=1000/(millis()-end);
      }
    }
  }
}
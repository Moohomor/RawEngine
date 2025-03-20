class Engine {
  Module module;
  ArrayDeque<IfBlock> ifs=new ArrayDeque<IfBlock>();
  ArrayDeque<Block> loops=new ArrayDeque<Block>();
  Engine() {
    //dfsMods("main");
    println(mods);
    module=mods.get("main");
    module.pos=0;
  }
  /*private void loadModules() {
    for (String name:new File(
        sketchPath("")).list())
      if (name.endsWith(".mod")) {
        String name_=name.substring(0,name.length()-4);
        mods.put(name_,
                 new Module(name_,loadStrings(name)));
    }
  }*/
  void step() {
    println("Step! Pos "+module.pos+1+" at",module.name);
    for (;;module.pos++) {
      int pos=module.pos;
      if (module.pos>=module.length) {
        //if (module.previous==null) {
        if (modstack.isEmpty()||
            modstack.getLast()==null) {
          screen=new Menu();
          new File(dataPath("AUTO.JSON")).delete();
          return;
        } else {
          //module=module.previous;
          module=modstack.pollLast();
          continue;
        }
      }
      if (AUTOSAVES)
        saveData(dataPath("AUTO.JSON"));
      String line=module.rows[pos].trim();
      int hashpos=line.indexOf("#");
      println(line,hashpos);
      //if (line.endsWith("#")) continue;
      if (hashpos!=-1)
        line=line.substring(0,hashpos);
      if (line.equals("")) continue;
      String[] tokens = line.replace("\\n","\n").split(" ");
      String fn=tokens[0].trim();//.substring(1);
      println(module.name,pos,"_"+fn+"_");
      if (fn.contains("-")) {
        module.pos++;
        break;
      } else if (fn.equals("tx")) {
        vars.put("Engine.text",preprocess(join(tokens," ").substring(3)));
      } else if (fn.equals("append")) {
        vars.put("Engine.text",vars.get("Engine.text")+" "+preprocess(join(tokens," ").substring(7)));
      } else if (fn.equals("print"))
        println("["+module.name+":"+str(module.pos+1)+"] "+preprocess(line.substring(5).trim()));
      else if (fn.equals("bg")) {
        bg=null;
        /*if (tokens[1].startsWith("#")) {
          
          bgc=color(red,blue,green);
        } else */if (tokens.length==2&&isDigit(tokens[1])) {
          bgc=color(int(tokens[1]));
        } else if (tokens.length==2&&tokens[1].split(".").length==3) {
          String[] cl=tokens[1].split(".");
          bgc=color(int(cl[0]),int(cl[1]),int(cl[2]));
        } else {
          String name=join(tokens,' ').substring(3);
          setbg(name);
        }
      } else if (fn.equals("endgame")) {
        screen=new Menu();
        break;
      } else if (fn.equals("audio")) {
        String name=preprocess(tokens[2]);
        if (tokens[1].equals("play")) {
          if (!audio.containsKey(name))
            audio.put(name,new PAudio(name));
          audio.get(name).start();
        } else if (tokens[1].equals("stop")) {
          audio.get(name).stop();
          audio.remove(name);
        }
      } else if (fn.equals("if")) {
        /*for (int i=pos;i<module.length;i++) {
          String line1=module.rows[i];
          String[] tokens1 = line1.replace("\\n","\n").split(" ");
          String fn1=tokens1[0].trim();
          if (fn1.contains("else")) {
            els=i;
            
          } else if (fn.contains("endif")) {
            endif=i;
            break;
          }
        }*/
        //if (!eval(preprocess(line.substring(3))).equals("1"))
        IfBlock blk=(IfBlock)module.blocks.get(pos);
        ifs.addLast(blk);
        println(blk);
        if (module.exprs.get(pos).eval()==0)
          module.pos=blk.els!=-1?blk.els:blk.end;
      } else if (fn.equals("else")) {
        module.pos=ifs.getLast().end;
      } else if (fn.equals("endif")) {
        ifs.pollLast();
      } else if (fn.equals("endloop")) {
        module.pos=loops.pollLast().start-1;
      } else if (fn.equals("loop")) {println(nvars);println(vars);println(module.blocks);
        Block blk=module.blocks.get(module.pos);
        loops.addLast(blk);
        if (module.exprs.get(pos).eval()==0)
          module.pos=blk.end;
      } else if (fn.equals("game")) {
        choose_minigame(tokens);
      } else if (fn.equals("choice")&&!tokens[1].startsWith("=")) {
        line=join(tokens," ").substring(7);
        String[] ch=preprocess(line).split(";");
        state=new Choice(ch);
        module.pos++;
        break;
      } else if (fn.equals("splash")) {
        println(vars.get("Engine.text"));
        state=new Splash(preprocess(tokens.length>1?line.substring(6):""));
        module.pos++;
        break;
      } else if (fn.equals("char")) {
        String cm=tokens[1].trim();
        if (cm.contains("clear")) {
          chrs.clear();
          continue;
        }
        if (cm.equals("remove"))
          chrs.remove(chrs.indexOf(preprocess(tokens[2])));
        else if (cm.equals("add"))
          chrs.add(preprocess(tokens[2]));
        int s=0;
        for (String i:chrs) s+=imdata.get(i).width;
        avchr=s/chrs.size();
      } else if (fn.equals("toast")) {
        String[] args=line.substring(5).split(";");
        for (int i=0;i<args.length;i++)
          args[i]=preprocess(args[i].trim());
        if (args.length==2)
          toasts.add(new Toast(args[0],args[1],null));
        else if (args.length==3)
          toasts.add(new Toast(args[0],args[1],args[2]));
        else if (args.length==4)
          toasts.add(new Toast(args[0],args[1],args[2],args[3]));
      } else if (fn.equals("achievement")) {
        Achievement ach=achs.get(preprocess(tokens[1]));
        if (!ach.done)
          toasts.add(new Toast(ach.title,ach.body,ach.imgn,ach.intro));
        ach.done=true;
        saveAchievements();
      } else if (fn.equals("save")) {
        saveData(dataPath(preprocess(tokens[1].trim())));
      } else if (fn.equals("load")) {
        loadData(dataPath(preprocess(tokens[1].trim())));
      } else if (fn.equals("goto")) {
        //Module prev=module;
        modstack.add(module);
        module=mods.get(tokens[1].trim());
        //module.previous=prev;
        module.pos=-1;
        /*if (tokens.length>1)
          pos=int(tokens[2]);*/
      } else if (tokens[1].contains("=")) {
        println(module.exprs.get(pos));
        int idx=line.indexOf("=");
        nvars.put(line.substring(0,idx).trim(),float(line.substring(idx+1).trim()));
        println(nvars);
      } else if (line.contains("=\"")||
                 line.contains("='")) {
        int idx=line.indexOf("=");
        vars.put(line.substring(0,idx).trim(),line.substring(idx+2).trim());
        println(vars);
      }
    }
  }
}
  /*String eval(String expr) {
    String[] tokens = expr.replace("\\n","\n").split(" ");
    String fn=tokens[0].trim();
    if (fn.contains("choice")) {
      
    } else {
      if (tokens[1].contains("="))
        return tokens[0].trim().equals(tokens[2].trim())?"1":"0";
      else if (tokens[0].contains("numeric")) {
        float a=float(tokens[1]),
              b=float(tokens[3]);
        if (tokens[2].contains("<"))
          return a<b?"1":"0";
        else if (tokens[2].contains("<="))
          return a<=b?"1":"0";
        else if (tokens[2].contains(">"))
          return a>b?"1":"0";
        else if (tokens[2].contains(">="))
          return a>=b?"1":"0";
        else if (tokens[2].contains("="))
          return a==b?"1":"0";
        else throw new RuntimeException("Undefined `if` behaviour");
      }
    }
    return null;
  }*/
String preprocess(String str) {
  int l=-1;
  str=str.replace("\\n","\n");
  ArrayList<String> r=new ArrayList<String>();
  for (int i=0;i<str.length();i++) {
    if (str.charAt(i)=='{') {
      l=i;
    } else if (str.charAt(i)=='}') {
      r.add(str.substring(l,i+1));
      l=-1;
    }
  }
  for (String i:r) {
    String s=i.substring(1,i.length()-1);
    println(s);
    if (nvars.containsKey(s))
      str = str.replace(i,str(nvars.get(s)));
    else if (vars.containsKey(s))
      str = str.replace(i,vars.get(s));
    else
      throw new RuntimeException("Variable '"+s+"' not found");
  }
  return str;
}
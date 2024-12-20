class Engine {
  String text="";
  //String mod="main";
  Module module;
  HashMap<String,Module> mods=new HashMap<String,Module>();
  ArrayDeque<IfBlock> ifs=new ArrayDeque<IfBlock>();
  ArrayDeque<Block> loops=new ArrayDeque<Block>();
  Engine() {
    loadModules();println(mods);
    module=mods.get("main");
  }
  private void loadModules() {
    for (String name:new File(
        sketchPath("")).list())
      if (name.endsWith(".mod")) {
        String name_=name.substring(0,name.length()-4);
        mods.put(name_,
                 new Module(name_,loadStrings(name)));
    }
  }
  void step() {
    println("Step! Pos "+module.pos+" at",module.name);
    for (;;module.pos++) {
      int pos=module.pos;
      if (module.pos>=module.length) {
        if (module.previous==null) {
          screen=new Menu();
          return;
        } else {
          module=module.previous;
          continue;
        }
      }
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
        text=preprocess(join(tokens," ").substring(3));
      } else if (fn.equals("append")) {
        text+=preprocess(join(tokens," ").substring(7));
      } else if (fn.equals("bg")) {
        setbg(imdata.get(join(tokens,' ').substring(3)));
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
          pos=blk.els!=-1?blk.els:blk.end;
      } else if (fn.equals("else")) {
        pos=ifs.getLast().end;
      } else if (fn.equals("endif")) {
        ifs.pollLast();
      } else if (fn.equals("endloop")) {
        pos=loops.pollLast().start-1;
      } else if (fn.equals("loop")) {println(nvars);println(vars);
        Block blk=module.blocks.get(pos);
        loops.addLast(blk);
        if (module.exprs.get(pos).eval()==0)
          pos=blk.end;
      } else if (fn.equals("choice")) {
        line=join(tokens," ").substring(7);
        String[] ch=preprocess(line).split(";");
        state=new Choice(ch);
        module.pos++;
        break;
      } else if (fn.equals("char")) {
        String cm=tokens[1].trim();
        if (cm.contains("clear")) {
          chrs.clear();
          continue;
        }
        if (cm.equals("remove"))
          chrs.remove(chrs.indexOf(tokens[2]));
        else if (cm.equals("add"))
          chrs.add(tokens[2]);
        int s=0;
        for (String i:chrs) s+=imdata.get(i).width;
        avchr=s/chrs.size();
      } else if (fn.equals("goto")) {
        Module prev=module;
        module=mods.get(tokens[1].trim());
        module.previous=prev;
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
    if (nvars.containsKey(s))
      str = str.replace(i,str(nvars.get(s)));
    else if (vars.containsKey(s))
      str = str.replace(i,vars.get(s));
    else
      throw new RuntimeException("Variable '"+s+"' not found");
  }
  return str;
}
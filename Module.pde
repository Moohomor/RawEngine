class Module {
  HashMap<Integer,Block> blocks=new HashMap<Integer,Block>();
  HashMap<Integer,MathExpression> exprs=new HashMap<Integer,MathExpression>();
  String[] rows;
  int length;
  int pos=0;
  String name;
  Module previous=null;
  Module(String name_,String[] lines) {
    name=name_;
    rows=lines;
    int ifcnt=0,loopcnt=0;
    ArrayDeque<Integer>
    ifs=new ArrayDeque<Integer>(),
    elses=new ArrayDeque<Integer>(),
    loops=new ArrayDeque<Integer>();
    for (int i=0;i<rows.length;i++) {
      String trimmed=rows[i].trim();
      if (!(trimmed.startsWith("if")||
            trimmed.startsWith("endif")||
            trimmed.startsWith("else")||
            trimmed.contains("=")||
            trimmed.startsWith("loop")||
            trimmed.startsWith("endloop")||
            trimmed.startsWith("bg"))) continue;
      String[] tokens=trimmed.split(" ");
      if (tokens[0].trim().equals("bg")) {
        String name=join(tokens,' ').substring(3);
        imdata.put(name,loadImage(name));
        continue;
      }
      if (tokens[0].contains("endif")) {
        ifcnt--;
        if (ifcnt<0) throw new SyntaxError("Too many 'endif' tokens");
        int st=ifs.pollLast();
        blocks.put(st,new IfBlock(st,elses.size()==ifs.size()+1?elses.pollLast():-1,i));
      } else if (tokens[0].contains("if")) {
        ifs.add(i);
        ifcnt++;
      } else if (tokens[0].contains("else")) {
        elses.add(i);
      } else if (tokens[0].contains("endloop")) {
        loopcnt--;
        if (loopcnt<0) throw new SyntaxError("Too many 'endloop' tokens");
        int st=loops.pollLast();
        blocks.put(st,new Block(st,i));
      } else if (tokens[0].contains("loop")) {
        loops.add(i);
        loopcnt++;
      }
      
      if (tokens.length<2) continue;
      String joined=join(tokens," ");
      if (tokens[0].contains("if"))
        exprs.put(i,new MathExpression(joined.substring(joined.indexOf("if")+2)));
      else if (tokens[1].equals("="))
        exprs.put(i,new MathExpression(joined.substring(joined.indexOf("=")+2)));
      else if (tokens[0].contains("loop"))
        exprs.put(i,new MathExpression(joined.substring(joined.indexOf("loop")+4)));
    }
    if (ifcnt>0) throw new SyntaxError("Not enough 'endif' tokens");
    if (loopcnt>0) throw new SyntaxError("Not enough 'endloop' tokens");
    println(exprs);
    println(blocks);
    length=rows.length;
  }
}
class Block {
  int start,end;
  Block(int s,int e) {
    start=s;end=e;
  }
  @Override
  public String toString() {
    return "Block("+start+":"+end+")";
  }
}
class IfBlock extends Block {
  int els;
  IfBlock(int s,int el,int e) {
    super(s,e);
    els=el;
  }
  public String toString() {
    return "IfBlock("+start+":"+els+":"+end+")";
  }
}
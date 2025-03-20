static HashMap<String, Integer> opPriority=new HashMap<String,Integer>();
class MathExpression {
  ArrayList<String> rpn=new ArrayList<String>();
  ArrayDeque<String> texas=new ArrayDeque<String>();
  ArrayList<String> tokens=new ArrayList<String>();
  MathExpression(String expression) {
    expression=expression.replace(" ","");
    // tokenization
    String nb="", lb="";
    String prev="";
    for (char c:expression.toCharArray()) {
      if (Character.isDigit(c)||c=='.') nb+=c;
      else if (Character.isAlphabetic(c)||c=='"'||c=='"') {
        if (prev.equals("-"))
          tokens.add("_");
        lb+=c;
      }
      //else if ((c+"").matches("\\+|-|\\*|\\/")) {
      switch (c) {
        case '+':
        case '-':
        case '*':
        case '/':
        case '%':
        case '&':
        case '|':
        case '=':
        case '>':
        case '<':
        case '!':
        if (nb.equals("")) {
          tokens.add(lb);
          lb="";
        } else {
          tokens.add(nb);
          nb="";
        }
        tokens.add(c+"");break;
        /*case '!':
        tokens.add(c+"");*/
      }
      if (c=='(') {
        if (!lb.equals(""))
          tokens.add("f "+lb);
        if (prev.equals("-"))
          tokens.add("_");
        tokens.add("(");
        lb="";
      } else if (c==')') {
        if (!nb.equals(""))
          tokens.add(nb);
        else if (!lb.equals(""))
          tokens.add(lb);
        lb="";
        nb="";
        tokens.add(")");
      }
      else if (c==',') {
        if (!nb.equals(""))
          tokens.add(nb);
        else if (!lb.equals(""))
          tokens.add(lb);
        nb="";lb="";
        tokens.add(",");
      }
    }
    if (!nb.equals(""))
      tokens.add(nb);
    else if (!lb.equals(""))
      tokens.add(lb);
    //println(tokens);
    rpn();
  }
  void rpn() {
    // Shunting yard algorithm
    String prev="";
    for (String token:tokens) {
      //println("Token",token);
      /*for (String i:texas)
        print(i+" ");
      println();*/
      if (token.equals("")) continue;
      switch (tokenType(token)) {
      case DIGIT:
      case VARIABLE:
        rpn.add(token);
        break;
      case FUNCTION:
        texas.add(token);
        break;
      case SEPARATOR:
        while (gettx("SEP,")!="(") {
          if (texas.isEmpty())
            throw new RuntimeException("LEFT PARENTHESIS or COMMA is missing");
          tx2ca();
        }
        break;
      case OPERATOR:
        //println(token,opPriority.get(token),texas,rpn);
        while (!texas.isEmpty()&&tokenType(gettx("is op"))==TokenType.OPERATOR&&
            opPriority.get(token)<=
            opPriority.get(gettx("while OP priority"+token)))
          tx2ca();
        /*HashMap<String,String> mp=new HashMap<String,String>();
        mp.put("+","+");
        mp.put("*","*");
        mp.put("-","-");
        mp.put("/","/");
        mp.put("%","%");
        mp.put("&","&");
        mp.put("|","|");
        texas.add(mp.get(token));*/
      case LOPERATOR:
        texas.add(token);
        break;
      case LPARENTHESIS:
        if (prev.equals("-"))
          rpn.add("_");
        texas.add(token);
        break;
      case RPARENTHESIS:
        while (!tokenType(gettx("RPAR)")).equals(TokenType.LPARENTHESIS)) {
          //println(texas.getLast());
          if (texas.isEmpty())
            throw new RuntimeException("LEFT PARENTHESIS is missing");
          tx2ca();
        }
        texas.pollLast();
        if (tokenType(gettx("RPAR) Is func"))==TokenType.FUNCTION)
          tx2ca();
        break;
      }
      prev=token;
    }
    while (!texas.isEmpty()) {
      if (gettx("PUSH OUT REMAINING ITEMS").equals("("))
        throw new RuntimeException("LEFT PARENTHESIS is missing");
      tx2ca();
    }
    //println(rpn);
    //print(texas,rpn);
    //if (gettx("ENDING").equals("("))
    //  throw new RuntimeException("LEFT PARENTHESIS is missing");
    
  }
  public float eval() {
    ArrayDeque<String> estk=new ArrayDeque<String>();
    float n;
    for (String i:rpn) {
      if (i.equals("")) continue;
      switch (tokenType(i)) {
      case DIGIT:
      case VARIABLE:
        estk.add(i);
        break;
      case OPERATOR:
        String bb=_ref(estk.pollLast()),
               aa=_ref(estk.pollLast());
        /*if (tokenType(bb)==TokenType.VARIABLE)
          bb=vars.get(bb);
        if (tokenType(aa)==TokenType.VARIABLE)
          aa=vars.get(aa);*/
        println(aa,bb,i);
        if (!isDigit(bb)||!isDigit(aa)) {
          println("are str");
          String r=null;
          if (i.contains("=")) r=bb.equals(aa)?"1":"0";
          estk.addLast(r);
          break;
        }
        float b=float(bb),
              a=float(aa);
        boolean p=(a!=0),q=(b!=0);
        n=0;
             if (i.equals("+")) n=a+b;
        else if (i.equals("-")) n=a-b;
        else if (i.equals("*")) n=a*b;
        else if (i.equals("/")) {
          if (b==0)
            throw new ZeroDivisionException();
          n=a/b;
      } else if (i.equals("%")) n=a%b;
        else if (i.equals(">")) n=int(a>b);
        else if (i.equals("<")) n=int(a<b);
        else if (i.equals("&")) n=int(p&&q);
        else if (i.equals("|")) n=int(p||q);
        else if (i.equals("=")) n=int(a==b);
        //println("Numeric",n,a,b,i.equals("+"));
        estk.add(str(n));
        break;
      case LOPERATOR:
        n=0;
        if (i.equals("!")) n=int(float(_ref(estk.pollLast()))==0);
        estk.add(str(n));
        break;
      case FUNCTION:
        n=0;
        String f=i.substring(2);
        println("'"+f+"'",estk.getLast());
        float x=float(_ref(estk.pollLast()));
      //       a=estk.pollLast();
             if (f.equals("cos")) n=cos(x);
        else if (f.equals("sin")) n=sin(x);
        else if (f.equals("log")) n=log(x)/log(float(estk.pollLast()));
        else if (f.equals("sqrt")) n=sqrt(x);
        estk.add(str(n));
      }
    }
    return float(estk.getLast());
  }
  void tx2ca() {
    rpn.add(texas.pollLast());
  }
  private String _ref(String s) {
    s=s.trim();
    if (s.startsWith("\"")&&s.endsWith("\""))
      return s.substring(1,s.length()-1);
    if (isDigit(s))
      return s;
    if (nvars.containsKey(s))
      return str(nvars.get(s));
    if (!vars.containsKey(s))
      throw new RuntimeException("Variable "+s+" not found");
    return vars.get(s);
  }
  String gettx(String msg) {//println(msg);
    //if (texas.isEmpty()) println("err");
    return texas.getLast();
  }
  @Override
  public String toString() {
    String[] str=new String[rpn.size()];
    for (int i=0;i<str.length;i++)
      str[i]=rpn.get(i);
    return "MathParser("+join(str," ")+")";
  }
}
TokenType tokenType(String token) {
  if ("".equals(token)) return null;
  if (isDigit(token)) return TokenType.DIGIT;
  if (token.contains(",")) return TokenType.SEPARATOR;
  //if (token.matches("\\+|-|\\*||\\/|&|\\|")) return TokenType.OPERATOR;
  if (token.startsWith("f ")) return TokenType.FUNCTION;
  if (token.contains("(")) return TokenType.LPARENTHESIS;
  if (token.contains(")")) return TokenType.RPARENTHESIS;
  switch (token.charAt(0)) {
    case '+':
    case '-':
    case '*':
    case '/':
    case '%':
    case '&':
    case '|':
    case '=':
    case '≠':
    case '>':
    case '<':
    return TokenType.OPERATOR;
    case '!':
    case '_':
    return TokenType.LOPERATOR;
  }
  return TokenType.VARIABLE;
}
enum TokenType {
  DIGIT, SEPARATOR, OPERATOR, LOPERATOR, FUNCTION, LPARENTHESIS, RPARENTHESIS, VARIABLE
}
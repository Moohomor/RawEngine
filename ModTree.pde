void dfsMods(String name_) {
  String name=name_.trim()+".mod";
  String[] lines=loadStrings(name);
  mods.put(name_,
           new Module(name_,lines));
  for (String ln:lines) {
    ln=ln.trim();
    String[] splitten=ln.split(" ");
    //println(splitten[0]);
    if (splitten.length>1&&
        splitten[0].contains("goto")) {
      String m=ln.substring(ln.indexOf(" ")).trim();
      if (!mods.containsKey(m))
        dfsMods(m);
    }
  }
}
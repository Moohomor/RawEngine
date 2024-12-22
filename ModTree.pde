void dfsMods(String name_) {
  String name=name_+".mod";
  String[] lines=loadStrings(name);
  //println(lines);
  mods.put(name_,
           new Module(name_,lines));
  for (String ln:lines) {
    if (ln.split(" ")[0].trim().contains("goto")) {
      String m=ln.substring(ln.indexOf(" ")).trim();
      if (!mods.containsKey(m))
        dfsMods(m);
    }
  }
}
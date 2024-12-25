void saveData(String path) {
  JSONObject json=new JSONObject();
  JSONObject nv=new JSONObject(),
             vr=new JSONObject();
  for (String i:nvars.keySet())
    nv.setFloat(i,nvars.get(i));
  for (String i:vars.keySet())
    vr.setString(i,vars.get(i));
  json.setJSONObject("nvars",nv);
  json.setJSONObject("vars",vr);
  JSONArray array=new JSONArray();
  int i=0;
  for (Module mod:modstack) {
    JSONObject item=new JSONObject();
    item.setString("name",mod.name);
    item.setInt("pos",mod.pos);
    array.setJSONObject(i,item);
    i++;
  }
  json.setJSONArray("modstack",array);
  json.setString("current_mod",engine.module.name);
  json.setInt("current_pos",engine.module.pos);
  saveJSONObject(json,path);
  println("Saved");
  println(json);
}

void loadData(String path) {
  modstack.clear();
  JSONObject json=loadJSONObject(path);
  println(json);
  JSONArray array=new JSONArray();
  for (int i=0;i<array.size();i++) {
    JSONObject item=array.getJSONObject(i);
    Module mod=mods.get(item.getString("name"));
    mod.pos=item.getInt("pos");
    modstack.add(mod);
  }
  JSONObject vr=json.getJSONObject("vars");
  vars.clear();
  for (Object nm:vr.keys())
    vars.put((String)nm,vr.getString((String)nm));
    
  JSONObject nv=json.getJSONObject("nvars");
  nvars.clear();
  for (Object nm:nv.keys())
    nvars.put((String)nm,nv.getFloat((String)nm));
  engine.module=mods.get(json.getString("current_mod"));
  engine.module.pos=json.getInt("current_pos");
  println("Loaded");
  println(json);
}
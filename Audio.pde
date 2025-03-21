import android.media.MediaPlayer;
import android.content.res.AssetFileDescriptor;
class PAudio {
  MediaPlayer player;
  PAudio(String path) {
    try {
      AssetFileDescriptor desc = getActivity().getApplicationContext().getAssets().openFd(path);
      player = new MediaPlayer();
      player.setDataSource(desc.getFileDescriptor(),desc.getStartOffset(),desc.getLength());
      player.setLooping(true);
      player.prepare();
    } catch (IOException ex) {
      String err_msg="Audio file "+path+" not found";
      if (STRICT_AUDIO)
        throw new RuntimeException(err_msg);
      else println(err_msg);
    }
  }
  void start() {
    println("Start playing. Player exists:",player!=null);
    if (player!=null)
      player.start();
  }
  void pause() {
    if (player!=null)
      player.pause();
  }
  void stop() {
    println("Stop playing");
    if (player!=null)
      player.stop();
  }
  boolean isPlaying() {
    return player==null||player.isPlaying();
  }
}
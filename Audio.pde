import android.media.MediaPlayer;
import android.content.res.AssetFileDescriptor;
class PAudio {
  MediaPlayer player;
  PAudio(String path) {
    try {
      AssetFileDescriptor desc = getActivity().getApplicationContext().getAssets().openFd(path);
      player = new MediaPlayer();
      player.setDataSource(desc.getFileDescriptor(),desc.getStartOffset(),desc.getLength());
      player.prepare();
    } catch (IOException ex) {
      if (STRICT_AUDIO)
        throw new RuntimeException("File "+path+" not found");
    }
  }
  void start() {
    if (player!=null)
      player.start();
  }
  void pause() {
    if (player!=null)
      player.pause();
  }
  void stop() {
    if (player!=null)
      player.stop();
  }
  boolean isPlaying() {
    return player==null||player.isPlaying();
  }
}
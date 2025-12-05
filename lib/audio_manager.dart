
import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  AudioManager._();
  static final instance = AudioManager._();
  final AudioPlayer _p = AudioPlayer();

  Future<void> startBackground() async {
    await _p.setReleaseMode(ReleaseMode.loop);
    await _p.play(AssetSource('audio/casino_loop.wav'), volume: 0.1);
  }
}

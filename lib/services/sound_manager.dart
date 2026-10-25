import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Procedurally generated soundscape per vibe (see /assets/sounds).
/// Files are 12-second seamless loops, mono OGG, generated with numpy.
const Map<String, String> vibeSounds = {
  'midnight': 'sounds/midnight.ogg',
  'sunset': 'sounds/sunset.ogg',
  'lofi': 'sounds/lofi.ogg',
  'neon': 'sounds/neon.ogg',
  'forest': 'sounds/forest.ogg',
  'candy': 'sounds/candy.ogg',
  'space': 'sounds/space.ogg',
  'campfire': 'sounds/campfire.ogg',
  'aurora': 'sounds/aurora.ogg',
};

/// App-wide singleton for ambient playback.
/// Keeps playing across screens, honors the mute preference.
class SoundManager {
  SoundManager._();

  static final SoundManager instance = SoundManager._();

  static const String _mutePrefsKey = 'sound_muted';
  static const double _volume = 0.35;

  final AudioPlayer _player = AudioPlayer(playerId: 'vibe_ambient');
  bool _muted = false;
  bool _loadedPrefs = false;

  bool get muted => _muted;

  Future<void> _ensurePrefs() async {
    if (_loadedPrefs) return;
    final prefs = await SharedPreferences.getInstance();
    _muted = prefs.getBool(_mutePrefsKey) ?? false;
    _loadedPrefs = true;
  }

  /// Starts looping the soundscape of [vibeId].
  /// Always starts the source; muting is handled via volume,
  /// so toggling mute is instant.
  Future<void> playVibe(String vibeId) async {
    await _ensurePrefs();
    final path = vibeSounds[vibeId];
    if (path == null) return;
    try {
      await _player.stop();
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.setVolume(_muted ? 0.0 : _volume);
      await _player.play(AssetSource(path));
    } catch (_) {
      // Audio is a nice-to-have — never crash the vibe over it.
    }
  }

  /// Flips mute state, persists it and applies immediately.
  Future<void> toggleMute() async {
    await _ensurePrefs();
    _muted = !_muted;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_mutePrefsKey, _muted);
    try {
      await _player.setVolume(_muted ? 0.0 : _volume);
    } catch (_) {}
  }

  Future<void> stop() async {
    try {
      await _player.stop();
    } catch (_) {}
  }
}

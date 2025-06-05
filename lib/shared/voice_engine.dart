import 'package:flutter_tts/flutter_tts.dart';

class VoiceEngine {
  static final VoiceEngine _instance = VoiceEngine._internal();
  final FlutterTts _tts = FlutterTts();
  
  // 用於測試的標誌
  static bool testing = false;

  factory VoiceEngine() {
    return _instance;
  }

  VoiceEngine._internal() {
    if (!testing) {
      _initTTS();
    }
  }

  Future<void> _initTTS() async {
    await _tts.setLanguage('zh-TW');
    await _tts.setSpeechRate(1.0);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
  }

  Future<void> speak(String text) async {
    await _tts.speak(text);
  }

  Future<void> stop() async {
    await _tts.stop();
  }

  Future<void> setSpeed(double speed) async {
    await _tts.setSpeechRate(speed);
  }
}

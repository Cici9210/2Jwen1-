import 'package:dotnav/shared/voice_engine.dart';

class ErrorFeedback {
  static final ErrorFeedback _instance = ErrorFeedback._internal();
  final VoiceEngine _voice = VoiceEngine();

  factory ErrorFeedback() {
    return _instance;
  }

  ErrorFeedback._internal();

  Future<void> handleInvalidCode() async {
    await _voice.speak('輸入的編號格式不正確，請重新輸入');
  }
  Future<void> handleNoData() async {
    await _voice.speak('抱歉，找不到相關商品資訊');
  }

  Future<void> handleVoiceInputError() async {
    await _voice.speak('語音辨識失敗，請重新說一次');
  }

  Future<void> handleNetworkError() async {
    await _voice.speak('抱歉，讀取資料時發生錯誤，請稍後再試');
  }

  Future<void> handleDataLoadError() async {
    await _voice.speak('資料載入失敗，請確認資料格式是否正確');
  }
}

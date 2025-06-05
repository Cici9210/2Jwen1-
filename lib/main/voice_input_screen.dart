import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../shared/voice_engine.dart';
import '../shared/error_feedback.dart';
import '../shared/braille_map_utils.dart';

class VoiceInputScreen extends StatefulWidget {
  const VoiceInputScreen({super.key});

  @override
  State<VoiceInputScreen> createState() => _VoiceInputScreenState();
}

class _VoiceInputScreenState extends State<VoiceInputScreen> {
  final SpeechToText _speech = SpeechToText();
  final VoiceEngine _voice = VoiceEngine();
  final ErrorFeedback _error = ErrorFeedback();
  final BrailleMapUtils _brailleUtils = BrailleMapUtils();
  bool _isListening = false;
  String _text = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    bool available = await _speech.initialize(
      onStatus: (status) => print('語音識別狀態: $status'),
      onError: (error) => print('語音識別錯誤: $error'),
    );

    if (available) {
      await _voice.speak('請說出想要查詢的區號，例如：B12');
    } else {
      await _error.handleVoiceInputError();
    }
  }

  Future<void> _listen() async {
    if (!_isListening) {
      bool available = await _speech.listen(
        localeId: 'zh_TW',
        onResult: (result) {
          setState(() {
            _text = result.recognizedWords;
          });
          
          if (result.finalResult) {
            _processVoiceInput(_text);
          }
        },
      );

      setState(() {
        _isListening = available;
      });
    } else {
      setState(() {
        _isListening = false;
      });
      _speech.stop();
    }
  }

  Future<void> _processVoiceInput(String input) async {
    // 移除所有空格並轉換為大寫
    String cleanInput = input.replaceAll(' ', '').toUpperCase();
    
    if (_brailleUtils.isValidCode(cleanInput)) {
      Navigator.pushNamed(context, '/product-info', arguments: cleanInput);
    } else {
      await _error.handleInvalidCode();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('語音輸入'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _text.isEmpty ? '點擊麥克風開始說話' : _text,
              style: const TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            FloatingActionButton(
              onPressed: _listen,
              child: Icon(_isListening ? Icons.mic_off : Icons.mic),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }
}

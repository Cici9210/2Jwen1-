import 'package:flutter/material.dart';
import 'package:dotnav/shared/voice_engine.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final VoiceEngine _voice = VoiceEngine();

  @override
  void initState() {
    super.initState();
    _playWelcomeMessage();
  }

  Future<void> _playWelcomeMessage() async {
    await _voice.speak('歡迎使用數字點點導引系統，請點擊畫面任意處開始使用');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => Navigator.pushReplacementNamed(context, '/home'),
        child: Container(
          width: double.infinity,
          color: Colors.white,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '數字點點導引系統',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '點擊畫面任意處開始使用',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

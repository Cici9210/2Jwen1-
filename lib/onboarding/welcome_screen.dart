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
    await _voice.speak('歡迎使用摸索點點導引系統，請點擊畫面任意處開始使用');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => Navigator.pushReplacementNamed(context, '/home'),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.primary.withOpacity(0.8),
                Theme.of(context).colorScheme.primary,
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.location_searching,
                  size: 80,
                  color: Colors.white,
                ),
                const SizedBox(height: 30),
                const Text(
                  '摸索點點導引系統',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    '點擊畫面任意處開始使用',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.touch_app, color: Colors.white70),
                    SizedBox(width: 8),
                    Text(
                      '智能商場導覽',
                      style: TextStyle(color: Colors.white70),
                    ),
                    SizedBox(width: 20),
                    Icon(Icons.accessibility_new, color: Colors.white70),
                    SizedBox(width: 8),
                    Text(
                      '無障礙設計',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

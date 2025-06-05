import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../shared/voice_engine.dart';

class AccessibilitySettingsScreen extends StatefulWidget {
  const AccessibilitySettingsScreen({super.key});

  @override
  State<AccessibilitySettingsScreen> createState() =>
      _AccessibilitySettingsScreenState();
}

class _AccessibilitySettingsScreenState extends State<AccessibilitySettingsScreen> {
  final VoiceEngine _voice = VoiceEngine();
  late SharedPreferences _prefs;
  double _voiceSpeed = 1.0;
  double _fontSize = 1.0;
  bool _vibrationEnabled = true;

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() {
      _voiceSpeed = _prefs.getDouble('voice_speed') ?? 1.0;
      _fontSize = _prefs.getDouble('font_size') ?? 1.0;
      _vibrationEnabled = _prefs.getBool('vibration_enabled') ?? true;
    });
  }

  Future<void> _saveSettings() async {
    await _prefs.setDouble('voice_speed', _voiceSpeed);
    await _prefs.setDouble('font_size', _fontSize);
    await _prefs.setBool('vibration_enabled', _vibrationEnabled);
    await _voice.setSpeed(_voiceSpeed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('無障礙設定'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            '語音速度',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Slider(
            value: _voiceSpeed,
            min: 0.5,
            max: 2.0,
            divisions: 15,
            label: _voiceSpeed.toString(),
            onChanged: (value) {
              setState(() => _voiceSpeed = value);
            },
            onChangeEnd: (value) async {
              await _saveSettings();
            },
          ),
          const Divider(),
          const Text(
            '字體大小',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Slider(
            value: _fontSize,
            min: 0.8,
            max: 2.0,
            divisions: 12,
            label: _fontSize.toString(),
            onChanged: (value) {
              setState(() => _fontSize = value);
            },
            onChangeEnd: (value) async {
              await _saveSettings();
            },
          ),
          const Divider(),
          SwitchListTile(
            title: const Text(
              '震動回饋',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            value: _vibrationEnabled,
            onChanged: (bool value) async {
              setState(() => _vibrationEnabled = value);
              await _saveSettings();
            },
          ),
        ],
      ),
    );
  }
}

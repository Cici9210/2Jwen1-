import 'package:flutter/material.dart';
import '../shared/voice_engine.dart';
import '../shared/error_feedback.dart';
import '../shared/braille_map_utils.dart';

class SearchByCodeScreen extends StatefulWidget {
  const SearchByCodeScreen({super.key});

  @override
  State<SearchByCodeScreen> createState() => _SearchByCodeScreenState();
}

class _SearchByCodeScreenState extends State<SearchByCodeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final BrailleMapUtils _brailleUtils = BrailleMapUtils();
  final VoiceEngine _voice = VoiceEngine();
  final ErrorFeedback _error = ErrorFeedback();

  @override
  void initState() {
    super.initState();
    _playInstructions();
  }

  Future<void> _playInstructions() async {
    await _voice.speak('請輸入區域代號，例如：B12');
  }

  void _submitCode() async {
    if (_formKey.currentState!.validate()) {
      String code = _codeController.text.toUpperCase();
      if (_brailleUtils.isValidCode(code)) {
        Navigator.pushNamed(context, '/product-info', arguments: code);
      } else {
        await _error.handleInvalidCode();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('手動輸入'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: '區域代號',
                  hintText: '例如：B12',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.characters,
                style: const TextStyle(fontSize: 24),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '請輸入區域代號';
                  }
                  if (!_brailleUtils.isValidCode(value.toUpperCase())) {
                    return '請輸入正確的格式（例如：B12）';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitCode,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                child: const Text('查詢'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }
}

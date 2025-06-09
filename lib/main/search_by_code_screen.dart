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
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  const Text(
                    '請輸入區域代碼',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _codeController,
                            decoration: InputDecoration(
                              labelText: '區域代號',
                              hintText: '例如：A01',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                              prefixIcon: const Icon(Icons.location_on),
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                            ),
                            textCapitalization: TextCapitalization.characters,
                            style: const TextStyle(fontSize: 24),
                            textAlign: TextAlign.center,
                            validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '請輸入區域代號';
                  }
                  if (!_brailleUtils.isValidCode(value.toUpperCase())) {
                    return '請輸入正確的格式（例如：B12）';
                  }                  return null;
                },
                onFieldSubmitted: (_) => _submitCode(),
              ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton.icon(
                              onPressed: _submitCode,
                              icon: const Icon(Icons.search, size: 28),
                              label: const Text(
                                '查詢',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              '輸入位於商品旁的區域代碼',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '例如：A01',
                          style: TextStyle(
                            fontSize: 24,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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

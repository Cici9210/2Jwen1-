import 'package:flutter/material.dart';
import '../data/api_service.dart';
import '../data/models.dart';
import '../shared/voice_engine.dart';
import '../shared/error_feedback.dart';
import '../shared/braille_map_utils.dart';

class ProductInfoScreen extends StatefulWidget {
  final String areaCode;

  const ProductInfoScreen({
    super.key,
    required this.areaCode,
  });

  @override
  State<ProductInfoScreen> createState() => _ProductInfoScreenState();
}

class _ProductInfoScreenState extends State<ProductInfoScreen> {
  final ApiService _api = ApiService();
  final VoiceEngine _voice = VoiceEngine();
  final ErrorFeedback _error = ErrorFeedback();
  final BrailleMapUtils _brailleUtils = BrailleMapUtils();
  Area? _areaInfo;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAreaInfo();
  }

  Future<void> _loadAreaInfo() async {
    try {
      final areaInfo = await _api.getAreaInfo(widget.areaCode);
      setState(() {
        _areaInfo = areaInfo;
        _isLoading = false;
      });

      if (areaInfo != null) {
        String message = '${_brailleUtils.getLocationDescription(widget.areaCode)}，'
            '這裡是${areaInfo.category}區，有以下商品：';
        for (var product in areaInfo.products) {
          message += '${product.name}，售價${product.price}元。';
        }
        await _voice.speak(message);
      } else {
        await _error.handleNoData();
      }
    } catch (e) {
      setState(() => _isLoading = false);
      await _error.handleNetworkError();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.areaCode} 區域資訊'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _areaInfo == null
              ? const Center(child: Text('找不到相關資訊'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '類別：${_areaInfo!.category}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        '商品列表：',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _areaInfo!.products.length,
                          itemBuilder: (context, index) {
                            final product = _areaInfo!.products[index];
                            return Card(
                              child: ListTile(
                                title: Text(product.name),
                                subtitle: Text('價格：\$${product.price}'),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}

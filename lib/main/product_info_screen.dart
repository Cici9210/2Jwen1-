import 'package:flutter/material.dart';
import '../data/api_service.dart';
import '../data/models.dart';
import '../shared/voice_engine.dart';

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
  final ApiService _apiService = ApiService();
  final VoiceEngine _voice = VoiceEngine();
  Area? _area;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAreaInfo();
  }
  Future<void> _loadAreaInfo() async {
    try {
      print('Searching for area code: ${widget.areaCode}');
      final area = await _apiService.getAreaInfo(widget.areaCode);
      print('Area found: $area');
      setState(() {
        _area = area;
        _isLoading = false;
        if (area == null) {
          final errorMessage = '找不到代碼為 ${widget.areaCode} 的區域';
          _error = errorMessage;
          _voice.speak(errorMessage);
        } else {
          _speakAreaInfo(area);
        }
      });    } catch (e) {
      print('Error in ProductInfoScreen: $e');
      final errorMessage = '搜尋區域時發生錯誤';
      setState(() {
        _error = errorMessage;
        _isLoading = false;
      });
      _voice.speak(errorMessage);
    }
  }
  
  Future<void> _speakAreaInfo(Area area) async {
    String speechText = '已找到${area.name}。${area.description}。';
    if (area.products.isNotEmpty) {
      speechText += '此區域有${area.products.length}項商品，包括';
      for (int i = 0; i < area.products.length; i++) {
        final product = area.products[i];
        speechText += '${product.name}，位於${product.location}';
        if (i < area.products.length - 1) {
          speechText += '，';
        } else {
          speechText += '。';
        }
      }
    }    await _voice.speak(speechText);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('商品資訊'),
        centerTitle: true,
        elevation: 0,
      ),
      body: _isLoading 
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                    strokeWidth: 3,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  '正在搜尋區域資訊...',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          )
        : _error != null
          ? Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.red.withOpacity(0.1),
                    Colors.white,
                  ],
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 80,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        _error!,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('返回', style: TextStyle(fontSize: 18)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )          : _area == null
            ? const Center(
                child: Text(
                  '找不到該區域資訊',
                  style: TextStyle(fontSize: 20),
                ),
              )
            : Container(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 頂部區域資訊卡片
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.primary.withBlue(220),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '代碼: ${_area!.code}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  icon: const Icon(Icons.volume_up, color: Colors.white),
                                  tooltip: '語音讀取區域資訊',
                                  onPressed: () {
                                    _speakAreaInfo(_area!);
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _area!.name,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _area!.description,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),                          ],
                        ),
                      ),
                    ),
                    
                    // 商品列表標題
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                      child: Text(
                        '商品列表',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    
                    // 商品列表
                    Expanded(
                      child: _area!.products.isEmpty
                          ? const Center(child: Text('此區域沒有商品'))
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              itemCount: _area!.products.length,
                              itemBuilder: (context, index) {
                                final product = _area!.products[index];
                                return Card(
                                  elevation: 4,
                                  margin: const EdgeInsets.only(bottom: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(16),
                                    onTap: () {
                                      _voice.speak('${product.name}，位於${product.location}，${product.description}');
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Center(
                                              child: Text(
                                                product.location,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Theme.of(context).colorScheme.primary,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  product.name,
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  product.description,
                                                  style: TextStyle(
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),                                          IconButton(
                                            icon: const Icon(Icons.volume_up),
                                            tooltip: '語音讀取商品資訊',
                                            onPressed: () {
                                              _voice.speak('${product.name}，位於${product.location}，${product.description}');
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
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
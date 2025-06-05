import 'package:flutter/material.dart';
import '../data/api_service.dart';
import '../data/models.dart';

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
  Area? _area;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAreaInfo();
  }

  Future<void> _loadAreaInfo() async {    try {
      print('Searching for area code: ${widget.areaCode}');
      final area = await _apiService.getAreaInfo(widget.areaCode);
      print('Area found: $area');
      setState(() {
        _area = area;
        _isLoading = false;
        if (area == null) {
          _error = '找不到代碼為 ${widget.areaCode} 的區域';
        }
      });
    } catch (e) {
      print('Error in ProductInfoScreen: $e');
      setState(() {
        _error = '搜尋區域時發生錯誤：$e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('商品資訊'),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : _error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _error!,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('返回'),
                  ),
                ],
              ),
            )
          : _area == null
            ? const Center(child: Text('找不到該區域資訊'))
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '區域：${_area!.name}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '代碼：${_area!.code}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '描述：${_area!.description}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '商品列表：',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _area!.products.length,
                        itemBuilder: (context, index) {
                          final product = _area!.products[index];
                          return Card(
                            child: ListTile(
                              title: Text(product.name),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('位置：${product.location}'),
                                  Text('描述：${product.description}'),
                                ],
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
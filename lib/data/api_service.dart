import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../data/models.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  Map<String, Area>? _localData;

  factory ApiService() {
    return _instance;
  }

  ApiService._internal();
  Future<void> _loadLocalData() async {
    if (_localData != null) return;

    try {
      final String jsonString = await rootBundle.loadString('assets/data/LocalCodeDB.json');
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      
      _localData = jsonMap.map((key, value) => 
        MapEntry(key, Area.fromJson(value as Map<String, dynamic>))
      );
    } catch (e) {
      print('Error loading local data: $e');
      rethrow;
    }
  }

  Future<Area?> getAreaInfo(String code) async {
    try {
      await _loadLocalData();
      return _localData?[code];
    } catch (e) {
      print('Error getting area info: $e');
      rethrow;
    }
  }

  // 未來可擴充連接後台API的方法
  Future<void> syncWithBackend() async {
    // TODO: 實作與後台同步的邏輯
  }
}

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../data/models.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  Map<String, Area>? _localData;

  factory ApiService() {
    return _instance;
  }

  ApiService._internal();  Future<void> _loadLocalData() async {
    if (_localData != null) return;

    try {
      const String assetPath = 'assets/data/LocalCodeDB.json';
      String jsonString;
      try {
        jsonString = await rootBundle.loadString(assetPath);
      } catch (e) {
        print('Error loading asset: $e');
        rethrow;
      }
      
      if (jsonString.isEmpty) {
        throw Exception('JSON file is empty');
      }
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      final List<dynamic> areas = jsonMap['areas'] as List<dynamic>;
      
      _localData = {};
      for (final area in areas) {
        final Area areaObj = Area.fromJson(area as Map<String, dynamic>);
        print('Loaded area: ${areaObj.code}');
        _localData![areaObj.code] = areaObj;
      }
      print('Local data loaded successfully');
    } catch (e) {
      print('Error loading local data: $e');
      print('Stack trace: ${StackTrace.current}');
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

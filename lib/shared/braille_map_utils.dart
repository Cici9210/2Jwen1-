class BrailleMapUtils {
  static final BrailleMapUtils _instance = BrailleMapUtils._internal();

  factory BrailleMapUtils() {
    return _instance;
  }

  BrailleMapUtils._internal();

  bool isValidCode(String code) {
    // 檢查編碼格式是否正確（例如：A01, B12 等）
    final RegExp codeFormat = RegExp(r'^[A-Z]\d{2}$');
    return codeFormat.hasMatch(code);
  }

  // 可以添加更多點字相關的工具方法
  String getLocationDescription(String code) {
    // 根據編碼提供位置描述
    String area = code[0];
    String number = code.substring(1);
    return '在$area區${number}號位置';
  }
}

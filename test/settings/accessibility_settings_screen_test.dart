import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dotnav/settings/accessibility_settings_screen.dart';
import 'package:dotnav/shared/voice_engine.dart';

void main() {  group('AccessibilitySettingsScreen', () {
    late Widget testWidget;

    setUpAll(() {
      // 設置 VoiceEngine 為測試模式
      VoiceEngine.testing = true;
    });

    setUp(() async {
      // 設置 SharedPreferences 模擬數據
      SharedPreferences.setMockInitialValues({
        'voice_speed': 1.5,
        'font_size': 1.2,
        'vibration_enabled': true,
      });

      testWidget = const MaterialApp(
        home: AccessibilitySettingsScreen(),
      );
    });

    testWidgets('應該正確載入已保存的設定', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      // 等待異步操作完成
      await tester.pumpAndSettle();

      // 驗證語音速度滑桿
      final voiceSpeedSlider = find.byType(Slider).first;
      expect(
        (voiceSpeedSlider.evaluate().first.widget as Slider).value,
        1.5,
      );

      // 驗證字體大小滑桿
      final fontSizeSlider = find.byType(Slider).at(1);
      expect(
        (fontSizeSlider.evaluate().first.widget as Slider).value,
        1.2,
      );

      // 驗證震動開關
      final vibrationSwitch = find.byType(Switch);
      expect(
        (vibrationSwitch.evaluate().first.widget as Switch).value,
        true,
      );
    });

    testWidgets('應該能夠調整語音速度', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      // 找到語音速度滑桿
      final slider = find.byType(Slider).first;
      
      // 模擬滑動操作
      await tester.drag(slider, const Offset(50.0, 0.0));
      await tester.pumpAndSettle();

      // 驗證新的值已被保存
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getDouble('voice_speed'), isNot(1.5));
    });

    testWidgets('應該能夠切換震動設定', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      // 找到震動開關
      final switchTile = find.byType(SwitchListTile);
      
      // 點擊切換
      await tester.tap(switchTile);
      await tester.pumpAndSettle();

      // 驗證新的值已被保存
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('vibration_enabled'), false);
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'main/home_screen.dart';
import 'main/product_info_screen.dart';
import 'main/search_by_code_screen.dart';
import 'main/voice_input_screen.dart';
import 'onboarding/welcome_screen.dart';
import 'settings/accessibility_settings_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '數字點點導引系統',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('zh', 'TW'),
        Locale('en', 'US'),
      ],
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (context) => const WelcomeScreen(),
            );
          case '/home':
            return MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            );
          case '/search':
            return MaterialPageRoute(
              builder: (context) => const SearchByCodeScreen(),
            );
          case '/voice-input':
            return MaterialPageRoute(
              builder: (context) => const VoiceInputScreen(),
            );
          case '/product-info':
            return MaterialPageRoute(
              builder: (context) => ProductInfoScreen(
                areaCode: settings.arguments as String,
              ),
            );
          case '/settings':
            return MaterialPageRoute(
              builder: (context) => const AccessibilitySettingsScreen(),
            );
          default:
            return MaterialPageRoute(
              builder: (context) => const WelcomeScreen(),
            );
        }
      },
    );
  }
}

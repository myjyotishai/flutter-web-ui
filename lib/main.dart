import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'screens/home.dart';
import 'screens/login.dart';
import 'screens/rashifal.dart';
import 'screens/palm_reader.dart';
import 'screens/face_reader.dart';
import 'screens/marketplace.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: JyotishAIApp(),
    ),
  );
}

class JyotishAIApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JyotishAI',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.deepPurple,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
      ),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/rashifal': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          final language = args?['language'] ?? 'English';
          return RashifalScreen(language: language);
        },
        '/palm': (context) => PalmReaderScreen(),
        '/face': (context) => FaceReaderScreen(),
        '/marketplace': (context) {
         final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
         final language = args?['language'] ?? 'English';
         return MarketplaceScreen(language: language);
      },
      },
    );
  }
}

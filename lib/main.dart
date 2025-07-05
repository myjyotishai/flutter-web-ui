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
  runApp(ChangeNotifierProvider(
    create: (_) => AppState(),
    child: JyotishAIApp(),
  ));
}

class JyotishAIApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JyotishAI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      initialRoute: '/login',
      routes: {
        '/': (_) => HomeScreen(),
        '/login': (_) => LoginScreen(),
        '/rashifal': (_) => RashifalScreen(),
        '/palm': (_) => PalmReaderScreen(),
        '/face': (_) => FaceReaderScreen(),
        '/marketplace': (_) => MarketplaceScreen(),
      },
    );
  }
}

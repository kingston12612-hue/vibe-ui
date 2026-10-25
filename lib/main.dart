import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const VibeUiApp());
}

class VibeUiApp extends StatelessWidget {
  const VibeUiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vibe UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

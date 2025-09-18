// lib/main.dart (cuplikan)
import 'package:flutter/material.dart';
import 'presentation/pages/root/root_scaffold.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resep',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFFF2B949), // seed dari warna aksen kamu
      ),
      home: const RootScaffold(),
    );
  }
}

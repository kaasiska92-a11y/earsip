import 'package:flutter/material.dart';
import 'package:manejemen_surat/widgets/navigasi.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'e-Arsip DPRD',
      home: MainPage(),
    );
  }
}


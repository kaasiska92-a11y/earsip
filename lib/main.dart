import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:manejemen_surat/views/splashscreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'e-Arsip DPRD',
      home: Splashscreen(),
    );
  }
}


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:app/screens/homepage.dart';

void main() {
  if (Platform.isAndroid || Platform.isIOS) {
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Minhas Finanças',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const HomePage(),
    );
  }
}

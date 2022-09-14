import 'package:flutter/material.dart';
import 'package:tnved/pages/Tnved.dart';
import 'package:tnved/pages/TnvedList.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TNVED',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      // home: RandomWords(),
      home: TNVED(),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:tnved/pages/DisconnectScreen.dart';
import 'package:tnved/pages/Tnved.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

void main() async {
  var listener = InternetConnectionChecker().onStatusChange.listen((status) {
    switch (status) {
      case InternetConnectionStatus.connected:
        runApp(const MyApp());
        // runApp(const DiscannectScreen());
        print('Internet connection.');
        break;
      case InternetConnectionStatus.disconnected:
        runApp(const DiscannectScreen());
        print('Internet disconnected.');
        break;
    }
  });
  await Future.delayed(Duration(seconds: 30));
  await listener.cancel();
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
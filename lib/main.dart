import 'package:flutter/material.dart';
import 'package:tnved/pages/DisconnectScreen.dart';
import 'package:tnved/pages/Tnved.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'dart:io';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

// void main() async {
//   var listener = InternetConnectionChecker().onStatusChange.listen((status) {
//     switch (status) {
//       case InternetConnectionStatus.connected:
//         HttpOverrides.global = new MyHttpOverrides();
//         runApp(const MyApp());
//         print('Internet connection.');
//         break;
//       case InternetConnectionStatus.disconnected:
//         runApp(const DiscannectScreen());
//         print('Internet disconnected.');
//         break;
//     }
//   });
//   await Future.delayed(const Duration(seconds: 10));
//   await listener.cancel();
// }

void main() async {
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
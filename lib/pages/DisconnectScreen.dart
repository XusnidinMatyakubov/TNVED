import 'package:flutter/material.dart';
import 'dart:io' show Platform, exit;

import 'package:flutter/services.dart';

import '../main.dart';

class DiscannectScreen extends StatefulWidget {
  const DiscannectScreen({Key? key}) : super(key: key);

  @override
  State<DiscannectScreen> createState() => _DiscannectScreenState();
}

class _DiscannectScreenState extends State<DiscannectScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TNVED',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        body: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'images/gif/noConnection.gif',
                  width: 250,
                  height: 250,
                ),
                const Text(
                  "Internet yoqilmagan",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  color: Colors.green,
                  width: 50,
                  child: Center(
                    child: Ink(
                      decoration: const ShapeDecoration(
                        color: Colors.lightBlue,
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.refresh),
                        color: Colors.black,
                        onPressed: () {
                          print("OK");
                          return main();
                        },
                      ),
                    ),
                  ),
                  // child: IconButton(
                  //     icon: Icon(Icons.refresh),
                  //     onPressed: () {
                  //       // if (Platform.isAndroid) {
                  //       //   SystemNavigator.pop();
                  //       // } else if (Platform.isIOS) {
                  //       //   exit(0);
                  //       // }
                  //     },
                  // ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tnved/pages/Tnved.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';
import 'dart:io' show Platform;

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

AppOpenAd? appOpenAd;
loadAppOpenAd(){
  AppOpenAd.load(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-2837683596775112/7596513283'
          : 'ca-app-pub-3940256099942544/5662855259',
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad){
            appOpenAd=ad;
            appOpenAd!.show();
          },
          onAdFailedToLoad: (error){
            print(error);
          }
      ),
      orientation: AppOpenAd.orientationPortrait);
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  loadAppOpenAd();
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
import 'package:flutter/material.dart';
import 'package:qr_app/utils/custom_colors.dart';
import 'package:splashscreen/splashscreen.dart';

import 'screens/scan_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.amber,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Nexa',
        primarySwatch: ColorCustom.colorPrimary,
      ),
      home: const SplashUIPage(),
    );
  }
}

class SplashUIPage extends StatefulWidget {
  const SplashUIPage({Key? key}) : super(key: key);

  @override
  State<SplashUIPage> createState() => _SplashUIPageState();
}

class _SplashUIPageState extends State<SplashUIPage> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      backgroundColor: ColorCustom.colorPrimary,

      seconds: 2,
      useLoader: true,
      loaderColor: ColorCustom.darkBlue,
      title: const Text(
        'QR Scan',
        style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      navigateAfterSeconds: MyHomePage(),
    );
  }
}

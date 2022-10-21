import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:qr_app/utils/custom_colors.dart';

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
  void initState() {
       navigateToSplash();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorCustom.colorPrimary,
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: AnimatedTextKit(
                totalRepeatCount: 1,
                animatedTexts: [
                  TyperAnimatedText('QR\nScan',
                      textAlign: TextAlign.center,
                      textStyle: const TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: Colors.white))

                  // Text(
                  //   'QR\nScan',
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(
                  //       fontSize: 60,
                  //       fontWeight: FontWeight.bold,
                  //       color: Colors.white),
                  // ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 200,
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 5,
              ),
            ),
          )
        ],
      ),
    );
    // SplashScreen(
    //   backgroundColor: ColorCustom.colorPrimary,

    //   seconds: 1,
    //   useLoader: true,
    //   loaderColor: Colors.white,
    //   title: const Text(
    //     'QR\nScan',
    //     textAlign: TextAlign.center,
    //     style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.white),
    //   ),
    //   navigateAfterSeconds: MyHomePage(),
    // );
  }

  void navigateToSplash() {
    Future.delayed(
        const Duration(
          seconds: 1,
        ), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (BuildContext context) => MyHomePage(),
        ),
      );
    });
  }
}

import 'dart:convert';
import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_app/db/result_database.dart';
import 'package:qr_app/screens/saved_items_list.dart';
import 'package:qr_app/utils/constants_util.dart';
import 'package:qr_app/utils/custom_colors.dart';
import 'package:qr_app/utils/custom_themes.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter/services.dart';
import 'package:qr_app/model/result.dart';
import 'package:firebase_database/firebase_database.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    Firebase.initializeApp();
    super.initState();
  }

  Future _scanQR() async {
    var cameraStatus = await Permission.camera.status;
    if (cameraStatus.isGranted) {
      try {
        String? cameraScanResult = await scanner.scan();
        saveResult(cameraScanResult);
      } on PlatformException catch (e) {
        print(e);
      }
    } else {
      var isGrant = await Permission.camera.request();

      if (isGrant.isGranted) {
        try {
          String? cameraScanResult = await scanner.scan();
          saveResult(cameraScanResult);
        } on PlatformException catch (e) {
          print(e);
        }
      }
    }
  }

  Future saveResult(String? cameraScanResult) async {
    if (cameraScanResult != null && cameraScanResult.trim().isNotEmpty) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      var deviceName = '${androidInfo.brand ?? ""} ${androidInfo.model}';
      final scan = Scan(
          result: cameraScanResult,
          createdTime: DateTime.now(),
          device: deviceName ?? '');
      var scaffoldMessenger = ScaffoldMessenger.of(context);
      await ScansDatabase.instance.insert(scan);

      scaffoldMessenger.showSnackBar(SnackBar(
        content: Text(
          'Scan Success - ${cameraScanResult} ',
          style: CustomThemes.getNormalStyle(size: 20.0),
        ),
        backgroundColor: Colors.white,
        duration: Duration(milliseconds: 2000),
      ));
      await saveDataToFirebase(scan);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 144, 28, 28),
        centerTitle: true,
        title: const Text(
          'QR Scan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: getScannerBody(),
    );
  }

  getScannerBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
            child: Center(
          child: GestureDetector(
            onTap: () {
              _scanQR();
            },
            child: Image.asset(
              'assets/images/qr_img.png',
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
          ),
        )),
        Container(
          child: Image.asset(
            'assets/images/logo.png',
            width: 150,
            height: 100,
            fit: BoxFit.contain,
          ),
        ),
        Container(
          height: 100,
          decoration: const BoxDecoration(
            color: ColorCustom.inAppRed,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
          child: Row(children: [
            Expanded(
              child: IconButton(
                  onPressed: () {
                    _scanQR();
                  },
                  icon: Image.asset(
                    "assets/images/qr_icon.png",
                    color: Colors.white,
                    fit: BoxFit.contain,
                  )),
            ),
            Expanded(
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            const ScanResultScreen(),
                      ),
                    );
                  },
                  icon: Image.asset(
                    "assets/images/list_icon.png",
                    color: Colors.white,
                    fit: BoxFit.contain,
                  )),
            ),
          ]),
        )
      ],
    );
  }

  saveDataToFirebase(Scan scan) async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref(Constants.firebaseDbName);
    await ref.push().set(jsonEncode(scan));
  }
}

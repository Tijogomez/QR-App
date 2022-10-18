import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter/services.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String result = "QR Scanner";
  Future _scanQR() async {
    var cameraStatus = await Permission.camera.status;
    if (cameraStatus.isGranted) {
      try {
        String? cameraScanResult = await scanner.scan();
        setState(() {
          result = cameraScanResult!;
        });
      } on PlatformException catch (e) {
        print(e);
      }
    } else {
      var isGrant = await Permission.camera.request();

      if (isGrant.isGranted) {
        try {
          String? cameraScanResult = await scanner.scan();
          setState(() {
            result = cameraScanResult!;
          });
        } on PlatformException catch (e) {
          print(e);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(result), // Here the scanned result will be shown
      ),
      floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.camera_alt),
          onPressed: () {
            _scanQR(); // calling a function when user click on button
          },
          label: const Text("Scan")),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

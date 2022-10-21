import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:qr_app/model/result.dart';
import 'package:qr_app/screens/scan_page.dart';
import 'package:qr_app/utils/constants_util.dart';
import 'package:qr_app/utils/custom_themes.dart';
import 'package:intl/intl.dart';
import 'package:qr_app/utils/custom_widgets.dart';
import '../db/result_database.dart';

class ScanResultScreen extends StatefulWidget {
  const ScanResultScreen({Key? key}) : super(key: key);

  @override
  State<ScanResultScreen> createState() => _ScanResultScreenState();
}

class _ScanResultScreenState extends State<ScanResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getListView(),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 144, 28, 28),
        centerTitle: true,
        title: const Text(
          'Saved List',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  getListView() {
    return FutureBuilder(
        future: getScanDataFromDb(),
        builder: (context, AsyncSnapshot<List<Scan>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              if (snapshot.data?.isEmpty == true) {
                return Center(
                    child: Text(
                  'List empty...',
                  style: CustomThemes.getBoldStyle(),
                ));
              } else {
                return showListData(snapshot.data ?? []);
              }
            } else {
              return Center(
                  child: Text('List empty...',
                      style: CustomThemes.getBoldStyle()));
            }
          } else {
            return Center(
                child: Text('Loading...', style: CustomThemes.getBoldStyle()));
          }
        });
  }

  showListData(List<Scan> data) {
    if (data.isEmpty) {
      return Center(
          child: Text('List empty...', style: CustomThemes.getBoldStyle()));
    } else {
      return ListView.separated(
          separatorBuilder: (context, index) =>
              Divider(height: 1, thickness: 5),
          itemCount: data.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onLongPress: () {
                CustomWidget.showPermissionAlertDialog(
                    context: context,
                    message:
                        'Are you sure want to delete this entry ${data[index].result}',
                    negativePositiveMessage: 'Cancel',
                    negativeTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScanResultScreen(),
                        ),
                      );
                      Navigator.pop(context);
                    },
                    positiveTap: () async {
                      //     await ScansDatabase.instance.deleteItem(data[index].id);
                      var dRef = data[index].fireBaseId?.ref;
                      // FirebaseDatabase.instance
                      //     .ref(Constants.firebaseDbName)

                      //     .remove;
                      var instance = FirebaseDatabase.instance;
                      instance.ref(dRef?.path).set(null);
                      setState(() {});
                    },
                    positiveButtonMessage: 'Delete',
                    title: 'Delete');
              },
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('${index + 1}. ',
                            style: CustomThemes.getNormalStyle(size: 16.0)),
                        Text(
                          '${DateFormat('MM/dd/yy hh:mm aa').format(data[index].createdTime)} - ',
                          style: CustomThemes.getNormalStyle(size: 16.0),
                        ),
                        Text(
                          '${data[index].device}',
                          style: CustomThemes.getNormalStyle(size: 16.0),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          '${data[index].result} ',
                          style: CustomThemes.getBoldStyle(size: 16.0),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          });
    }
  }

  Future<List<Scan>> getScanDataFromDb() async {
    final ref = FirebaseDatabase.instance.ref(Constants.firebaseDbName);
    final snapshot = await ref.get();
    if (snapshot.exists) {
      var list = snapshot.children.map((e) {
        try {
          var scan = Scan.fromJson(jsonDecode(e.value.toString()));
          scan.fireBaseId = e;
          return scan;
        } catch (e) {
          return Scan(result: "", createdTime: DateTime.now());
        }
      }).toList();
      return list.reversed.toList();
    } else {
      return [];
    }
  }
}

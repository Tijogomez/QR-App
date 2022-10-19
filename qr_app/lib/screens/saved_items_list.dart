import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:qr_app/model/result.dart';
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
              onLongPress: () {
                CustomWidget.showPermissionAlertDialog(
                    context: context,
                    message:
                        'Are you sure want to delete this entry ${data[index].result}',
                    negativePositiveMessage: 'Cancel',
                    positiveTap: () async {
                      await ScansDatabase.instance.deleteItem(data[index].id);
                      setState(() {});
                    },
                    positiveButtonMessage: 'Delete',
                    title: 'Delete');
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                child: Row(
                  children: [
                    Text('${index + 1}. ',
                        style: CustomThemes.getNormalStyle(size: 16.0)),
                    Text(
                      '${DateFormat('MM/dd/yy hh:mm aa').format(data[index].createdTime)} - ',
                      style: CustomThemes.getNormalStyle(size: 16.0),
                    ),
                    Expanded(
                        child: Text(
                      '${data[index].result} ',
                      style: CustomThemes.getBoldStyle(size: 16.0),
                    )),
                  ],
                ),
              ),
            );
          });
    }
  }

  Future<List<Scan>> getScanDataFromDb() async {
    var resultData = await ScansDatabase.instance.readAllScans();
    return resultData;
  }
}

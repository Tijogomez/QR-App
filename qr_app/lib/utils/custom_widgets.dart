import 'package:flutter/material.dart';
import 'package:qr_app/utils/custom_colors.dart';

import 'custom_themes.dart';

class CustomWidget{

static Future<void> showPermissionAlertDialog(
    {context,
    title = 'Warning',
    message,
    negativePositiveMessage = 'No',
    positiveButtonMessage = 'Yes',
    positiveTap,
    negativeTap}) async {
  return showDialog<void>(
    context: context,

    useSafeArea: true,
    barrierColor: Colors.grey.shade400.withOpacity(0.5),
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.black, width: 1.0),
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text(
          title,
          style: CustomThemes.getBoldStyle(size:16.0),
        ),
        content: Text(
          message,
          style: CustomThemes.getNormalStyle(size:16.0),
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: <Widget>[
          TextButton(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        width: 1.0, color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: Text(
                  negativePositiveMessage,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Nunito',
                  ),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                negativeTap();
              }),
          TextButton(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                decoration: BoxDecoration(
                    color: ColorCustom.colorPrimary,
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: Text(
                  positiveButtonMessage,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Nunito',
                  ),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                positiveTap();
              })
        ],
      );
    },
  );
}
}
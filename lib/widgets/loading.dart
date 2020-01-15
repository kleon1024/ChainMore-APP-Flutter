import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Loading {
  static bool isLoading = false;

  static void showLoading(BuildContext context, {dismissible = false}) {
    if (!isLoading) {
      isLoading = true;
      showGeneralDialog(
          context: context,
          barrierDismissible: dismissible,
          barrierLabel:
              MaterialLocalizations.of(context).modalBarrierDismissLabel,
          transitionDuration: const Duration(milliseconds: 150),
          pageBuilder: (BuildContext context, Animation animation,
              Animation secondaryAnimation) {
            return Align(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: ScreenUtil().setHeight(350),
                  height: ScreenUtil().setHeight(350),
                  color: Colors.black12,
                  child: CupertinoActivityIndicator(),
                ),
              ),
            );
          }).then((v) {
        isLoading = false;
      });
    }
  }

  static void hideLoading(BuildContext context) {
    if (isLoading) {
      Navigator.of(context).pop();
    }
  }
}

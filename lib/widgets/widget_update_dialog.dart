import 'dart:async';
import 'dart:io';

import 'package:chainmore/models/update.dart';
import 'package:chainmore/utils/colors.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateDialog extends StatefulWidget {
  final Update data;

  UpdateDialog({Key key, this.data}) : super(key: key);

  @override
  _UpdateDialogState createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {

  _update(context) async {
    String url;

    if (Platform.isIOS) {
      url = widget.data.appStoreUrl;
    } else {
      url = widget.data.apkUrl;
    }

    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false);
    } else {
      Utils.showToast(context, "更新URL不合法");
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text("升级"),
      content: Padding(
        padding: EdgeInsets.all(0),
        child: Text(widget.data.content,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.5,
                wordSpacing: 1.2)),
      ),
      actions: <Widget>[
        CupertinoButton(
          child:
              Text("取消升级", style: TextUtil.style(16, 600, color: Colors.grey)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        CupertinoButton(
          child: Text("立即升级",
              style: TextUtil.style(16, 600, color: CMColors.blueLonely)),
          onPressed: () {
            _update(context);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

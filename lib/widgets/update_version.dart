import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:chainmore/models/update.dart';
import 'package:chainmore/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateVersionDialog extends StatefulWidget {
  final Update data;

  UpdateVersionDialog({Key key, this.data}) : super(key: key);

  @override
  _UpdateVersionDialogState createState() => _UpdateVersionDialogState();
}

class _UpdateVersionDialogState extends State<UpdateVersionDialog> {
  static const channelName = 'plugins.iwubida.com/update_version';
  static const stream = const EventChannel(channelName);

  // 进度订阅
  StreamSubscription downloadSubscription;

  _updateButtonTap(BuildContext context) async {
    if (Platform.isIOS) {
      final url = widget.data.appStoreUrl;
      if (await canLaunch(url)) {
        await launch(url, forceSafariVC: false);
      } else {
        throw 'Could not launch $url';
      }
    } else if (Platform.isAndroid) {
      final url = widget.data.apkUrl;
      if (await canLaunch(url)) {
        await launch(url, forceSafariVC: false);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    var _maxContentHeight = min(screenSize.height - 300, 180.0);

    return Material(
        type: MaterialType.transparency,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  width: screenSize.height > screenSize.width ? 265 : 370,
                  decoration: ShapeDecoration(
                  color: Color(0xFFFFFFFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  )),
                  child: Column(children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                        child: Center(
                            child: new Text('升级到新版本',
                                style: new TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w500,
                                )))),
                    Container(
                      child: Text(
                        widget.data.version,
                        style: TextStyle(
                            color: CMColors.blueLonely,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: _maxContentHeight),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: SingleChildScrollView(
                          child: Text(
                            widget.data.content,
                            style: TextStyle(color: Colors.black87),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(33, 0, 33, 0),
                      child: Container(
                        height: 1.0 /
                            MediaQueryData.fromWindow(window).devicePixelRatio,
                        color: Color(0xffC0C0C0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: SizedBox(
                        width: 170,
                        height: 40,
                        child: RaisedButton(
                            child: Text(
                              "立即升级",
                              style: TextStyle(color: Color(0xdfffffff)),
                            ),
                            color: CMColors.blueLonely,
                            onPressed: () {
                              _updateButtonTap(context);
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0))),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 8, 0, 10),
                        child: SizedBox(
                          height: 30,
                          child: FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              textColor: Colors.black26,
                              color: Colors.transparent,
                              highlightColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              child: Text(
                                "暂不升级",
                                style: TextStyle(fontSize: 13),
                              )),
                        ))
                  ]))
            ]));
  }
}

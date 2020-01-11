import 'dart:async';
import 'dart:io';

import 'package:chainmore/models/update.dart';
import 'package:chainmore/utils/colors.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:chainmore/widgets/widget_button_thin_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateDialog extends StatefulWidget {
  final Update data;

  UpdateDialog({Key key, this.data}) : super(key: key);

  @override
  _UpdateDialogState createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  static String apkName;
  static String taskId;

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
      Utils.showToast("更新URL不合法");
    }

//    if (Platform.isIOS) {
//      if (await canLaunch(url)) {
//        await launch(url, forceSafariVC: false);
//      } else {
//        throw 'Could not launch $url';
//      }
//    } else {
//      Map<PermissionGroup, PermissionStatus> permissions =
//          await PermissionHandler()
//              .requestPermissions([PermissionGroup.storage]);
//      if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
//        _startDownload();
//      } else {
//        _showSettingDialog();
//      }
//    }
  }

  _showSettingDialog() {
    Utils.showDoubleChoiceDialog(
      context,
      title: "申请权限",
      body: "需要打开存储权限",
      leftText: "取消",
      rightText: "前往设置",
      leftFunc: () {
        Navigator.of(context).pop();
      },
      rightFunc: () {
        PermissionHandler().openAppSettings();
        Navigator.of(context).pop();
      },
    );
  }

  static Future<String> get _apkLocalPath async {
    final directory = await getExternalStorageDirectory();
    return directory.path;
  }

  void _startDownload() async {
    final path = await _apkLocalPath;
    var nameList = widget.data.apkUrl.split("/");
    apkName = nameList[nameList.length - 1];
    File file = File(path + '/' + apkName);
    if (await file.exists()) await file.delete();
    print(widget.data.apkUrl);
    taskId = await FlutterDownloader.enqueue(
        url: widget.data.apkUrl,
        savedDir: path,
        fileName: apkName,
        showNotification: true,
        openFileFromNotification: true);

    FlutterDownloader.registerCallback(downloadCallback);

//    final tasks = FlutterDownloader.loadTasks();
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) async {
    print("downloaded");
    print(status);
    if (taskId == id && status == DownloadTaskStatus.complete) {
      String path = await _apkLocalPath;
      await OpenFile.open(path + '/' + apkName);
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

import 'dart:convert';

import 'package:chainmore/models/domain.dart';
import 'package:chainmore/models/update.dart';
import 'package:chainmore/network/apis.dart';
import 'package:chainmore/widgets/update_version.dart';
import 'package:flutter/material.dart';
import 'package:chainmore/application.dart';
import 'package:package_info/package_info.dart';
import 'package:version/version.dart';

class UpdateModel with ChangeNotifier {
  Update _version;

  
  get version => _version;

  initState() {
    if (Application.sp.containsKey('update_state')) {
      var state = json.decode(Application.sp.getString('update_state'));
      _version = Update.fromJson(state['version']);
    }
  }

  checkUpdate(context) async {
    var response = await API.getUpdateInfo();
    if (response == null) {
      return;
    }
    _version = response;
    print(_version.version);
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    print(appName);
    print(packageName);
    print(version);
    print(buildNumber);

    Version currentVersion = Version.parse(version);
    Version latestVersion = Version.parse(_version.version);

    if (currentVersion < latestVersion) {
      showDialog<Null>(
          context: context,
          barrierDismissible: true,
          builder: (context) {
            return UpdateVersionDialog(data: _version);
          });
    }
  }

  reset() {
    _version = null;
    deleteUpdateState();
  }

  saveEditState() {
    var state = {
      "version" : _version,
    };

    Application.sp.setString('update_state', json.encode(state));
  }

  deleteUpdateState() {
    Application.sp.remove('update_state');
  }

  hasHistory() {
    return Application.sp.containsKey('update_state');
  }

}

import 'package:chainmore/utils/navigator_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PersonalDrawer extends StatelessWidget{

  PersonalDrawer({Key key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Text('大丁丁'),
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
        ),
        ListTile(
          title: Text('我的状态'),
          onTap: () {
            // Update the state of the app.
            // ...
          },
        ),
        ListTile(
          title: Text('设置'),
          onTap: () {
            Navigator.pop(context);
            NavigatorUtil.goSettingPage(context);
          },
        ),
      ],
    );
  }
}
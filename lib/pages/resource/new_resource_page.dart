import 'dart:convert';

import 'package:chainmore/utils/navigator_util.dart';
import 'package:chainmore/widgets/cards/resource_add_card.dart';
import 'package:chainmore/widgets/cards/resource_card.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewResourcePage extends StatefulWidget {
  @override
  _NewResourcePageState createState() => _NewResourcePageState();
}

class _NewResourcePageState extends State<NewResourcePage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _uriEditingController = TextEditingController();
  final TextEditingController _titleEditingController = TextEditingController();
  final double _padding = 45;

  bool _isPaid = false;
  bool _isAds = false;

  List _mediaType = [
    "文字",
    "图片",
    "音频",
    "视频",
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("添加资源", style: Theme.of(context).textTheme.headline6),
        centerTitle: true,
        key: _scaffoldKey,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.select_all,
              size: Theme.of(context).iconTheme.size,
            ),
            onPressed: () {
//              _onSelectClassifier();
            },
          ),
          IconButton(
            icon: Icon(
              Icons.search,
              size: Theme.of(context).iconTheme.size,
            ),
            onPressed: () {
              NavigatorUtil.goSearchPage(context);
            },
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: CupertinoScrollbar(
          child: CustomScrollView(
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(_padding)),
                    child: Text(
                      "链接",
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                  VEmptyView(20),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(_padding)),
                    child: TextField(
                      autofocus: true,
                      controller: _uriEditingController,
                      maxLines: 16,
                      minLines: 1,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: ScreenUtil().setWidth(0),
                            horizontal: ScreenUtil().setWidth(30)),
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  VEmptyView(30),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(_padding)),
                    child: Text(
                      "标题",
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                  VEmptyView(20),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(_padding)),
                    child: TextField(
                      controller: _titleEditingController,
                      maxLines: 3,
                      minLines: 1,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: ScreenUtil().setWidth(0),
                            horizontal: ScreenUtil().setWidth(30)),
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  VEmptyView(30),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(_padding)),
                    child: Text(
                      "媒体类型",
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(_padding)),
                    child: RaisedButton(
                      onPressed: () {
                        showPickerIcons(context);
                      },
                      color: Theme.of(context).canvasColor,
                      elevation: 5,
                      child: Text(
                        "文字",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(_padding)),
                    child: Text(
                      "内容类型",
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(_padding)),
                    child: RaisedButton(
                      color: Theme.of(context).canvasColor,
                      elevation: 5,
                      onPressed: () {
                        showPickerIcons(context);
                      },
                      child: Text(
                        "文章",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                  ),
                  VEmptyView(20),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(_padding)),
                    title: Text("内容额外付费"),
                    value: _isPaid,
                    secondary: Icon(Icons.attach_money),
                    controlAffinity: ListTileControlAffinity.platform,
                    onChanged: (bool value) {
                      setState(() {
                        _isPaid = value;
                      });
                    },
                  ),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }

  showPickerIcons(BuildContext context) {
    Picker(
        headercolor: Theme.of(context).canvasColor,
        backgroundColor: Theme.of(context).canvasColor,
        textStyle: Theme.of(context).textTheme.subtitle1,
        adapter: PickerDataAdapter(pickerdata: _mediaType),
        confirmText: "确认",
        confirmTextStyle: Theme.of(context)
            .textTheme
            .subtitle1
            .merge(TextStyle(color: Theme.of(context).accentColor)),
        cancelText: "取消",
        cancelTextStyle: Theme.of(context)
            .textTheme
            .subtitle1
            .merge(TextStyle(color: Theme.of(context).accentColor)),
        title: Text("媒体类型", style: Theme.of(context).textTheme.subtitle1),
        onConfirm: (Picker picker, List value) {
          print(value.toString());
          print(picker.getSelectedValues());
        }).showModal(context); //_scaffoldKey.currentState);
  }

  @override
  bool get wantKeepAlive => true;
}

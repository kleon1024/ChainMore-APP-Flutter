import 'dart:async';
import 'dart:convert';

import 'package:chainmore/utils/navigator_util.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:chainmore/utils/web_page_parser.dart';
import 'package:chainmore/widgets/cards/resource_add_card.dart';
import 'package:chainmore/widgets/cards/resource_card.dart';
import 'package:chainmore/widgets/h_empty_view.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:chainmore/widgets/widget_future_builder.dart';
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
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _uriFocusNode = FocusNode();
  final double _padding = 45;

  bool _isPaid = false;

  bool _isLoading = false;

  Map _mediaType = {
    "图文": 1,
    "音频": 3,
    "视频": 4,
  };

  String _selectedMediaType = "图文";

  Map _resourceType = {
    "文章": 1,
    "教程": 2,
    "新闻": 3,
  };

  String _selectedResourceType = "文章";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("添加资源", style: Theme.of(context).textTheme.subtitle1),
        centerTitle: true,
        key: _scaffoldKey,
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
                      focusNode: _uriFocusNode,
                      onSubmitted: (String value) {
                        if (!_isLoading && value.trim().isNotEmpty) {
                          setState(() {
                            _isLoading = true;
                          });
                          WebPageParser.getData(value.trim()).then((Map data) {
                            print(data);
                            setState(() {
                              if (data != null) {
                                if (data.containsKey('title')) {
                                  _titleEditingController.text = data['title'];
                                }
                              }
                              _isLoading = false;
                            });
                          }).catchError((e) {
                            setState(() {
                              _isLoading = false;
                            });
                          });
                        }
                      },
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
                    child: Row(
                      children: <Widget>[
                        Text(
                          "标题",
                        ),
                        HEmptyView(10),
                        _isLoading ? CupertinoActivityIndicator() : Container(),
                      ],
                    ),
                  ),
                  VEmptyView(20),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(_padding)),
                    child: TextField(
                      controller: _titleEditingController,
                      focusNode: _titleFocusNode,
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
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(_padding)),
                    child: RaisedButton(
                      onPressed: () {
                        Utils()
                            .showPickerIcons(context, _mediaType.keys.toList(),
                                callback: (Picker picker, List value) {
                          setState(() {
                            _selectedMediaType = picker.getSelectedValues()[0];
                          });
                        });
                      },
                      color: Theme.of(context).canvasColor,
                      elevation: 8,
                      child: Text(
                        _selectedMediaType,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(_padding)),
                    child: Text(
                      "内容类型",
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(_padding)),
                    child: RaisedButton(
                      color: Theme.of(context).canvasColor,
                      elevation: 8,
                      onPressed: () {
                        Utils().showPickerIcons(
                            context, _resourceType.keys.toList(),
                            callback: (Picker picker, List value) {
                          setState(() {
                            _selectedResourceType =
                                picker.getSelectedValues()[0];
                          });
                        });
                      },
                      child: Text(
                        _selectedResourceType,
                      ),
                    ),
                  ),
                  VEmptyView(20),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(_padding)),
                    title: Text("需要额外付费",
                        style: Theme.of(context).textTheme.bodyText1),
                    value: _isPaid,
                    secondary: Icon(Icons.attach_money),
                    controlAffinity: ListTileControlAffinity.platform,
                    onChanged: (bool value) {
                      setState(() {
                        _isPaid = value;
                      });
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(_padding)),
                    child: RaisedButton(
                      color: Theme.of(context).canvasColor,
                      textColor: Theme.of(context).accentColor,
                      elevation: 8,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("分享"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(_padding)),
                    child: RaisedButton(
                      color: Theme.of(context).canvasColor,
//                      textColor: Theme.of(context).accentColor,
                      elevation: 0,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("保存"),
                    ),
                  ),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

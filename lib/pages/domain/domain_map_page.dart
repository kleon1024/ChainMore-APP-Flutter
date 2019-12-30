import 'package:chainmore/models/certify_rule.dart';
import 'package:chainmore/models/domain.dart';
import 'package:chainmore/network/apis.dart';
import 'package:chainmore/pages/domain/choiceproblem_page.dart';
import 'package:chainmore/pages/domain/empty_certify_page.dart';
import 'package:chainmore/providers/certify_model.dart';
import 'package:chainmore/utils/colors.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:chainmore/widgets/widget_future_builder.dart';
import 'package:chainmore/widgets/widget_simple_future_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class DomainMapPage extends StatefulWidget {
  final Domain domain;

  DomainMapPage(this.domain);

  @override
  _DomainMapPageState createState() => _DomainMapPageState();
}

class _DomainMapPageState extends State<DomainMapPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        padding: EdgeInsets.only(
            bottom: ScreenUtil().setHeight(90),
            right: ScreenUtil().setWidth(10)),
        child: Container(
          height: ScreenUtil().setHeight(180),
          width: ScreenUtil().setWidth(80),
          child: Column(
            children: <Widget>[
              FloatingActionButton(
                elevation: 0,
                backgroundColor: Colors.black87,
                child: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Row(
        children: <Widget>[
          Flexible(
            child: Container(
              color: Colors.grey,
              child: PageView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  PageView(
                    scrollDirection: Axis.vertical,
                    children: <Widget>[
                      Text("计算机"),
                      Text("计算机-1"),
                    ],
                  ),
                  PageView(
                    scrollDirection: Axis.vertical,
                    children: <Widget>[
                      Text("软件"),
                      Text("软件-1"),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            child: Container(
              color: Colors.blue,
              child: PageView(
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  Text("计算机-程序语言"),
                  Text("计算机-编译"),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}

import 'package:chainmore/utils/colors.dart';
import 'package:chainmore/utils/navigator_util.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:chainmore/widgets/h_empty_view.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditPage extends StatefulWidget {
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  String title;

  final TextEditingController _editController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(ScreenUtil().setHeight(120)),
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              AppBar(
                elevation: 0,
                automaticallyImplyLeading: false,
                centerTitle: true,
                title: Text(
                  title ?? "灵感",
                  style: TextUtil.style(15, 500),
                ),
              ),
              Positioned(
                left: ScreenUtil().setWidth(10),
                top: ScreenUtil().setHeight(10),
                child: GestureDetector(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(
                        ScreenUtil().setWidth(30),
                        ScreenUtil().setWidth(15),
                        ScreenUtil().setWidth(30),
                        ScreenUtil().setWidth(15)),
                    child: Text("取消",
                        style: TextUtil.style(15, 400, color: Colors.black38)),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Positioned(
                right: ScreenUtil().setWidth(10),
                top: ScreenUtil().setHeight(10),
                child: GestureDetector(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(
                        ScreenUtil().setWidth(30),
                        ScreenUtil().setWidth(15),
                        ScreenUtil().setWidth(30),
                        ScreenUtil().setWidth(15)),
                    child: Text("发表",
                        style: TextUtil.style(15, 700,
                            color: CMColors.blueLonely)),
                  ),
                  onTap: () {
                    if (title == "文章") {}
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              ScreenUtil().setWidth(60),
              ScreenUtil().setWidth(0),
              ScreenUtil().setWidth(60),
              ScreenUtil().setWidth(30)),
          child: Column(
            children: <Widget>[
              Container(
                height: ScreenUtil().setHeight(800),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      title == "文章"
                          ? TextField(
                              controller: _titleController,
                              decoration: InputDecoration(
                                hintText: "请输入标题(20字)",
                              ),
                              onChanged: (text) {
                                if (text.isEmpty &&
                                    _editController.text.isEmpty) {
                                  setState(() {
                                    title = "灵感";
                                  });
                                }
                              },
                            )
                          : VEmptyView(0),
                      VEmptyView(20),
                      TextField(
                        controller: _editController,
                        maxLines: 300,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration.collapsed(
                          hintText: title == "文章" ? "尽情抒发你的想法吧" : "灵光一现(20字)",
                          hintStyle:
                              TextUtil.style(15, 400, color: Colors.grey),
                        ),
                        onChanged: (text) {
                          if (_titleController.text.isEmpty) {
                            if (text.contains('\n') || text.length > 20) {
                              if (title != "文章") {
                                setState(() {
                                  title = "文章";
                                  _titleController.text = text.split('\n')[0];
                                  _editController.text = "";
                                });
                              }
                            } else {
                              if (title != "灵感") {
                                setState(() {
                                  title = "灵感";
                                });
                              }
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              title == "文章" ? InkWell(
                onTap: () {
                   NavigatorUtil.goDomainSearchPage(context);
                },
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(Icons.add),
                          HEmptyView(10),
                          Text("添加话题",
                              style: TextUtil.style(15, 400)),
                        ],
                      ),
                      Icon(Icons.chevron_right),
                    ],
                  )
                ),
              ) : VEmptyView(0),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

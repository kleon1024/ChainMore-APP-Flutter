import 'package:chainmore/utils/colors.dart';
import 'package:chainmore/utils/navigator_util.dart';
import 'package:chainmore/widgets/common_text_style.dart';
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
                  onTap: () {},
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              ScreenUtil().setWidth(30),
              ScreenUtil().setWidth(0),
              ScreenUtil().setWidth(30),
              ScreenUtil().setWidth(30)),
          child: Container(
            height: ScreenUtil().setHeight(800),
            child: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                title == "文章" ? TextField(
                  decoration: InputDecoration(
                    hintText: "请输入标题(20字)",
                  ),
                ) : VEmptyView(0),
                VEmptyView(20),
                TextField(
                  controller: _editController,
                  maxLines: 300,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration.collapsed(
                    hintText: "灵光一现(20字)",
                    hintStyle: TextUtil.style(15, 400, color: Colors.grey),
                  ),
                  onChanged: (text) {
                    if (text.contains('\n') || text.length > 20) {
                      print(title);
                      if (title != "文章") {
                        setState(() {
                          title = "文章";
                        });
                      }
                    } else {
                      if (title != "灵感") {
                        setState(() {
                          title = "灵感";
                        });
                      }
                    }
                  },
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

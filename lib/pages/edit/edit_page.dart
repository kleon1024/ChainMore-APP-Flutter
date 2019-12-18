import 'package:chainmore/network/apis.dart';
import 'package:chainmore/providers/edit_model.dart';
import 'package:chainmore/utils/colors.dart';
import 'package:chainmore/utils/navigator_util.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:chainmore/widgets/h_empty_view.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class EditPage extends StatefulWidget {
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  String title;
  bool posting = false;

  bool init = false;

  final TextEditingController _editController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    EditModel editModel = Provider.of<EditModel>(context);
    if (!init) {
      if (editModel.title != null && editModel.title != "") {
        _titleController.text = editModel.title;
        title = "文章";
      }
      if (editModel.body != null) {
        _editController.text = editModel.body;
      }
      init = true;
    }
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
                    editModel.setTitle(_titleController.text);
                    editModel.setBody(_editController.text);
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
                  onTap: () async {
                    if (title == "文章") {
                      if (_editController.text.trim().isEmpty) {
                        Utils.showToast("除了标题，再分享点什么吧");
                      } else if (editModel.domain == null) {
                        Utils.showToast("请选择发表领域");
                      } else {
                        var data = {
                          "title": _titleController.text,
                          "description": _editController.text,
                          "url": _urlController.text,
                          "domain": editModel.domain.id,
                          "categories": [],
                        };
                        if (!posting) {
                          posting = true;
                          await API.postPost(context, data: data).then((res){
                            if (res != null) {
                              Utils.showToast("领域接收成功...");
                              editModel.reset();
                              Navigator.pop(context);
                            } else {
                              Utils.showToast("领域接收失败...");
                            }
                          });
                        }
                      }
                    } else if (title == "灵感") {
                      if (_editController.text.trim().isEmpty) {
                        Utils.showToast("灵感还没诞生！");
                      } else {
                        var data = {
                          "body": _editController.text,
                        };
                        if (!posting) {
                          posting = true;
                          await API
                              .postSparkle(context, data: data)
                              .then((res) {
                            if (res != null) {
                              Utils.showToast("灵感已经广播...");
                              editModel.reset();
                              Navigator.pop(context);
                            } else {
                              Utils.showToast("灵感未能同步...");
                            }
                            posting = false;
                          });
                        }
                      }
                    }
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
              title == "文章"
                  ? InkWell(
                      onTap: () {
                        NavigatorUtil.goDomainSearchPage(context);
                      },
                      child: Container(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(editModel.domain != null
                                  ? Icons.chevron_right
                                  : Icons.add),
                              HEmptyView(10),
                              Text(
                                  editModel.domain != null
                                      ? editModel.domain.title
                                      : "添加话题",
                                  style: TextUtil.style(15, 400)),
                            ],
                          ),
                          Icon(Icons.chevron_right),
                        ],
                      )),
                    )
                  : VEmptyView(0),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

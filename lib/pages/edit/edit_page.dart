import 'package:chainmore/models/domain_search.dart';
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
import 'package:common_utils/common_utils.dart' as CommonUtils;

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
        title = "分享";
      }
      if (editModel.body != null) {
        _editController.text = editModel.body;
      }
      if (editModel.url != null && editModel.url != "") {
        _urlController.text = editModel.url;
        title = "分享";
      }
      if (editModel.domain != null) {
        title = "分享";
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
                    Utils.showDoubleChoiceDialog(context,
                        title: "保留本次编辑？",
                        leftText: '不保留',
                        rightText: '保留', leftFunc: () {
                      editModel.reset();
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }, rightFunc: () {
                      editModel.setTitle(_titleController.text);
                      editModel.setBody(_editController.text);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    });
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
                    if (title == "分享") {
                      String url = _urlController.text.trim();
                      if (url != "") {
                        if (!CommonUtils.RegexUtil.isURL(url)) {
                          url = "http://" + url;
                          if (!CommonUtils.RegexUtil.isURL(url)) {
                            Utils.showToast("请输入正确格式的URL");
                            return;
                          }
                        }
                      }

                      if (_editController.text.trim().isEmpty) {
                        Utils.showToast("除了标题，再分享点什么吧");
                      } else if (editModel.domain == null) {
                        Utils.showToast("请选择发表领域");
                      } else {
                        var data = {
                          "title": _titleController.text,
                          "description": _editController.text,
                          "url": url,
                          "domain": editModel.domain.id,
                          "categories": [],
                        };
                        if (!posting) {
                          posting = true;
                          await API.postPost(context, data: data).then((res) {
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
                      VEmptyView(50),
                      title == "分享"
                          ? TextField(
                              controller: _titleController,
                              style: TextUtil.style(18, 500),
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 0),
                                hintText: "标题",
                                hintStyle:
                                    TextUtil.style(18, 500, color: Colors.grey),
                              ),
                              onChanged: (text) {
                                if (text.isEmpty &&
                                    _editController.text.isEmpty &&
                                    editModel.domain == null &&
                                    _urlController.text.isEmpty) {
                                  setState(() {
                                    title = "灵感";
                                  });
                                }
                              },
                            )
                          : VEmptyView(0),
                      title == "分享"
                          ? TextField(
                              controller: _urlController,
                              style: TextUtil.style(15, 400),
                              decoration: InputDecoration(
                                  hintText: "链接URL",
                                  hintStyle: TextUtil.style(15, 400,
                                      color: Colors.grey),
                                  border: InputBorder.none),
                            )
                          : VEmptyView(10),
                      TextField(
                        controller: _editController,
                        maxLines: 10,
                        style: TextUtil.style(15, 400),
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration.collapsed(
                          hintText: title == "分享" ? "尽情抒发你的想法吧" : "灵光一现",
                          hintStyle:
                              TextUtil.style(15, 400, color: Colors.grey),
                        ),
                        onChanged: (text) {
                          if (_titleController.text.isEmpty) {
                            if (text.contains('\n')) {
                              if (title != "分享") {
                                setState(() {
                                  title = "分享";
                                });
                                _titleController.text = text.split('\n')[0];
                                _editController.text = "";
                              }
                            } else if (text.length > 20) {
                              if (title != "分享") {
                                setState(() {
                                  title = "分享";
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
              title == "分享"
                  ? InkWell(
                      onTap: () {
                        NavigatorUtil.goDomainSearchPage(context,
                            data: DomainSearchData(state: "certified"));
                      },
                      child: Container(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  if (editModel.domain != null) {
                                    editModel.clearDomain();
                                    setState(() {
                                      title = title;
                                    });
                                  } else {
                                    NavigatorUtil.goDomainSearchPage(context,
                                        data: DomainSearchData(
                                            state: "certified"));
                                  }
                                },
                                child: Icon(editModel.domain != null
                                    ? Icons.clear
                                    : Icons.add),
                              ),
                              HEmptyView(10),
                              Text(
                                  editModel.domain != null
                                      ? editModel.domain.title
                                      : "添加领域",
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

import 'package:chainmore/models/category.dart';
import 'package:chainmore/models/domain_search.dart';
import 'package:chainmore/network/apis.dart';
import 'package:chainmore/providers/edit_model.dart';
import 'package:chainmore/providers/setting_model.dart';
import 'package:chainmore/utils/colors.dart';
import 'package:chainmore/utils/navigator_util.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:chainmore/widgets/h_empty_view.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:chainmore/widgets/widget_category_tag.dart';
import 'package:chainmore/widgets/widget_category_tag_selectable.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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

  Category article = Category(id: 1, category: "文章");
  Category paid = Category(id: 2, category: "付费");
  Category ads = Category(id: 3, category: "广告");

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
      resizeToAvoidBottomPadding: false,
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
                      editModel.saveEditState();
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

                      if (_titleController.text.trim().isEmpty) {
                        Utils.showToast("起个标题吧！");
                      } else if (_editController.text.length > 10000) {
                        Utils.showToast("分享内容过长，最多允许10000字");
                      } else if (editModel.domain == null) {
                        Utils.showToast("请选择发表领域");
                      } else {
                        var data = {
                          "title": _titleController.text.trim(),
                          "description": _editController.text,
                          "url": url,
                          "domain": editModel.domain.id,
                          "categories": editModel.categories
                              .map((item) => item.id)
                              .toList(),
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
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(60),
                ScreenUtil().setWidth(0),
                ScreenUtil().setWidth(60),
                ScreenUtil().setWidth(30)),
            child: Column(
              children: <Widget>[
                Container(
                  height: ScreenUtil().setHeight(1000),
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
                      GestureDetector(
                        onPanDown: (details) {
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        child: TextField(
                          autofocus: true,
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
                      ),
                      VEmptyView(50),
                    ],
                  ),
                ),
                title == "分享"
                    ? InkWell(
                        onTap: () {
                          NavigatorUtil.goDomainSearchPage(context,
                              data: DomainSearchData(state: "precertified"));
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: ScreenUtil().setHeight(15)),
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
                                          NavigatorUtil.goDomainSearchPage(
                                              context,
                                              data: DomainSearchData(
                                                  state: "precertified"));
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
                VEmptyView(10),
                title == "分享"
                    ? InkWell(
                        onTap: _onSelectClassifier,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: ScreenUtil().setHeight(15)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        if (editModel.categories.isNotEmpty) {
                                          editModel.clearCategory();
                                          setState(() {
                                            title = title;
                                          });
                                        } else {
                                          NavigatorUtil.goDomainSearchPage(
                                              context,
                                              data: DomainSearchData(
                                                  state: "precertified"));
                                        }
                                      },
                                      child: Icon(editModel.domain != null
                                          ? Icons.clear
                                          : Icons.add),
                                    ),
                                    HEmptyView(10),
                                    editModel.categories.isNotEmpty
                                        ? Row(children: List<Widget>.from(
                                            editModel.categories.map((item) {
                                            return Container(
                                              padding: EdgeInsets.only(
                                                  right:
                                                      ScreenUtil().setWidth(5)),
                                              child: CategoryTag(
                                                text: item.category,
                                                textSize: 13,
                                              ),
                                            );
                                          })))
                                        : Text("添加分类",
                                            style: TextUtil.style(15, 400)),
                                  ],
                                ),
                              ),
                              Icon(Icons.chevron_right),
                            ],
                          ),
                        ),
                      )
                    : VEmptyView(0),
                VEmptyView(500),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildCategoryGroups() {
    SettingModel settingModel = Provider.of<SettingModel>(context);
    EditModel editModel = Provider.of<EditModel>(context);
    var initCategories = editModel.categories;

    return settingModel.categoryGroups
        .map(
          (categoryGroup) => Container(
            padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(30)),
            child: Row(
              children: <Widget>[
                Text(categoryGroup.title, style: TextUtil.style(15, 700)),
                HEmptyView(30),
                Row(
                  children: categoryGroup.categories
                      .map(
                        (category) => Container(
                          padding:
                              EdgeInsets.only(right: ScreenUtil().setWidth(50)),
                          child: CategoryTagSelectable(
                            text: category.category,
                            selected: initCategories.contains(category),
                            onTap: () {
                              if (initCategories.contains(category)) {
                                editModel.removeCategory(category);
                              } else {
                                editModel.addCategory(category);
                              }
                            },
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        )
        .toList();
  }

  void _onSelectClassifier() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: ScreenUtil().setHeight(650),
            color: Color(0xFF737373),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(ScreenUtil().setWidth(50)),
                    topRight: Radius.circular(ScreenUtil().setWidth(50))),
              ),
              padding: EdgeInsets.symmetric(
                  vertical: ScreenUtil().setWidth(30),
                  horizontal: ScreenUtil().setHeight(80)),
              child: Column(children: _buildCategoryGroups()),
            ),
          );
        }).then((res) {
      setState(() {
        title = title;
      });
    });
  }

  @override
  bool get wantKeepAlive => true;
}

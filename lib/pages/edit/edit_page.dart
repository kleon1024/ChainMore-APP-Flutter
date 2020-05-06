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
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
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
    SettingModel settingModel = Provider.of<SettingModel>(context);

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
      if (editModel.id > 0) {
        title = "分享";
      }
      init = true;
    }

    var categoryView = editModel.categories.isNotEmpty
        ? Expanded(
            child: GridView.count(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                childAspectRatio: 1.5,
                crossAxisCount: 6,
                children: List<Widget>.from(editModel.categories.map((item) {
                  return Container(
                    padding: EdgeInsets.only(right: ScreenUtil().setWidth(0)),
                    child: CategoryTag(
                      text: settingModel.getCategoryString(item),
                      textSize: 13,
                    ),
                    alignment: Alignment.centerLeft,
                  );
                }))))
        : Expanded(
            child: Text("添加分类",
                style: TextUtil.style(15, 400), textAlign: TextAlign.start));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
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
                          style:
                              TextUtil.style(15, 400, color: Colors.black38)),
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
                        editModel.setTitle(_titleController.text.trim());
                        editModel.setBody(_editController.text.trim());
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
                      child: Text(editModel.id > 0 ? "更新" : "发表",
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
                              Utils.showToast(context, "请输入正确格式的URL");
                              return;
                            }
                          }
                        }

                        if (_titleController.text.trim().isEmpty) {
                          Utils.showToast(context, "起个标题吧！");
                        } else if (_editController.text.trim().length > 10000) {
                          Utils.showToast(context, "分享内容过长，最多允许10000字");
                        } else if (editModel.domain == null) {
                          Utils.showToast(context, "请选择发表领域");
                        } else {
                          var data = {
                            "title": _titleController.text.trim(),
                            "description": _editController.text.trim(),
                            "url": url,
                            "domain": editModel.domain.id,
                            "categories": editModel.categories.toList(),
                          };
                          if (!posting) {
                            posting = true;
                            if (editModel.id > 0) {
                              data["post"] = editModel.id;
                              await API
                                  .putPost(context, data: data)
                                  .then((res) {
                                if (res != null) {
                                  Navigator.pop(context);
                                  Utils.showToast(context, "更新成功");
                                  editModel.reset();
                                } else {
                                  Utils.showToast(context, "更新失败");
                                }
                              });
                            } else {
                              await API
                                  .postPost(context, data: data)
                                  .then((res) {
                                if (res != null) {
                                  Utils.showToast(context, "发表成功");
                                  editModel.reset();
                                  Navigator.pop(context);
                                } else {
                                  Utils.showToast(context, "发表失败");
                                }
                              });
                            }
                            posting = false;
                          }
                        }
                      } else if (title == "灵感") {
                        if (_editController.text.trim().isEmpty) {
                          Utils.showToast(context, "没有灵感？");
                        } else {
                          var data = {
                            "body": _editController.text.trim(),
                          };
                          if (!posting) {
                            posting = true;
                            await API
                                .postSparkle(context, data: data)
                                .then((res) {
                              if (res != null) {
                                Navigator.pop(context);
                                Utils.showToast(context, "广播成功");
                                editModel.reset();
                              } else {
                                Utils.showToast(context, "广播失败");
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
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                color: Colors.white,
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
                          title == "分享"
                              ? TextField(
                                  controller: _titleController,
                                  style: TextUtil.style(18, 500),
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 0),
                                    hintText: "标题",
                                    hintStyle: TextUtil.style(18, 500,
                                        color: Colors.grey),
                                  ),
                                  onChanged: (text) {
                                    if (text.isEmpty &&
                                        _editController.text.isEmpty &&
                                        editModel.domain == null &&
                                        _urlController.text.trim().isEmpty) {
                                      setState(() {
                                        title = "灵感";
                                      });
                                    } else if (!editModel.questionMarked &&
                                        text.contains(RegExp(r'[?？吗]'))) {
                                      editModel.addCategory(
                                          settingModel.getCategory("提问"));
                                      editModel.setQuestionMarked();
                                      setState(() {});
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
                                      isDense: true,
                                      border: InputBorder.none),
                                )
                              : VEmptyView(10),
                          TextField(
                            autofocus: true,
                            controller: _editController,
                            maxLines: 8,
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
                                    if (!editModel.questionMarked &&
                                        text.contains(RegExp(r'[?？吗]'))) {
                                      editModel.addCategory(
                                          settingModel.getCategory("提问"));
                                      editModel.setQuestionMarked();
                                    }

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
                          VEmptyView(50),
                        ],
                      ),
                    ),
                    title == "分享"
                        ? InkWell(
                            onTap: () {
                              NavigatorUtil.goDomainSearchPage(context,
                                  data:
                                      DomainSearchData(state: "precertified"));
                            },
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: ScreenUtil().setHeight(15)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
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
                                    ],
                                  ),
                                  categoryView,
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
        ),
      ),
    );
  }

  _buildCategoryGroups() {
    SettingModel settingModel = Provider.of<SettingModel>(context);
    EditModel editModel = Provider.of<EditModel>(context);
    Set<int> initCategories = editModel.categories;

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
                            selected: initCategories.contains(category.id),
                            onTap: () {
                              if (initCategories.contains(category.id)) {
                                editModel.removeCategory(category.id);
                              } else {
                                editModel.addCategory(category.id);
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

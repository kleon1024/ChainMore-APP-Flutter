import 'package:chainmore/models/domain_search.dart';
import 'package:chainmore/providers/domain_create_model.dart';
import 'package:chainmore/utils/colors.dart';
import 'package:chainmore/utils/navigator_util.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:chainmore/widgets/common_button.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:chainmore/widgets/h_empty_view.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CreateDomainPage extends StatefulWidget {
  @override
  _CreateDomainPageState createState() => _CreateDomainPageState();
}

class _CreateDomainPageState extends State<CreateDomainPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool init = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DomainCreateModel domainCreateModel =
        Provider.of<DomainCreateModel>(context);

    if (!init) {
      if (domainCreateModel.title != null && domainCreateModel.title != "") {
        _titleController.text = domainCreateModel.title;
      }
      if (domainCreateModel.bio != null && domainCreateModel.bio != "") {
        _bioController.text = domainCreateModel.bio;
      } else {
        _bioController.text = "";
      }
      init = true;
    }

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Container(
        padding: EdgeInsets.only(
            top: ScreenUtil().setHeight(350), right: ScreenUtil().setWidth(10)),
        child: Container(
          height: ScreenUtil().setHeight(80),
          width: ScreenUtil().setWidth(80),
          child: FloatingActionButton(
            elevation: 0,
            backgroundColor: Colors.black87,
            child: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: ScreenUtil().setHeight(50),
                  horizontal: ScreenUtil().setWidth(50)),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _titleController,
                    style: TextUtil.style(18, 600),
                    decoration: InputDecoration(
                      hintText: "领域名称",
                      hintStyle: TextUtil.style(18, 600, color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Text("100", style: TextUtil.style(14, 400)),
                      Flexible(
                        child: TextField(
                          controller: _bioController,
                          style: TextUtil.style(14, 400),
                          decoration: InputDecoration(
                            hintText: "人正在关注",
                            hintStyle:
                                TextUtil.style(14, 400, color: Colors.grey),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                  TextField(
                    controller: _descriptionController,
                    style: TextUtil.style(16, 400),
                    maxLines: 3,
                    minLines: 3,
                    decoration: InputDecoration(
                      hintText: "简单介绍",
                      hintStyle: TextUtil.style(16, 400, color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      NavigatorUtil.goDomainSearchPage(context,
                          data: DomainSearchData(state: "aggregate"));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: ScreenUtil().setHeight(15)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(domainCreateModel.aggregateDomain != null
                                  ? Icons.chevron_right
                                  : Icons.add),
                              HEmptyView(10),
                              Text(
                                  domainCreateModel.aggregateDomain != null
                                      ? "变更聚合    " + domainCreateModel.aggregateDomain.title
                                      : "添加聚合领域",
                                  style: TextUtil.style(15, 400)),
                            ],
                          ),
                          Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      NavigatorUtil.goDomainSearchPage(context,
                          data: DomainSearchData(state: "dependent"));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: ScreenUtil().setHeight(15)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(domainCreateModel.dependentDomain != null
                                  ? Icons.chevron_right
                                  : Icons.add),
                              HEmptyView(10),
                              Text(
                                  domainCreateModel.dependentDomain != null
                                      ? "变更前置    " + domainCreateModel.dependentDomain.title
                                      : "添加前置领域",
                                  style: TextUtil.style(15, 400)),
                            ],
                          ),
                          Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ),
//                InkWell(
//                  onTap: () {},
//                  child: Container(
//                    padding: EdgeInsets.symmetric(
//                        vertical: ScreenUtil().setHeight(15)),
//                    child: Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                      children: <Widget>[
//                        Row(
//                          children: <Widget>[
//                            Icon(Icons.add),
//                            HEmptyView(10),
//                            Text("添加认证规则", style: TextUtil.style(15, 400)),
//                          ],
//                        ),
//                        Icon(Icons.chevron_right),
//                      ],
//                    ),
//                  ),
//                ),
                  VEmptyView(600),
                  Consumer<DomainCreateModel>(
                    builder: (BuildContext context, DomainCreateModel value,
                        Widget child) {
                      return CommonButton(
                        color: CMColors.blueLonely,
                        textColor: Colors.white,
                        callback: () {
                          String title = _titleController.text.trim();
                          String bio = _bioController.text.trim();
                          String description = _descriptionController.text.trim();

                          if (title == "") {
                            Utils.showToast("名称不能为空");
                          }

                          value.setTitle(title);
                          value.setBio(bio);
                          value.setDescription(description);

                          value.createDomain(context).then((res) {
                            if (res) {
                              value.reset();
                              Navigator.of(context).pop();
                            }
                          });
                        },
                        content: '创建',
                        width: double.infinity,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

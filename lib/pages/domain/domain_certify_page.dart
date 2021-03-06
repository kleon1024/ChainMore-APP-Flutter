import 'package:chainmore/models/certify_rule.dart';
import 'package:chainmore/models/domain.dart';
import 'package:chainmore/models/login_config.dart';
import 'package:chainmore/network/apis.dart';
import 'package:chainmore/pages/domain/choiceproblem_page.dart';
import 'package:chainmore/pages/domain/empty_certify_page.dart';
import 'package:chainmore/providers/certify_model.dart';
import 'package:chainmore/providers/user_model.dart';
import 'package:chainmore/utils/colors.dart';
import 'package:chainmore/utils/navigator_util.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:chainmore/widgets/widget_future_builder.dart';
import 'package:chainmore/widgets/widget_simple_future_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class DomainCertifyPage extends StatefulWidget {
  final Domain domain;

  DomainCertifyPage(this.domain);

  @override
  _DomainCertifyPageState createState() => _DomainCertifyPageState();
}

class _DomainCertifyPageState extends State<DomainCertifyPage> {
  final _pageController = PageController(
    initialPage: 0,
  );

  int curPage = 0;
  int totalPage = 1;

  Future<List<Widget>> _pages;
  bool loaded = false;
  bool init = false;
  List<CertifyRule> _rules;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((d) {
      if (mounted) {
        initialize();
      }
    });
  }

  initialize() {
    CertifyModel certifyModel = Provider.of<CertifyModel>(context);

    if (certifyModel.hasRules() &&
        certifyModel.domain != null &&
        certifyModel.domain.id != 1) {
      Utils.showDoubleChoiceDialog(
        context,
        title: "历史认证",
        body: "你还有未完成的领域认证：" + certifyModel.domain.title + "，是否恢复？",
        rightText: "恢复",
        leftText: "丢弃",
        rightFunc: () {
          _rules = certifyModel.rules;
          Navigator.of(context).pop();
          _pages = getAndCreateWidgets(context);
        },
        leftFunc: () {
          certifyModel.reset();
          certifyModel.setDomain(widget.domain);
          Navigator.of(context).pop();
          _pages = getAndCreateWidgets(context);
        },
      );
    } else {
      certifyModel.setDomain(widget.domain);
      _pages = getAndCreateWidgets(context);
    }
  }

  Future<List<Widget>> getAndCreateWidgets(BuildContext context) async {
    List<Widget> pages = List<Widget>();

    CertifyModel certifyModel = Provider.of<CertifyModel>(context);
    if (_rules == null) {
      _rules =
          await API.getDomainCertify(context, params: {"id": widget.domain.id});
      setState(() {
        loaded = true;
      });

      certifyModel.setRules(_rules);
    }

    _rules.forEach((rule) => {
          if (rule.type == "choiceproblem")
            {
              rule.choiceproblems.forEach((choiceproblem) =>
                  {pages.add(ChoiceProblemPage(choiceproblem))})
            }
        });

    if (pages.length == 0) {
      pages.add(EmptyCertifyPage(certifyModel.domain.title));
    }

    setState(() {
      totalPage = pages.length;
    });

    return pages;
  }

  @override
  Widget build(BuildContext context) {
    CertifyModel certifyModel = Provider.of<CertifyModel>(context);

    return Scaffold(
      floatingActionButton: Container(
        padding: EdgeInsets.only(
            bottom: ScreenUtil().setHeight(150),
            right: ScreenUtil().setWidth(10)),
        child: Container(
          height: ScreenUtil().setHeight(360),
          width: ScreenUtil().setWidth(80),
          child: Column(
            children: <Widget>[
              FloatingActionButton(
                heroTag: "btn2",
                elevation: 0,
                backgroundColor: CMColors.blueLonely,
                child: Icon(Icons.done),
                onPressed: () {
                  Utils.showDoubleChoiceDialog(context,
                      title: "完成认证",
                      body: "如果认证不通过，将清空本次认证状态，确认提交？",
                      leftText: '不提交',
                      rightText: '提交', leftFunc: () {
                    Navigator.of(context).pop();
                  }, rightFunc: () {
                    certifyModel.certify(context).then((res) {
                      if (res) {
                        if (widget.domain.id == 1) {
                          UserModel userModel = Provider.of<UserModel>(context);
                          userModel.userInfo.rootCertified = true;
                        }
                        Utils.showToast(context, "认证成功");
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      } else {
                        Utils.showToast(context, "认证失败");
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      }
                      certifyModel.reset();
                    });
                  });
                },
              ),
              FloatingActionButton(
                heroTag: "btn1",
                elevation: 0,
                backgroundColor: Colors.black87,
                child: Icon(Icons.close),
                onPressed: () {
                  Utils.showDoubleChoiceDialog(context,
                      title: "放弃认证",
                      body: "是否保存本次认证状态？",
                      leftText: '不保存',
                      rightText: '保存', leftFunc: () {
                    certifyModel.reset();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  }, rightFunc: () {
                    certifyModel.saveState();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  });
                },
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            SimpleFutureBuilder<List<Widget>>(
                future: _pages,
                builder: (context, data) {
                  return Container(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          child: PageView(
                            controller: _pageController,
                            children: data,
                            onPageChanged: (int page) {
                              setState(() {
                                curPage = page;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            Align(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: ScreenUtil().setHeight(50)),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          _pageController.animateToPage(0,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut);
                        },
                        child: Icon(
                          Icons.fast_rewind,
                          size: ScreenUtil().setSp(100),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _pageController.animateToPage(curPage - 1,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut);
                        },
                        child: Icon(
                          Icons.chevron_left,
                          size: ScreenUtil().setSp(100),
                        ),
                      ),
                      Text((curPage + 1).toString() +
                          "/" +
                          totalPage.toString()),
                      InkWell(
                        onTap: () {
                          _pageController.animateToPage(curPage + 1,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut);
                        },
                        child: Icon(
                          Icons.chevron_right,
                          size: ScreenUtil().setSp(100),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _pageController.animateToPage(totalPage - 1,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut);
                        },
                        child: Icon(
                          Icons.fast_forward,
                          size: ScreenUtil().setSp(100),
                        ),
                      ),
                    ],
                  ),
                ),
                alignment: Alignment.bottomCenter)
          ],
        ),
      ),
    );
  }
}

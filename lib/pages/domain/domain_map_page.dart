import 'package:chainmore/models/certify_rule.dart';
import 'package:chainmore/models/domain.dart';
import 'package:chainmore/models/domain_tree.dart';
import 'package:chainmore/network/apis.dart';
import 'package:chainmore/pages/domain/choiceproblem_page.dart';
import 'package:chainmore/pages/domain/domain_tree_page.dart';
import 'package:chainmore/pages/domain/empty_certify_page.dart';
import 'package:chainmore/pages/home/discover/discover_page.dart';
import 'package:chainmore/pages/home/sparkle/sparkle_page.dart';
import 'package:chainmore/providers/certify_model.dart';
import 'package:chainmore/utils/colors.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:chainmore/widgets/h_empty_view.dart';
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

class _DomainMapPageState extends State<DomainMapPage>
    with AutomaticKeepAliveClientMixin {
  final _pageController = PageController();

  int _currentPage = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    TextStyle selectedStyle = TextUtil.style(18, 700);
    TextStyle unselectedStyle = TextUtil.style(16, 500);

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
          child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(100),
                vertical: ScreenUtil().setHeight(30)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(0,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut);
                  },
                  child: Text("聚合",
                      style:
                          _currentPage == 0 ? selectedStyle : unselectedStyle),
                ),
                HEmptyView(20),
                GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(1,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut);
                  },
                  child: Text("前置",
                      style:
                          _currentPage == 1 ? selectedStyle : unselectedStyle),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              children: [
                DomainTreePage(widget.domain, API.getDomainAggregateTree),
                DomainTreePage(widget.domain, API.getDomainDependentTree),
              ],
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
            ),
          ),
        ],
      )),
    );
  }
}

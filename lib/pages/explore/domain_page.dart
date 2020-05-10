import 'package:chainmore/widgets/cards/domain_card.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:flutter/material.dart';
import 'package:chainmore/utils/navigator_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ExploreDomainPage extends StatefulWidget {
  @override
  _ExploreDomainPageState createState() => _ExploreDomainPageState();
}

class _ExploreDomainPageState extends State<ExploreDomainPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(
            "发现领域",
            style: commonTitleTextStyle,
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.search,
                size: ScreenUtil().setWidth(70),
                color: Colors.black87,
              ),
              onPressed: () {
                NavigatorUtil.goSearchPage(context);
              },
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return DomainCard();
                },
                childCount: 4,
              ),
            ),
          ],
        ));
  }

  @override
  bool get wantKeepAlive => true;
}

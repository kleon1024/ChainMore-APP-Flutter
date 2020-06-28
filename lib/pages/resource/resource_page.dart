import 'package:chainmore/utils/navigator_util.dart';
import 'package:chainmore/utils/slivers.dart';
import 'package:chainmore/widgets/cards/resource_add_card.dart';
import 'package:chainmore/widgets/cards/resource_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResourcePage extends StatefulWidget {
  @override
  _ResourcePageState createState() => _ResourcePageState();
}

class _ResourcePageState extends State<ResourcePage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("资源管理", style: Theme.of(context).textTheme.subtitle1),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.filter_list,
              size: Theme.of(context).iconTheme.size,
            ),
            onPressed: () {
//              _onSelectClassifier();
            },
          ),
          IconButton(
            icon: Icon(
              Icons.search,
              size: Theme.of(context).iconTheme.size,
            ),
            onPressed: () {
              NavigatorUtil.goSearchPage(context);
            },
          ),
        ],
      ),
      body: CupertinoScrollbar(
        child: CustomScrollView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: <Widget>[
            SliverPersistentHeader(
              delegate: SliverHeaderDelegate(
                minHeight: ScreenUtil().setHeight(150),
                maxHeight: ScreenUtil().setHeight(150),
                child: ResourceAddCard(),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                ResourceCard(),
                ResourceCard(),
                ResourceCard(),
                ResourceCard(),
                ResourceCard(),
                ResourceCard(),
              ]),
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

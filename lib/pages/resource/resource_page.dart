import 'package:chainmore/utils/navigator_util.dart';
import 'package:chainmore/widgets/cards/resource_add_card.dart';
import 'package:chainmore/widgets/cards/resource_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        title: Text("资源管理", style: Theme.of(context).textTheme.headline6),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.select_all,
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
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  ResourceAddCard(),
                  ResourceCard(),
                ]
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

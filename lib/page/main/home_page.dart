import 'package:chainmore/model/global_model.dart';
import 'package:chainmore/model/home_page_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final globalModel = Provider.of<GlobalModel>(context);
    final model = Provider.of<HomePageModel>(context)
      ..setContext(context, globalModel: globalModel);

    globalModel.setHomePageModel(model);

    return Scaffold(
      key: model.scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        title: Text(tr("home_title"),
            style: Theme.of(context).textTheme.headline6),
        actions: [
          IconButton(
            icon: Icon(
              Icons.developer_board,
              size: Theme.of(context).iconTheme.size,
            ),
            onPressed: model.logic.onSearchTap,
          ),
          IconButton(
            icon: Icon(
              Icons.search,
              size: Theme.of(context).iconTheme.size,
            ),
            onPressed: () {
              showModalBottomSheet(context: context, builder: buildFilterPanel);
            },
          )
        ],
      ),
      body: CustomScrollView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: <Widget>[
          SliverAnimatedList(
            key: model.sliverAnimatedListKey,
            initialItemCount: model.elements.length,
            itemBuilder: (context, index, animation) {
              return model.elements[index];
            },
          ),
        ],
      ),
    );
  }

  Widget buildFilterPanel(BuildContext context) {
    return Container();
  }
}

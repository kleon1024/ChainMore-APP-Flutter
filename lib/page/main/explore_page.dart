import 'package:chainmore/model/explore_page_model.dart';
import 'package:chainmore/model/global_model.dart';
import 'package:chainmore/model/home_page_model.dart';
import 'package:chainmore/utils/params.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class ExplorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final globalModel = Provider.of<GlobalModel>(context);
    final model = Provider.of<ExplorePageModel>(context)
      ..setContext(context, globalModel: globalModel);

    globalModel.setExplorePageModel(model);

    return Scaffold(
      key: model.scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(GlobalParams.appBarHeight),
        child: AppBar(
          elevation: 0,
          title: Text(tr("explore_title"),
              style: Theme.of(context).textTheme.headline6),
          actions: [
            IconButton(
              icon: Icon(
                Icons.filter_list,
                size: Theme.of(context).iconTheme.size,
              ),
              onPressed: model.logic.onSearchTap,
            ),
            IconButton(
              icon: Icon(
                Icons.search,
                size: Theme.of(context).iconTheme.size,
              ),
              onPressed: model.logic.onSearchTap,
            )
          ],
        ),
      ),
    );
  }
}

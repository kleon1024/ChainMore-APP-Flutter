import 'package:chainmore/dao/collection_dao.dart';
import 'package:chainmore/dao/resource_dao.dart';
import 'package:chainmore/json/collection_bean.dart';
import 'package:chainmore/json/resource_bean.dart';
import 'package:chainmore/utils/navigator_util.dart';
import 'package:chainmore/utils/params.dart';
import 'package:chainmore/widgets/cards/collection_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CollectionManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CollectionDao dao = Provider.of<CollectionDao>(context);

    final List<CollectionBean> resources = dao.getAllCollections();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(GlobalParams.appBarHeight),
        child: AppBar(
          elevation: 0,
          title: Text(tr("collection_management"),
              style: Theme.of(context).textTheme.subtitle1),
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
                Icons.add,
                size: Theme.of(context).iconTheme.size,
              ),
              onPressed: () {
                NavigatorUtil.goSearchPage(context);
              },
            ),
          ],
        ),
      ),
      body: CupertinoScrollbar(
        child: CustomScrollView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: <Widget>[
            SliverAnimatedList(
              initialItemCount: resources.length,
              itemBuilder: (context, index, animation) {
                return CollectionCard(
                  bean: resources[index],
                  horizontalPadding: ScreenUtil().setWidth(30),
                  verticalPadding: ScreenUtil().setHeight(15),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

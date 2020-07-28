import 'package:chainmore/dao/user_dao.dart';
import 'package:chainmore/json/collection_bean.dart';
import 'package:chainmore/json/resource_bean.dart';
import 'package:chainmore/model/collection_detail_page_model.dart';
import 'package:chainmore/model/domain_detail_page_model.dart';
import 'package:chainmore/model/global_model.dart';
import 'package:chainmore/utils/params.dart';
import 'package:chainmore/utils/slivers.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:chainmore/widgets/cards/collection_card.dart';
import 'package:chainmore/widgets/cards/resource_card.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:chainmore/widgets/widget_load_footer.dart';
import 'package:chainmore/widgets/widget_load_header.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CollectionDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final globalModel = Provider.of<GlobalModel>(context);
    final model = Provider.of<CollectionDetailPageModel>(context)
      ..setContext(context, globalModel: globalModel);
    final collection = model.collection;
    final List<ResourceBean> resources = model.resources;

    return SafeArea(
      child: Scaffold(
        key: model.scaffoldKey,
        body: EasyRefresh(
          header: LoadHeader(),
          footer: LoadFooter(),
          controller: model.controller,
          onRefresh: () async {},
          onLoad: () async {},
          child: CustomScrollView(
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            slivers: <Widget>[
              SliverAppBar(
                toolbarHeight: GlobalParams.appBarHeight - 1,
                collapsedHeight: GlobalParams.appBarHeight,
                expandedHeight: GlobalParams.appBarHeight,
                centerTitle: true,
                pinned: true,
                elevation: 0,
                title: Text(
                  tr("collection_detail"),
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                floating: false,
                actions: [
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: Icon(
                      Icons.more_horiz,
                      size: Theme.of(context).iconTheme.size,
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return buildMorePanel(context, model);
                          });
                    },
                  ),
                ],
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setHeight(10),
                        horizontal: ScreenUtil().setWidth(15)),
                    child: Card(
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: ScreenUtil().setWidth(30),
                            horizontal: ScreenUtil().setWidth(30)),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                collection.title,
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              VEmptyView(10),
                              Text(Utils.readableTimeStamp(
                                  collection.modify_time)),
                              VEmptyView(10),
                              Text(
                                collection.description,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              VEmptyView(30),
                            ]),
                      ),
                    ),
                  ),
                ]),
              ),
//              SliverPersistentHeader(
//                delegate: SliverHeaderDelegate(
//                    minHeight: GlobalParams.appBarHeight,
//                    maxHeight: GlobalParams.appBarHeight,
//                    child: FlatButton(
//                      visualDensity: VisualDensity.compact,
//                      child: Align(
//                        alignment: Alignment.centerLeft,
//                        child: Row(
//                          children: [
//                            Text(tr("ordered_by")),
//                            Text(":"),
//                            Text(tr(model.order)),
//                          ],
//                        ),
//                      ),
//                      onPressed: () {},
//                    )),
//              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setHeight(10),
                        horizontal: ScreenUtil().setWidth(15)),
                    child: ResourceCard(
                      bean: resources[index],
                      horizontalPadding: ScreenUtil().setWidth(30),
                      verticalPadding: ScreenUtil().setHeight(15),
                    ),
                  );
                }, childCount: resources.length),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMorePanel(BuildContext context, CollectionDetailPageModel model) {
    final List<Widget> widgets = [
      VEmptyView(60),
    ];

    final user = Provider.of<UserDao>(context);

    debugPrint(user.id.toString());
    debugPrint(model.collection.author_id.toString());

    if (user.isLoggedIn) {
      if (user.id == model.collection.author_id) {
        widgets.add(FlatButton(
          child: Text(tr("modify_collection"),
              style: Theme.of(context).textTheme.headline6),
          onPressed: model.logic.editCollection,
        ));
      }
    }

    widgets.add(
        VEmptyView(60)
    );

    return Container(
      height: GlobalParams.appBarHeight * widgets.length,
      child: Column(
        children: widgets,
      ),
    );
  }
}

import 'package:chainmore/json/collection_bean.dart';
import 'package:chainmore/model/domain_detail_page_model.dart';
import 'package:chainmore/model/global_model.dart';
import 'package:chainmore/utils/params.dart';
import 'package:chainmore/utils/slivers.dart';
import 'package:chainmore/widgets/cards/collection_card.dart';
import 'package:chainmore/widgets/widget_load_footer.dart';
import 'package:chainmore/widgets/widget_load_header.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class DomainDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final globalModel = Provider.of<GlobalModel>(context);
    final model = Provider.of<DomainDetailPageModel>(context)
      ..setContext(context, globalModel: globalModel);
    final domain = model.domain;
    final List<CollectionBean> collections = model.elements;

    return SafeArea(
      child: Scaffold(
        key: model.scaffoldKey,
        body: EasyRefresh(
          header: LoadHeader(),
          footer: LoadFooter(),
          controller: model.controller,
          onRefresh: model.logic.refreshCollections,
          onLoad: model.logic.loadCollections,
          child: CustomScrollView(
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            slivers: <Widget>[
              SliverAppBar(
                toolbarHeight: GlobalParams.appBarHeight - 1,
                collapsedHeight: GlobalParams.appBarHeight,
                expandedHeight: GlobalParams.appBarHeight * 2,
                centerTitle: true,
                pinned: true,
                elevation: 0,
                title: Text(
                  domain.title,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                floating: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(30)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: GlobalParams.appBarHeight,
                        ),
                        Text(domain.intro)
                      ],
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: Icon(
                      Icons.developer_board,
                      size: Theme.of(context).iconTheme.size,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                      visualDensity: VisualDensity.compact,
                      icon: Icon(
                        Icons.search,
                        size: Theme.of(context).iconTheme.size,
                      ),
                      onPressed: () {})
                ],
              ),
              SliverPersistentHeader(
                delegate: SliverHeaderDelegate(
                    minHeight: GlobalParams.appBarHeight,
                    maxHeight: GlobalParams.appBarHeight,
                    child: FlatButton(
                      visualDensity: VisualDensity.compact,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Text(tr("ordered_by")),
                            Text(":"),
                            Text(tr(model.order)),
                          ],
                        ),
                      ),
                      onPressed: () {},
                    )),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setHeight(10),
                        horizontal: ScreenUtil().setWidth(15)),
                    child: CollectionCard(
                      bean: collections[index],
                      horizontalPadding: ScreenUtil().setWidth(30),
                      verticalPadding: ScreenUtil().setHeight(15),
                    ),
                  );
                }, childCount: collections.length),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

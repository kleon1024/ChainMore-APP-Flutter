import 'package:chainmore/dao/user_dao.dart';
import 'package:chainmore/json/collection_bean.dart';
import 'package:chainmore/model/domain_detail_page_model.dart';
import 'package:chainmore/model/global_model.dart';
import 'package:chainmore/utils/params.dart';
import 'package:chainmore/utils/slivers.dart';
import 'package:chainmore/widgets/cards/collection_card.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
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
    final model = Provider.of<DomainDetailPageModel>(context);
    final domain = model.domain;
    final List<CollectionBean> collections = model.elements;

    return WillPopScope(
      onWillPop: () async {
        model.pop();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          body: EasyRefresh(
            header: LoadHeader(),
            footer: LoadFooter(),
            controller: model.controller,
            onRefresh: model.logic.refreshCollections,
            onLoad: model.logic.loadCollections,
            child: CustomScrollView(
              physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              slivers: <Widget>[
                SliverAppBar(
                  toolbarHeight: GlobalParams.appBarHeight - 1,
                  collapsedHeight: GlobalParams.appBarHeight,
                  expandedHeight: GlobalParams.appBarHeight * 3,
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
                          Text(domain.intro ?? ""),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: Icon(Icons.bookmark_border,
                                    size: Theme.of(context).iconTheme.size),
                                onPressed: model.logic.onMarkDomain,
                              ),
                              IconButton(
                                icon: Icon(Icons.school,
                                    size: Theme.of(context).iconTheme.size),
                                onPressed: model.logic.onLearnDomain,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
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
      ),
    );
  }

  Widget buildMorePanel(BuildContext context, DomainDetailPageModel model) {
    final List<Widget> widgets = [
      VEmptyView(60),
    ];

    final user = Provider.of<UserDao>(context);

    debugPrint(user.id.toString());
    debugPrint(model.domain.creator_id.toString());

    if (user.isLoggedIn) {
      if (user.id == model.domain.creator_id) {
        widgets.add(FlatButton(
          child: Text(tr("modify_domain"),
              style: Theme.of(context).textTheme.headline6),
          onPressed: model.logic.editDomain,
        ));
      }
    }

    widgets.add(VEmptyView(60));

    return Container(
      height: GlobalParams.appBarHeight * widgets.length,
      child: Column(
        children: widgets,
      ),
    );
  }
}

import 'package:chainmore/dao/user_dao.dart';
import 'package:chainmore/json/collection_bean.dart';
import 'package:chainmore/json/resource_bean.dart';
import 'package:chainmore/model/collection_detail_page_model.dart';
import 'package:chainmore/model/domain_detail_page_model.dart';
import 'package:chainmore/model/global_model.dart';
import 'package:chainmore/model/resource_detail_page_model.dart';
import 'package:chainmore/pages/webview/web_view_page.dart';
import 'package:chainmore/utils/params.dart';
import 'package:chainmore/utils/slivers.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:chainmore/widgets/cards/collection_card.dart';
import 'package:chainmore/widgets/cards/resource_card.dart';
import 'package:chainmore/widgets/h_empty_view.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:chainmore/widgets/widget_load_footer.dart';
import 'package:chainmore/widgets/widget_load_header.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ResourceDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final globalModel = Provider.of<GlobalModel>(context);
    final model = Provider.of<ResourceDetailPageModel>(context)
      ..setContext(context, globalModel: globalModel);
    final resource = model.resource;
    final List<CollectionBean> collections = model.collections;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(GlobalParams.appBarHeight),
          child: AppBar(
            elevation: 0,
            title: Text(tr("resource_detail"),
                style: Theme.of(context).textTheme.subtitle1),
            centerTitle: true,
            key: model.scaffoldKey,
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
        ),
        body: EasyRefresh(
          header: LoadHeader(),
          footer: LoadFooter(),
          controller: model.controller,
          onRefresh: model.logic.refreshCollections,
          onLoad: model.logic.loadCollections,
          child: CustomScrollView(
            controller: model.appbarScrollController,
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            slivers: <Widget>[
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
                                resource.title,
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              VEmptyView(10),
                              Text(Utils.readableTimeStamp(
                                  resource.modify_time)),
                              VEmptyView(10),
                              GestureDetector(
                                child: Text(
                                  Utils.getShortUrl(resource.url),
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                onTap: () {
                                  Navigator.of(context).push(
                                      new CupertinoPageRoute(builder: (ctx) {
                                    return WebViewPage(url: resource.url);
                                  }));
                                },
                              ),
                              VEmptyView(30),
                            ]),
                      ),
                    ),
                  )
                ]),
              ),
              SliverPersistentHeader(
                delegate: SliverHeaderDelegate(
                  minHeight: GlobalParams.appBarHeight,
                  maxHeight: GlobalParams.appBarHeight,
                  child: model.collections.length > 0
                      ? FlatButton(
                          visualDensity: VisualDensity.compact,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Text(tr("reference_collections")),
                                Text(tr("ordered_by")),
                                Text(":"),
                                Text(tr(model.order)),
                              ],
                            ),
                          ),
                          onPressed: () {},
                        )
                      : HEmptyView(0),
                ),
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

  Widget buildMorePanel(BuildContext context, ResourceDetailPageModel model) {
    final List<Widget> widgets = [
      VEmptyView(60),
    ];

    final user = Provider.of<UserDao>(context);

    if (user.isLoggedIn) {
      if (user.id == model.resource.author_id) {
        widgets.add(FlatButton(
          child: Text(tr("modify_resource"),
              style: Theme.of(context).textTheme.headline6),
          onPressed: model.logic.editResource,
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

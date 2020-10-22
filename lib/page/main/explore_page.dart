import 'package:chainmore/json/domain_bean.dart';
import 'package:chainmore/model/explore_page_model.dart';
import 'package:chainmore/model/global_model.dart';
import 'package:chainmore/model/home_page_model.dart';
import 'package:chainmore/utils/params.dart';
import 'package:chainmore/utils/slivers.dart';
import 'package:chainmore/widgets/cards/domain_recommend_card.dart';
import 'package:chainmore/widgets/widget_load_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          ],
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        onVerticalDragDown: (drag) {
          FocusScope.of(context).unfocus();
        },
        child: EasyRefresh(
          header: LoadHeader(),
          onRefresh: () async {
            model.logic.getRecommendations();
          },
          child: CustomScrollView(
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            slivers: <Widget>[
              SliverPersistentHeader(
                delegate: SliverHeaderDelegate(
                  minHeight: GlobalParams.searchBarHeight,
                  maxHeight: GlobalParams.searchBarHeight,
                  child: GestureDetector(
                    onTap: model.logic.onSearchTap,
                    child: Container(
                      color: Theme.of(context).primaryColor,
                      padding: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setHeight(0),
                        horizontal: ScreenUtil().setWidth(10),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: ScreenUtil().setHeight(30),
                          horizontal: ScreenUtil().setWidth(10),
                        ),
                        child: TextField(
                          enabled: false,
                          onTap: model.logic.onSearchTap,
                          minLines: 1,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            isCollapsed: true,
                            hintText: tr("search_hint"),
                            prefixIcon: Icon(Icons.search,
                                size: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .fontSize),
                            prefixIconConstraints:
                                BoxConstraints.tight(Size.fromWidth(28)),
                            hintStyle:
                                Theme.of(context).textTheme.bodyText1.merge(
                                      TextStyle(
                                        color: Theme.of(context).disabledColor,
                                      ),
                                    ),
                            fillColor: Theme.of(context).highlightColor,
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: ScreenUtil().setWidth(15),
                                horizontal: ScreenUtil().setWidth(30)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10),
                                ),
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            disabledBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10),
                                ),
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10),
                                ),
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10),
                                ),
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final card = model.cards[index];
                    if (card is DomainBean) {
                      return Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: ScreenUtil().setHeight(15),
                            horizontal: ScreenUtil().setWidth(10),
                          ),
                          child: DomainRecommendCard(
                            bean: card,
                            horizontalPadding: ScreenUtil().setWidth(30),
                            verticalPadding: ScreenUtil().setHeight(30),
                          ));
                    } else {
                      return Container();
                    }
                  },
                  childCount: model.cards.length,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

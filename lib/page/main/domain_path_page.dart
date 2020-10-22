import 'package:chainmore/dao/domain_dao.dart';
import 'package:chainmore/json/domain_bean.dart';
import 'package:chainmore/model/domain_detail_page_model.dart';
import 'package:chainmore/page/main/domain_creation_page.dart';
import 'package:chainmore/utils/params.dart';
import 'package:chainmore/utils/slivers.dart';
import 'package:chainmore/widgets/cards/domain_card.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class DomainPathPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<DomainDetailPageModel>(context);
    final domains = model.learnDomains;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(GlobalParams.appBarHeight),
        child: AppBar(
          elevation: 0,
          title: Text(tr("learning_path"),
              style: Theme.of(context).textTheme.subtitle1),
          centerTitle: true,
          actions: <Widget>[
//            IconButton(
//              icon: Icon(
//                Icons.filter_list,
//                size: Theme.of(context).iconTheme.size,
//              ),
//              onPressed: () {
////              _onSelectClassifier();
//              },
//            ),
//            IconButton(
//              icon: Icon(
//                Icons.add,
//                size: Theme.of(context).iconTheme.size,
//              ),
//              onPressed: () {
//                Navigator.of(context)
//                    .push(CupertinoPageRoute(builder: (ctx) {
//                  return DomainCreationPage();
//                }));
//              },
//            ),
          ],
        ),
      ),
      body: CupertinoScrollbar(
        child: CustomScrollView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate([
                model.loadLearnDomains
                    ? CupertinoActivityIndicator()
                    : VEmptyView(0)
              ]),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setHeight(10),
                        horizontal: ScreenUtil().setWidth(15)),
                    child: DomainCard(
                      order: index + 1,
                      bean: domains[index],
                      horizontalPadding: ScreenUtil().setWidth(30),
                      verticalPadding: ScreenUtil().setHeight(15),
                    ),
                  );
                },
                childCount: domains.length,
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: ScreenUtil().setHeight(10),
                      horizontal: ScreenUtil().setWidth(15)),
                  child: Card(
                    margin: EdgeInsets.zero,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setHeight(45),
                        horizontal: ScreenUtil().setWidth(30),
                      ),
                      child: Center(
                        child: Text(tr("start_to_learn"), style: Theme.of(context).textTheme.subtitle1),
                      ),
                    ),
                  ),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}

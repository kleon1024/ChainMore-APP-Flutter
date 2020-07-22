import 'package:chainmore/dao/domain_dao.dart';
import 'package:chainmore/json/domain_bean.dart';
import 'package:chainmore/page/main/domain_creation_page.dart';
import 'package:chainmore/utils/navigator_util.dart';
import 'package:chainmore/utils/params.dart';
import 'package:chainmore/widgets/cards/domain_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class DomainManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DomainDao dao = Provider.of<DomainDao>(context);

    final List<DomainBean> domains = dao.getMarkedDomains();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(GlobalParams.appBarHeight),
        child: AppBar(
          elevation: 0,
          title: Text(tr("domain_management"),
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
                Navigator.of(context)
                    .push(CupertinoPageRoute(builder: (ctx) {
                  return DomainCreationPage();
                }));
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
              initialItemCount: domains.length,
              itemBuilder: (context, index, animation) {
                return Container(
                  padding: EdgeInsets.symmetric(
                      vertical: ScreenUtil().setHeight(10),
                      horizontal: ScreenUtil().setWidth(15)),
                  child: DomainCard(
                    bean: domains[index],
                    horizontalPadding: ScreenUtil().setWidth(30),
                    verticalPadding: ScreenUtil().setHeight(15),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

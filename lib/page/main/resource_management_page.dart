import 'package:chainmore/dao/resource_dao.dart';
import 'package:chainmore/json/resource_bean.dart';
import 'package:chainmore/page/main/resource_creation_page.dart';
import 'package:chainmore/utils/navigator_util.dart';
import 'package:chainmore/utils/params.dart';
import 'package:chainmore/widgets/animation/custom_slidable.dart';
import 'package:chainmore/widgets/cards/resource_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ResourceManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ResourceDao dao = Provider.of<ResourceDao>(context);

    final List<ResourceBean> resources = dao.getCollectedResources();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(GlobalParams.appBarHeight),
        child: AppBar(
          elevation: 0,
          title: Text(tr("resource_management"),
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
            IconButton(
              icon: Icon(
                Icons.add,
                size: Theme.of(context).iconTheme.size,
              ),
              onPressed: () {
                Navigator.of(context)
                    .push(CupertinoPageRoute(builder: (ctx) {
                  return ResourceCreationPage();
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
              initialItemCount: resources.length,
              itemBuilder: (context, index, animation) {
                return Container(
                  padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(10), horizontal: ScreenUtil().setWidth(15)),
                  child: CustomSlidable(
                    onDismissed: () {},
                    child: ResourceCard(
                      bean: resources[index],
                      horizontalPadding: ScreenUtil().setWidth(30),
                      verticalPadding: ScreenUtil().setHeight(15),
                    ),
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

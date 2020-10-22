import 'package:chainmore/dao/user_dao.dart';
import 'package:chainmore/model/global_model.dart';
import 'package:chainmore/model/home_page_model.dart';
import 'package:chainmore/utils/params.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:chainmore/widgets/widget_load_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/ball_pulse_header.dart';
import 'package:flutter_easyrefresh/bezier_hour_glass_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final globalModel = Provider.of<GlobalModel>(context);
    final model = Provider.of<HomePageModel>(context)
      ..setContext(context, globalModel: globalModel);
    final userDao = Provider.of<UserDao>(context);

    globalModel.setHomePageModel(model);

    return Scaffold(
      key: model.scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(GlobalParams.appBarHeight),
        child: AppBar(
          elevation: 0,
          title: Text(tr("home_title"),
              style: Theme.of(context).textTheme.headline6),
          actions: [
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: Icon(
                Icons.developer_board,
                size: Theme.of(context).iconTheme.size,
              ),
              onPressed: () {
                showModalBottomSheet(
                    context: context, builder: buildFilterPanel);
              },
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: Icon(
                Icons.search,
                size: Theme.of(context).iconTheme.size,
              ),
              onPressed: model.logic.onSearchTap,
            )
          ],
        ),
      ),
      body: EasyRefresh(
        header: LoadHeader(),
        onRefresh: () async {
          await userDao.syncAll();
        },
        child: CustomScrollView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Container(
                      padding: EdgeInsets.symmetric(
                          vertical: ScreenUtil().setHeight(10)),
                      child: model.elements[index]);
                },
                childCount: model.elements.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFilterPanel(BuildContext context) {
    return Container();
  }
}

import 'package:chainmore/config/provider_config.dart';
import 'package:chainmore/dao/resource_dao.dart';
import 'package:chainmore/json/resource_bean.dart';
import 'package:chainmore/page/main/resource_creation_page.dart';
import 'package:chainmore/page/main/resource_management_page.dart';
import 'package:chainmore/widgets/animation/custom_slidable.dart';
import 'package:chainmore/widgets/cards/resource_card.dart';
import 'package:chainmore/widgets/separator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ResourceView extends StatelessWidget {
  final void Function(dynamic) onRemove;
  final void Function() onShared;
  final void Function() onMore;
  final void Function() onTap;

  ResourceView({
    this.onRemove,
    this.onShared,
    this.onMore,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ResourceDao dao = Provider.of<ResourceDao>(context);

    /// TODO: Change to global setting
    List<ResourceBean> resources = dao.resources.take(2).toList();

    return Card(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(30)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: ScreenUtil().setWidth(10)),
              child: Text(
                tr("resource"),
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ResourceCard(elevation: 0, bean: resources[index]);
              },
              itemCount: resources.length,
              separatorBuilder: (context, index) {
                return Separator();
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.of(context)
                        .push(CupertinoPageRoute(builder: (ctx) {
                      return ProviderConfig.getInstance()
                          .getResourceCreationPage();
                    }));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.clear_all),
                  onPressed: () {
                    Navigator.of(context)
                        .push(CupertinoPageRoute(builder: (ctx) {
                      return ResourceManagementPage();
                    }));
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

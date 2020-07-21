import 'package:chainmore/config/provider_config.dart';
import 'package:chainmore/dao/collection_dao.dart';
import 'package:chainmore/dao/domain_dao.dart';
import 'package:chainmore/dao/resource_dao.dart';
import 'package:chainmore/json/collection_bean.dart';
import 'package:chainmore/json/domain_bean.dart';
import 'package:chainmore/json/resource_bean.dart';
import 'package:chainmore/page/main/collection_management_page.dart';
import 'package:chainmore/page/main/domain_creation_page.dart';
import 'package:chainmore/page/main/domain_management_page.dart';
import 'package:chainmore/page/main/resource_creation_page.dart';
import 'package:chainmore/page/main/resource_management_page.dart';
import 'package:chainmore/widgets/animation/custom_slidable.dart';
import 'package:chainmore/widgets/cards/collection_card.dart';
import 'package:chainmore/widgets/cards/domain_card.dart';
import 'package:chainmore/widgets/cards/resource_card.dart';
import 'package:chainmore/widgets/separator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class DomainView extends StatelessWidget {
  final void Function(dynamic) onRemove;
  final void Function() onShared;
  final void Function() onMore;
  final void Function() onTap;

  DomainView({
    this.onRemove,
    this.onShared,
    this.onMore,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    DomainDao dao = Provider.of<DomainDao>(context);

    /// TODO: Change to global setting
    List<DomainBean> resources = dao.domains.take(2).toList();

    return Card(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(30)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(15)),
              child: Text(
                tr("domain"),
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return DomainCard(elevation: 0, bean: resources[index]);
              },
              itemCount: resources.length,
              separatorBuilder: (context, index) {
                return Separator();
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.of(context)
                        .push(CupertinoPageRoute(builder: (ctx) {
                      return DomainCreationPage();
                    }));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.clear_all),
                  onPressed: () {
                    Navigator.of(context)
                        .push(CupertinoPageRoute(builder: (ctx) {
                      return DomainManagementPage();
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

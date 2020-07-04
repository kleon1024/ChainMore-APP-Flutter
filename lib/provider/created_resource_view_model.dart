import 'package:chainmore/dao/resource_dao.dart';
import 'package:chainmore/provider/view_model.dart';
import 'package:chainmore/route/routes.dart';
import 'package:chainmore/utils/types.dart';
import 'package:chainmore/widgets/animation/custom_slidable.dart';
import 'package:chainmore/widgets/cards/resource_card.dart';
import 'package:flutter/material.dart';
import 'package:chainmore/json/resource_bean.dart';

class CreatedResourceViewModel extends ViewModel {
  final int index;
  final void Function() onTap;
  final void Function(int) onDismissed;
  final void Function() onShared;
  final void Function() onMore;

  CreatedResourceViewModel({
    this.index,
    this.onTap,
    this.onDismissed,
    this.onShared,
    this.onMore,
  });

  /// Model
  List<ResourceBean> resources;

  /// Render
  buildView(BuildContext context, int index) {
    return CustomSlidable(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ResourceCard(bean: resources[index]);
              },
              itemCount: resources.length,
            ),
          ],
        )
    );
  }

  /// Logic
  void update(ResourceDao dao) {
    /// TODO: Change to Global Setting
    resources.addAll(dao.resources.take(3));
  }
}

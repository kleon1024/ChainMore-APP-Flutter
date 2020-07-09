import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:easy_localization/easy_localization.dart';

class CustomSlidable extends StatelessWidget {
  final void Function() onDismissed;
  final void Function() onWillDismissed;
  final void Function() onShared;
  final void Function() onMore;
  final Widget child;

  CustomSlidable({
    Key key,
    this.child,
    this.onDismissed,
    this.onWillDismissed,
    this.onShared,
    this.onMore,
  })  : assert(child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final slidableKey = GlobalKey<SlidableState>();

    return GestureDetector(
      onLongPress: onMore,
      child: Slidable(
          key: slidableKey,
          actionPane: SlidableBehindActionPane(),
          actionExtentRatio: 0.2,
          showAllActionsThreshold: 0.2,
          dismissal: SlidableDismissal(
            dismissThresholds: <SlideActionType, double>{
              SlideActionType.secondary: 0.99,
              SlideActionType.primary: 0.5,
            },
            child: SlidableDrawerDismissal(),
            onWillDismiss: (type) {
              return false;
            },
            onDismissed: (type) {
              onDismissed();
            },
          ),
          actions: [
            IconSlideAction(
              caption: tr("archive"),
              color: Colors.transparent,
              icon: Icons.check,
              onTap: () {
                slidableKey.currentState
                    .dismiss(actionType: SlideActionType.primary);
              },
            ),
          ],
          secondaryActions: [
            IconSlideAction(
              caption: tr('share'),
              color: Colors.transparent,
              icon: Icons.call_made,
              onTap: onMore,
            )
          ],
          child: child),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:easy_localization/easy_localization.dart';

class InfoSlidable extends StatelessWidget {

  final int index;
  final void Function(int) onDismissed;
  final void Function() onShared;
  final void Function() onMore;
  final Widget child;

  InfoSlidable(
      {Key key, this.index, this.child, this.onDismissed, this.onShared, this.onMore})
      : assert(child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final slidableKey = GlobalKey<SlidableState>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(30)),
      child: GestureDetector(
        onLongPress: onMore,
        child: Slidable(
            key: slidableKey,
            actionPane: SlidableBehindActionPane(),
            actionExtentRatio: 0.2,
            showAllActionsThreshold: 0.2,
            dismissal: SlidableDismissal(
              dismissThresholds: <SlideActionType, double>{
                SlideActionType.secondary: 1,
                SlideActionType.primary: 0.3,
              },
              child: SlidableDrawerDismissal(),
              onWillDismiss: (type) {
                return false;
              },
              onDismissed: (type) {
                onDismissed(index);
              },
            ),
            actions: [
              IconSlideAction(
                caption: tr("Archive"),
                color: Colors.transparent,
                icon: Icons.check,
                onTap: () {
                  slidableKey.currentState.dismiss(
                      actionType: SlideActionType.primary);
                },
              ),
            ],
            secondaryActions: [
              IconSlideAction(
                caption: tr('Share'),
                color: Colors.transparent,
                icon: Icons.share,
                onTap: onMore,
              )
            ],
            child: child
        ),
      ),
    );
  }
}
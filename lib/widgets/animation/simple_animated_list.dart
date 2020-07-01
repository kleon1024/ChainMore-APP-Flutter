import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef OnActionFinished = int Function(int index);
typedef AnimateFinishedCallBack = void Function(int index);

/// Insert from top/bottom, remove from anywhere
class SimpleAnimatedList extends StatefulWidget {
  final IndexedWidgetBuilder itemBuilder;
  final OnActionFinished onActionFinished;

  final int itemCount;

  final Axis scrollDirection;
  final bool reverse;
  final ScrollController controller;
  final bool primary;
  final ScrollPhysics physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry padding;

  SimpleAnimatedList({
    Key key,
    @required this.itemCount,
    @required this.itemBuilder,
    @required this.onActionFinished,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SimpleAnimatedListState();
  }
}

class _SimpleAnimatedListState<T> extends State<SimpleAnimatedList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.itemCount,
        scrollDirection: widget.scrollDirection,
        reverse: widget.reverse,
        controller: widget.controller,
        primary: widget.primary,
        physics: (widget.physics != null
            ? widget.physics
            : BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics())),
        shrinkWrap: widget.shrinkWrap,
        padding: widget.padding,
        itemBuilder: (context, index) {
          return _ListItem(
            index,
            widget.itemBuilder(context, index),
            removeTargetItem,
          );
        });
  }

  void removeTargetItem(int index) {
    widget.onActionFinished(index);
    setState(() {
//      widget.itemCount =
    });
  }

  void insertItem(int index) {

  }
}

class _ListItem extends StatefulWidget {
  final int index;
  final Widget child;
  final AnimateFinishedCallBack onAnimateFinished;

  _ListItem(this.index, this.child, this.onAnimateFinished, {Key key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ListItemState();
  }
}

class _ListItemState extends State<_ListItem> with TickerProviderStateMixin {
  bool _slideEnd = false;
  bool _sizeEnd = false;

  Size _size;

  AnimationController _slideController;
  AnimationController _sizeController;

  Animation<Offset> _slideAnimation;
  Animation<double> _sizeAnimation;

  @override
  void initState() {
    super.initState();
    initSlideAnimation();
    initSizeAnimation();
    WidgetsBinding.instance.addPostFrameCallback(onAfterRender);
  }

  @override
  void didUpdateWidget(_ListItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback(onAfterRender);
  }

  void initSlideAnimation() {
    _slideController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    _slideAnimation = Tween(begin: Offset(0.0, 0.0), end: Offset(-1.0, 0.0))
        .animate(
            CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
  }

  void initSizeAnimation() {
    _sizeController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    _sizeAnimation = Tween(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(parent: _sizeController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    super.dispose();
    _slideController.dispose();
    _sizeController.dispose();
  }

  void onAfterRender(Duration timeStamp) {
    _size = context.size;
  }

  void startRemoveAnimation() {
    _slideController.forward().whenComplete(() {
      setState(() {
        _slideEnd = true;
        _sizeController.forward().whenComplete(() {
          _sizeEnd = true;
          widget.onAnimateFinished(widget.index);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildItem();
  }

  Widget buildItem() {
    if (_slideEnd && _sizeEnd) {
      _slideController.value = 0.0;
      _sizeController.value = 0.0;
      _slideEnd = false;
      _sizeEnd = false;
    }
    return (_slideEnd
        ? SizeTransition(
            axis: Axis.vertical,
            sizeFactor: _sizeAnimation,
            child: Material(
              color: Colors.transparent,
              child: SizedBox.fromSize(size: _size),
            ),
          )
        : SlideTransition(
            position: _slideAnimation,
            child: widget.child,
          ));
  }
}

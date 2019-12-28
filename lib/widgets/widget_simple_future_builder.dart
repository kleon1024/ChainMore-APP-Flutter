import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chainmore/widgets/widget_net_error.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef ValueWidgetBuilder<T> = Widget Function(
  BuildContext context,
  T value,
);


class SimpleFutureBuilder<T> extends StatefulWidget {
  final ValueWidgetBuilder<T> builder;
  final Future future;
  final Widget loadingWidget;

  SimpleFutureBuilder({
    @required this.future,
    @required this.builder,
    Widget loadingWidget,
  }) : loadingWidget = loadingWidget ??
            Container(
              alignment: Alignment.center,
              height: ScreenUtil().setWidth(200),
              child: CupertinoActivityIndicator(),
            );

  @override
  _SimpleFutureBuilderState<T> createState() => _SimpleFutureBuilderState<T>();
}

class _SimpleFutureBuilderState<T> extends State<SimpleFutureBuilder<T>> {

  @override
  Widget build(BuildContext context) {
    return widget.future == null
        ? widget.loadingWidget
        : FutureBuilder(
            future: widget.future,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                case ConnectionState.active:
                  return widget.loadingWidget;
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    return widget.builder(context, snapshot.data);
                  } else if (snapshot.hasError) {
                    return NetErrorWidget(
                      callback: () {},
                    );
                  }
              }
              return Container();
            },
          );
  }
}

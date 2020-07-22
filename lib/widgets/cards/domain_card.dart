import 'package:chainmore/json/domain_bean.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DomainCard extends StatelessWidget {
  final DomainBean bean;
  final double verticalPadding;
  final double horizontalPadding;
  final double elevation;
  final void Function() onLongPress;
  final Color color;
  final CrossAxisAlignment crossAxisAlignment;

  DomainCard({
    Key key,
    this.elevation,
    this.bean,
    this.verticalPadding = 5.0,
    this.horizontalPadding = 0.0,
    this.onLongPress,
    this.color,
    this.crossAxisAlignment,
  })  : assert(bean != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        /// TODO Go Domain Detail Page
      },
      child: Container(
        child: Card(
          margin: EdgeInsets.zero,
          color: color ?? Theme.of(context).cardColor,
          elevation: elevation,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: verticalPadding,
              horizontal: horizontalPadding,
            ),
            child: Column(
              crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
              children: [
                Text(
                  bean.title,
                  style: Theme.of(context).textTheme.bodyText1,
                  overflow: TextOverflow.ellipsis,
                ),
                VEmptyView(15),
                Text(
                  bean.intro ?? "",
                  style: Theme.of(context).textTheme.bodyText2,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  maxLines: 3,
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

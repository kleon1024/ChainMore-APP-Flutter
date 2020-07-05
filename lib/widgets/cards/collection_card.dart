import 'package:chainmore/json/collection_bean.dart';
import 'package:chainmore/utils/params.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:chainmore/widgets/indicators/percent_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CollectionCard extends StatelessWidget {
  final CollectionBean bean;
  final double verticalPadding;
  final double horizontalPadding;
  final double elevation;
  final void Function() onLongPress;

  CollectionCard({
    Key key,
    this.elevation,
    this.bean,
    this.verticalPadding = 0.0,
    this.horizontalPadding = 0.0,
    this.onLongPress,
  })  : assert(bean != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        /// Go collection detail
      },
      onLongPress: onLongPress,
      child: Container(
//        height: GlobalParams.resourceCardHeight,
        child: Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(30)),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: verticalPadding,
              horizontal: horizontalPadding,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "HTML入门",
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.play_circle_outline,
                          size: GlobalParams.collectionTopBarIconSize,
                        ),
                        Icon(
                          Icons.book,
                          size: GlobalParams.collectionTopBarIconSize,
                        ),
                        Icon(
                          Icons.audiotrack,
                          size: GlobalParams.collectionTopBarIconSize,
                        ),
                      ],
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            bean.title,
                            style: Theme.of(context).textTheme.bodyText1,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            Utils.readableTimeStamp(bean.modify_time),
                            style: Theme.of(context).textTheme.bodyText2,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: PercentIndicator([
                          0.1,
                          0.4,
                          0.4,
                          0.1,
                        ]),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

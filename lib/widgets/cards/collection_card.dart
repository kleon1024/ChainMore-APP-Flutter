import 'package:chainmore/config/provider_config.dart';
import 'package:chainmore/json/collection_bean.dart';
import 'package:chainmore/utils/params.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:chainmore/widgets/indicators/percent_indicator.dart';
import 'package:chainmore/widgets/indicators/resource_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CollectionCard extends StatelessWidget {
  final CollectionBean bean;
  final double verticalPadding;
  final double horizontalPadding;
  final double elevation;
  final void Function() onLongPress;
  final Color color;

  CollectionCard({
    Key key,
    this.elevation,
    this.bean,
    this.verticalPadding = 5.0,
    this.horizontalPadding = 0.0,
    this.onLongPress,
    this.color,
  })  : assert(bean != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(new CupertinoPageRoute(builder: (ctx) {
          return ProviderConfig.getInstance().getCollectionDetailPage(bean);
        }));
      },
      onLongPress: onLongPress,
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
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(bean.domain_title,
                        style: Theme.of(context).textTheme.bodyText2),
//                    Row(
//                      children: [
//                        ResourceIndicator(Icons.play_circle_outline),
//                        ResourceIndicator(Icons.font_download),
//                        ResourceIndicator(Icons.text_fields),
//                        ResourceIndicator(Icons.settings_voice),
//                        ResourceIndicator(Icons.music_note),
//                        ResourceIndicator(Icons.image)
//                      ],
//                    )
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
                            style: Theme.of(context).textTheme.bodyText1.merge(
                                  TextStyle(fontWeight: FontWeight.w600),
                                ),
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
//                    Expanded(
//                      flex: 1,
//                      child: Container(
//                        alignment: Alignment.centerRight,
//                        child: PercentIndicator([
//                          0.1,
//                          0.4,
//                          0.4,
//                          0.1,
//                        ]),
//                      ),
//                    ),
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

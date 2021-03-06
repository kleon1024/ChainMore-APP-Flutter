import 'package:cached_network_image/cached_network_image.dart';
import 'package:chainmore/pages/home/discover/discover_page.dart';
import 'package:chainmore/pages/home/personal_drawer.dart';
import 'package:chainmore/pages/home/sparkle/sparkle_page.dart';
import 'package:chainmore/providers/setting_model.dart';
import 'package:chainmore/utils/colors.dart';
import 'package:chainmore/widgets/cards/circle_cached_image_card.dart';
import 'package:chainmore/widgets/cards/explore_card.dart';
import 'package:chainmore/widgets/cards/setting_entry_card.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:chainmore/widgets/h_empty_view.dart';
import 'package:chainmore/widgets/widget_category_tag_selectable.dart';
import 'package:flutter/material.dart';
import 'package:chainmore/utils/navigator_util.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(
            "设置",
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        body: CustomScrollView(
        physics: BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  VEmptyView(50),
                  SettingEntryCard(),
                ]
              ),
            )
          ],
        )
    );
  }

  @override
  bool get wantKeepAlive => true;
}

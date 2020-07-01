import 'package:cached_network_image/cached_network_image.dart';
import 'package:chainmore/pages/home/discover/discover_page.dart';
import 'package:chainmore/pages/home/personal_drawer.dart';
import 'package:chainmore/pages/home/sparkle/sparkle_page.dart';
import 'package:chainmore/providers/setting_model.dart';
import 'package:chainmore/utils/colors.dart';
import 'package:chainmore/widgets/animation/animation_item.dart';
import 'package:chainmore/widgets/cards/circle_cached_image_card.dart';
import 'package:chainmore/widgets/cards/default_card.dart';
import 'package:chainmore/widgets/cards/roadmap_progress_card.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:chainmore/widgets/h_empty_view.dart';
import 'package:chainmore/widgets/widget_category_tag_selectable.dart';
import 'package:flutter/material.dart';
import 'package:chainmore/utils/navigator_util.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class OldHomePage extends StatefulWidget {
  @override
  _OldHomePageState createState() => _OldHomePageState();
}

// Keeps a Dart [List] in sync with an [AnimatedList].
//
// The [insert] and [removeAt] methods apply to both the internal list and
// the animated list that belongs to [listKey].
//
// This class only exposes as much of the Dart List API as is needed by the
// sample app. More list methods are easily added, however methods that
// mutate the list must make the same changes to the animated list in terms
// of [AnimatedListState.insertItem] and [AnimatedList.removeItem].
class ListModel<E> {
  ListModel({
    @required this.listKey,
    @required this.removedItemBuilder,
    Iterable<E> initialItems,
  })  : assert(listKey != null),
        assert(removedItemBuilder != null),
        _items = List<E>.from(initialItems ?? <E>[]);

  final GlobalKey<SliverAnimatedListState> listKey;
  final dynamic removedItemBuilder;
  final List<E> _items;

  SliverAnimatedListState get _animatedList => listKey.currentState;

  void insert(int index, E item) {
    _items.insert(index, item);
    _animatedList.insertItem(index);
  }

  E removeAt(int index) {
    final E removedItem = _items.removeAt(index);
    if (removedItem != null) {
      _animatedList.removeItem(
        index,
        (BuildContext context, Animation<double> animation) =>
            removedItemBuilder(removedItem, context, animation),
      );
    }
    return removedItem;
  }

  int get length => _items.length;

  E operator [](int index) => _items[index];

  int indexOf(E item) => _items.indexOf(item);
}

class _OldHomePageState extends State<OldHomePage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ListModel<dynamic> _list;

  final GlobalKey<SliverAnimatedListState> _listKey =
      GlobalKey<SliverAnimatedListState>();

  @override
  void initState() {
    super.initState();
    _list = ListModel<dynamic>(
      listKey: _listKey,
      initialItems: <dynamic>[],
      removedItemBuilder: _buildRemovedItem,
    );
  }

  // Used to build an item after it has been removed from the list. This
  // method is needed because a removed item remains visible until its
  // animation has completed (even though it's gone as far this ListModel is
  // concerned). The widget will be used by the
  // [AnimatedListState.removeItem] method's
  // [AnimatedListRemovedItemBuilder] parameter.
  Widget _buildRemovedItem(
      item, BuildContext context, Animation<double> animation) {
    return AnimationItem(
      animation: animation,
      child: item,
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Build Home Page");
    super.build(context);

    AppBar appbar = AppBar(
      elevation: 0,
//      leading: CircleCachedImageCard(
//        onTap: () {
//          _scaffoldKey.currentState.openDrawer();
//        },
//      ),
      title: Text(
        "聚焦",
        style: Theme.of(context).textTheme.headline6,
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.filter_list,
            size: ScreenUtil().setWidth(70),
          ),
          onPressed: () {
            _onSelectClassifier();
          },
        ),
        IconButton(
          icon: Icon(
            Icons.search,
            size: ScreenUtil().setWidth(70),
          ),
          onPressed: () {
            NavigatorUtil.goSearchPage(context);
          },
        ),
      ],
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: appbar,
//      drawer: Drawer(
//        child: PersonalDrawer(),
//      ),
      body: CustomScrollView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: <Widget>[
//          SliverList(
//            delegate: SliverChildListDelegate([
//              DefaultCard(),
//              RoadmapProgressCard(),
//            ]),
//          ),
          SliverAnimatedList(
            key: _listKey,
            initialItemCount: _list.length,
            itemBuilder: _buildItem,
          ),
        ],
      ),
    );
  }

  // Used to build list items that haven't been removed.
  Widget _buildItem(
      BuildContext context, int index, Animation<double> animation) {
    return AnimationItem(
      animation: animation,
      child: _list[index],
    );
  }

  void _onSelectClassifier() {
    var widgets = <Widget>[
      Container(
        padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(30)),
        child: Text(
          "过滤选项",
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ),
    ];

    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              height: ScreenUtil().setHeight(780),
              child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: ScreenUtil().setWidth(30),
                      horizontal: ScreenUtil().setHeight(80)),
                  child: Column(children: widgets)));
        }).then((res) {});
  }

  @override
  bool get wantKeepAlive => true;
}

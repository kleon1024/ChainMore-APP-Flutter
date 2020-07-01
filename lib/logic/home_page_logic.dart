import 'package:chainmore/config/provider_config.dart';
import 'package:chainmore/model/home_page_model.dart';
import 'package:chainmore/widgets/cards/roadmap_progress_card.dart';
import 'file:///D:/project/ChainMore/ChainMore-APP-Flutter/lib/pages/old_home_page.dart';
import 'package:flutter/cupertino.dart';

class HomePageLogic {
  final HomePageModel _model;

  HomePageLogic(this._model);

  void onSearchTap() {
    Navigator.of(_model.context).push(new CupertinoPageRoute(builder: (ctx) {
      return ProviderConfig.getInstance().getSearchPage();
    }));
  }

  insertCard(index) {
    _model.cards.insert(index, 1);
    _model.sliverAnimatedListKey.currentState.insertItem(index);
  }

  removeCard(index) async {
    final removedItem = _model.cards.removeAt(index);
    if (removedItem != null) {
      _model.sliverAnimatedListKey.currentState.removeItem(index,
          (context, animation) {
        return SizeTransition(
          sizeFactor: animation,
          child: SlideTransition(
            position: Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0)).animate(animation),
            child: RoadmapProgressCard(index: removedItem),
          ),
        );
      }, duration: Duration(milliseconds: 1000));
    }
  }
}

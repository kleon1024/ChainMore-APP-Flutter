import 'package:chainmore/model/main_page_model.dart';

class MainPageLogic {
  final MainPageModel _model;

  MainPageLogic(this._model);

  void onBottomNavigationItemTapped(int index) {
    _model.currentIndex = index;
    _model.refresh();
  }
}
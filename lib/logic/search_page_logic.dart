import 'package:chainmore/config/provider_config.dart';
import 'package:chainmore/model/home_page_model.dart';
import 'package:chainmore/model/search_page_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'file:///D:/project/ChainMore/ChainMore-APP-Flutter/lib/pages/old_home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPageLogic {
  final SearchPageModel _model;

  SearchPageLogic(this._model);

  onSearchFieldChanged(String text) {
    if (text.isEmpty) {
      this._model.isSearching = false;
      _model.refresh();
    }
  }

  onClearHistory() {
    showDialog(
        context: _model.context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              tr("confirm_to_clear_search_history"),
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(tr("cancel")),
              ),
              FlatButton(
                onPressed: () {
                  this._model.historySearchList.clear();
                },
                child: Text(
                  tr("confirm"),
                  style: Theme.of(context).textTheme.bodyText1.merge(
                        TextStyle(color: Theme.of(context).accentColor),
                      ),
                ),
              ),
            ],
          );
        });
  }

  onHistorySelect(String value) {
    this._model.searchText = value;
  }
}

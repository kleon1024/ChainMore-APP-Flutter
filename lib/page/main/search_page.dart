import 'package:chainmore/model/models.dart';
import 'package:chainmore/utils/params.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final globalModel = Provider.of<GlobalModel>(context);
    final model = Provider.of<SearchPageModel>(context);

    return WillPopScope(
      onWillPop: () async {
        return !model.isSearching;
      },
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            flexibleSpace: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: ScreenUtil().setHeight(15),
                          horizontal: ScreenUtil().setWidth(15)),
                      child: TextField(
                        autofocus: true,
                        focusNode: model.searchFocusNode,
                        controller: model.searchController,
                        cursorColor: Theme.of(context).accentColor,
                        onChanged: model.logic.onSearchFieldChanged,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: ScreenUtil().setWidth(0),
                              horizontal: ScreenUtil().setWidth(30)),
                          border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(10.0),
                            ),
                          ),
                          hintText: tr("search"),
                          hintStyle:
                              Theme.of(context).textTheme.bodyText1.merge(
                                    TextStyle(
                                      color: Theme.of(context).highlightColor,
                                    ),
                                  ),
                          suffixIcon: IconButton(
                            onPressed: () {},
                            padding: EdgeInsets.zero,
                            iconSize: GlobalParams.smallIconSize,
                            color: Theme.of(context).highlightColor,
                            icon: Icon(Icons.cancel),
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Text(
                      tr("cancel"),
                      style: Theme.of(context).textTheme.subtitle2,
                      softWrap: false,
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: Container(
              child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  onVerticalDragDown: (drag) {
                    FocusScope.of(context).unfocus();
                  },
                  child: CupertinoScrollbar(
                      child: CustomScrollView(
                          physics: BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          slivers: <Widget>[
                        SliverList(
                            delegate: SliverChildListDelegate([
                          model.isSearching
                              ? _buildSearchingLayout(model)
                              : _buildUnSearchingLayout(model),
                        ]))
                      ]))))),
    );
  }

  _buildSearchingLayout(SearchPageModel model) {
    return Container();
  }

  _buildUnSearchingLayout(SearchPageModel model) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(40),
        vertical: ScreenUtil().setWidth(30),
      ),
      children: [
        _buildHistorySearch(model),
        _buildSelection(model),
      ],
    );
  }

  _buildHistorySearch(SearchPageModel model) {
    return Offstage(
      offstage: model.historySearchList.isEmpty,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  tr("search_history"),
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete_outline),
                onPressed: model.logic.onClearHistory,
              )
            ],
          ),
          Wrap(
            spacing: ScreenUtil().setWidth(30),
            children: model.historySearchList
                .map((v) => GestureDetector(
                    onTap: () {
                      model.logic.onHistorySelect(v);
                    },
                    child: Chip(
                      label: Text(v),
                    )))
                .toList(),
          ),
        ],
      ),
    );
  }

  _buildSelection(SearchPageModel model) {
    return Container();
  }
}

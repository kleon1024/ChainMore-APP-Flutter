import 'package:chainmore/models/hot_search_data.dart';
import 'package:chainmore/network/apis.dart';
import 'package:chainmore/pages/search/search_other_result_page.dart';
import 'package:chainmore/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chainmore/application.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:chainmore/widgets/h_empty_view.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:chainmore/widgets/widget_future_builder.dart';

class OldSearchPage extends StatefulWidget {
  @override
  _OldSearchPageState createState() => _OldSearchPageState();
}

class _OldSearchPageState extends State<OldSearchPage> with TickerProviderStateMixin {
  List<String> historySearchList;
  TextEditingController _searchController = TextEditingController();
  FocusNode _searchFocusNode = FocusNode();
  bool _isSearching = false; // 是否正在搜索，改变布局
  Map<String, String> _searchingTabMap = {
    '领域': 'domain',
    '文章': 'article',
    '用户': 'user',
  };
  List<String> _searchingTabKeys = [];
  TabController _searchingTabController;
  String searchText = "";
  String lastSearchText = "";

  @override
  void initState() {
    super.initState();
    historySearchList = Application.sp.getStringList("search_history") ?? [];
    _searchingTabKeys.addAll(_searchingTabMap.keys.toList());
    _searchingTabController =
        TabController(length: _searchingTabKeys.length, vsync: this);
  }

  // 历史搜索
  Widget _buildHistorySearch() {
    return Offstage(
      offstage: historySearchList.isEmpty,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  '历史记录',
                  style: bold18TextStyle,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: Colors.grey,
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text(
                            "确定清空全部历史记录？",
                            style: common14GrayTextStyle,
                          ),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('取消'),
                              textColor: Colors.red,
                            ),
                            FlatButton(
                              onPressed: () {
                                setState(() {
                                  historySearchList.clear();
                                  Application.sp.remove("search_history");
                                });
                                Navigator.of(context).pop();
                              },
                              child: Text('清空'),
                              textColor: Colors.red,
                            ),
                          ],
                        );
                      });
                },
              )
            ],
          ),
          Wrap(
            spacing: ScreenUtil().setWidth(20),
            children: historySearchList
                .map((v) => GestureDetector(
                      onTap: () {
                        searchText = v;
                        _search();
                      },
                      child: Chip(
                        label: Text(
                          v,
                          style: common14TextStyle,
                        ),
                      ),
                    ))
                .toList(),
          ),
          VEmptyView(50),
        ],
      ),
    );
  }

  // 热搜
  Widget _buildHotSearch() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '热门搜索',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        VEmptyView(15),
        CustomFutureBuilder<HotSearchData>(
          futureFunc: API.getHotSearchData,
          builder: (context, data) {
            return ListView.builder(
              itemBuilder: (context, index) {
                var curQuery = data.queries[index];
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    searchText = curQuery;
                    _search();
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setWidth(10)),
                    child: Row(
                      children: <Widget>[
                        Text('${index + 1}',
                            style: index < 3
                                ? TextUtil.style(18, 500,
                                    color: CMColors.blueLonely)
                                : TextUtil.style(18, 500, color: Colors.grey)),
                        HEmptyView(20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: ScreenUtil().setWidth(5)),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      curQuery,
                                      style: index < 3
                                          ? w500_16TextStyle
                                          : common16TextStyle,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: data.queries.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
            );
          },
        )
      ],
    );
  }

  // 搜索
  void _search() {
    FocusScope.of(context).unfocus();
    setState(() {
      if (historySearchList.contains(searchText))
        historySearchList.remove(searchText);
      historySearchList.insert(0, searchText);
      if (historySearchList.length > 5) {
        historySearchList.removeAt(historySearchList.length - 1);
      }
      _isSearching = true;
      _searchController.text = searchText;
    });
    Application.sp.setStringList("search_history", historySearchList);
  }

  // 构建未搜索时的布局
  Widget _buildUnSearchingLayout() {
    return ListView(
      padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(40),
          vertical: ScreenUtil().setWidth(30)),
      children: <Widget>[
        _buildHistorySearch(),
        _buildHotSearch(),
      ],
    );
  }

  // 构建搜索中的布局
  Widget _buildSearchingLayout() {
    return Column(
      children: <Widget>[
        TabBar(
          indicatorColor: CMColors.blueLonely,
          labelColor: CMColors.blueLonely,
          unselectedLabelColor: Colors.black87,
          isScrollable: true,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: _searchingTabKeys
              .map((key) => Tab(
                    text: key,
                  ))
              .toList(),
          controller: _searchingTabController,
        ),
        Expanded(
          child: TabBarView(
            children: [
              ..._searchingTabKeys
                  .map((key) => SearchOtherResultPage(
                      _searchingTabMap[key], searchText,
                      state: ""))
                  .toList()
            ],
            controller: _searchingTabController,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
//        backgroundColor: Colors.white,
//        floatingActionButton: Container(
//          padding: EdgeInsets.only(
//              bottom: ScreenUtil().setHeight(150),
//              right: ScreenUtil().setWidth(10)),
//          child: Container(
//            height: ScreenUtil().setHeight(80),
//            width: ScreenUtil().setWidth(80),
//            child: FloatingActionButton(
//              elevation: 0,
//              backgroundColor: Colors.black87,
//              child: Icon(Icons.close),
//              onPressed: () {
//                if (_isSearching) {
//                  Future.delayed(Duration(milliseconds: 50)).then((_) {
//                    _searchController.clear();
//                  });
//                  setState(() {
//                    _isSearching = false;
//                  });
//                } else {
//                  Navigator.pop(context);
//                }
//              },
//            ),
//          ),
//        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Theme(
            child: TextField(
              focusNode: _searchFocusNode,
              controller: _searchController,
              cursorColor: CMColors.blueLonely,
              textInputAction: TextInputAction.search,
              onEditingComplete: () {
                searchText = _searchController.text.isEmpty
                    ? '阡陌'
                    : _searchController.text;
                _search();
              },
              onChanged: (text) {
                if (text.isEmpty) {
                  setState(() {
                    _isSearching = false;
                  });
                  Future.delayed(Duration(milliseconds: 50)).then((_) {
                    _searchController.clear();
                    FocusScope.of(context).requestFocus(_searchFocusNode);
                  });
                }
              },
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                hintText: "阡陌",
                hintStyle: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .merge(TextStyle(color: Colors.grey)),
                suffixIcon: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.cancel,
                      size: 16,
                    ),
                    onPressed: () {
                      setState(() {
                        _isSearching = false;
                      });
                      Future.delayed(Duration(milliseconds: 50)).then((_) {
                        _searchController.clear();
                        FocusScope.of(context).requestFocus(_searchFocusNode);
                      });
                    }),
              ),
            ),
            data: Theme.of(context).copyWith(primaryColor: Colors.black54),
          ),
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: EdgeInsets.only(right: 15),
                child: Center(
                  child: Text(
                    "取消",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ),
            )
          ],
        ),
        body: Listener(
          onPointerDown: (d) {
            FocusScope.of(context).unfocus();
          },
          child: _isSearching
              ? _buildSearchingLayout()
              : _buildUnSearchingLayout(),
        ),
      ),
    );
  }
}

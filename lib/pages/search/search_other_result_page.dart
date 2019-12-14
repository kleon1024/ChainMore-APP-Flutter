import 'package:chainmore/models/domain.dart';
import 'package:chainmore/network/apis.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:chainmore/widgets/widget_search_domain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chainmore/widgets/widget_load_footer.dart';

typedef LoadMoreWidgetBuilder<T> = Widget Function(T data);

class SearchOtherResultPage extends StatefulWidget {
  final String type;
  final String query;
  final bool login;

  SearchOtherResultPage(this.type, this.query, {this.login = false});

  @override
  _SearchOtherResultPageState createState() => _SearchOtherResultPageState();
}

class _SearchOtherResultPageState extends State<SearchOtherResultPage>
    with AutomaticKeepAliveClientMixin {
  int _count = -1;
  Map<String, String> _params;
  List<Domain> _domains = []; // 领域数据
  EasyRefreshController _controller;

  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController();
    WidgetsBinding.instance.addPostFrameCallback((d) {
      _params = {'query': widget.query, 'offset': '1', 'type': widget.type};
      _request();
    });
  }

  void _request() async {
    if (widget.login) {
      if (widget.type == "domain") {
        List<Domain> domains =  await API.searchDomain(context, params: _params);
        if (mounted) {
          setState(() {
            _count = domains.length;
            _domains.addAll(domains);
          });
        }
      }
    } else {
      List r = await API.getSearch(context, params: _params);
      if (mounted) {
        setState(() {
          if (widget.type == "domain") {
            _count = r.length;
            _domains.addAll(r as List<Domain>);
          } else {
            _count = r.length;
          }
        });
      }
    }
  }

  // 构建歌单页面
  Widget _buildDomainPage() {
    return _buildLoadMoreWidget<Domain>(_domains, (curData) {
      return SearchDomainWidget(
        domain: curData,
        login: widget.login,
      );
    });
  }

  Widget _buildLoadMoreWidget<T>(
      List<T> data, LoadMoreWidgetBuilder<T> builder) {
    return EasyRefresh.custom(
      slivers: [
        SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
          return builder(data[index]);
        }, childCount: data.length))
      ],
      footer: LoadFooter(),
      controller: _controller,
      onLoad: () async {
        _params['offset'] = '${int.parse(_params['offset']) + 1}';
        _request();
        _controller.finishLoad(noMore: _domains.length >= _count);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (_count == -1) {
      return CupertinoActivityIndicator();
    }

    if (_count == 0) {
      return Center(
        child: Text(
          "没有找到相关结果",
          style: TextUtil.style(16, 500),
        ),
      );
    }

    Widget result;

    if (widget.type == "domain") {
      result = _buildDomainPage();
    } else {
      result = Container();
    }

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(50),
          vertical: ScreenUtil().setWidth(20)),
      child: result,
    );
  }

  @override
  bool get wantKeepAlive => true;
}

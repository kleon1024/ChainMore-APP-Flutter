import 'package:chainmore/models/certify_rule.dart';
import 'package:chainmore/models/domain.dart';
import 'package:chainmore/models/domain_tree.dart';
import 'package:chainmore/network/apis.dart';
import 'package:chainmore/pages/domain/choiceproblem_page.dart';
import 'package:chainmore/pages/domain/empty_certify_page.dart';
import 'package:chainmore/providers/certify_model.dart';
import 'package:chainmore/utils/colors.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:chainmore/widgets/h_empty_view.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:chainmore/widgets/widget_future_builder.dart';
import 'package:chainmore/widgets/widget_simple_future_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class DomainMapPage extends StatefulWidget {
  final Domain domain;

  DomainMapPage(this.domain);

  @override
  _DomainMapPageState createState() => _DomainMapPageState();
}

class _DomainMapPageState extends State<DomainMapPage> {
  @override
  void initState() {
    super.initState();
  }

  convertTreeToExpandableList(DomainTree tree, int depth) {
    if (tree.subdomains.length == 0) {
      return ListTile(
        leading: SizedBox(
          width: ScreenUtil().setWidth(50) * (2 + depth),
        ),
        title: Text(tree.domain.title, style: TextUtil.style(16, 700)),
        subtitle: Text(tree.domain.watchers.toString() + tree.domain.bio,
            style: TextUtil.style(14, 400, color: Colors.grey)),
      );
    } else {
      return ExpansionTile(
        leading: SizedBox(
          child: Row(
            children: <Widget>[
              Icon(Icons.style),
            ],
          ),
          width: ScreenUtil().setWidth(50) * (2 + depth),
        ),
        title: Text(tree.domain.title, style: TextUtil.style(16, 700)),
        subtitle: Text(tree.domain.watchers.toString() + tree.domain.bio,
            style: TextUtil.style(14, 400, color: Colors.grey)),
        children: List<Widget>.from(tree.subdomains
            .map((domain) => convertTreeToExpandableList(domain, depth + 1))
            .toList()),
        initiallyExpanded: tree.expanded,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        padding: EdgeInsets.only(
            bottom: ScreenUtil().setHeight(90),
            right: ScreenUtil().setWidth(10)),
        child: Container(
          height: ScreenUtil().setHeight(180),
          width: ScreenUtil().setWidth(80),
          child: Column(
            children: <Widget>[
              FloatingActionButton(
                elevation: 0,
                backgroundColor: Colors.black87,
                child: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              CustomFutureBuilder(
                futureFunc: API.getDomainTree,
                params: {'id': widget.domain.id},
                builder: (context, tree) {
                  return convertTreeToExpandableList(tree, 0);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

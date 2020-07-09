import 'dart:async';
import 'dart:convert';

import 'package:chainmore/model/domain_creation_page_model.dart';
import 'package:chainmore/model/global_model.dart';
import 'package:chainmore/model/resource_creation_page_model.dart';
import 'package:chainmore/utils/params.dart';
import 'package:chainmore/widgets/h_empty_view.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class DomainCreationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final globalModel = Provider.of<GlobalModel>(context);
    final model = Provider.of<DomainCreationPageModel>(context)
      ..setContext(context, globalModel: globalModel);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(GlobalParams.appBarHeight),
        child: AppBar(
          elevation: 0,
          title: Text(tr("create_domain"),
              style: Theme.of(context).textTheme.subtitle1),
          centerTitle: true,
          key: model.scaffoldKey,
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
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: model.padding),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: <Widget>[
                                Text(tr("title")),
                                HEmptyView(10),
                                model.isLoading
                                    ? CupertinoActivityIndicator()
                                    : Container(),
                              ],
                            ),
                            VEmptyView(20),
                            TextField(
                              controller: model.titleEditingController,
                              focusNode: model.titleFocusNode,
                              maxLines: 3,
                              minLines: 1,
                              maxLength: model.maxTitleLength,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: ScreenUtil().setWidth(0),
                                    horizontal: ScreenUtil().setWidth(30)),
                                border: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(10.0),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [Text(tr("introduction"))],
                            ),
                            VEmptyView(20),
                            TextField(
                              controller: model.introEditingController,
                              focusNode: model.introFocusNode,
                              maxLines: 99,
                              minLines: 1,
                              maxLength: model.maxIntroLength,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: ScreenUtil().setWidth(0),
                                    horizontal: ScreenUtil().setWidth(30)),
                                border: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(10.0),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [Text(tr("aggregate"))],
                            ),
                            VEmptyView(20),
                            Container(
                              width: double.infinity,
                              child: OutlineButton(
                                splashColor: Colors.transparent,
                                color: Theme.of(context).cardColor,
                                onPressed: () {
                                  /// TODO Search (Select from marked) Domain
                                },
                                child: Icon(Icons.playlist_add),
                              ),
                            ),
                            VEmptyView(30),
                            Row(
                              children: [Text(tr("depend"))],
                            ),
                            VEmptyView(20),
                            Container(
                              width: double.infinity,
                              child: OutlineButton(
                                splashColor: Colors.transparent,
                                color: Theme.of(context).cardColor,
                                onPressed: () {
                                  ///TODO Search (Select from marked) Domain
                                },
                                child: Icon(Icons.playlist_add),
                              ),
                            ),
                            VEmptyView(30),
                            Container(
                              width: double.infinity,
                              child: FlatButton(
                                splashColor: Colors.transparent,
                                color: Theme.of(context).cardColor,
                                textColor: Theme.of(context).accentColor,
                                onPressed: () {
                                  ///TODO Submit
                                },
                                child: Text(tr("divide")),
                              ),
                            ),
                          ]),
                    ),
                  ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

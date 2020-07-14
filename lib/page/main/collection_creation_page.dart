import 'dart:async';
import 'dart:convert';

import 'package:chainmore/model/collection_creation_page_model.dart';
import 'package:chainmore/model/global_model.dart';
import 'package:chainmore/utils/params.dart';
import 'package:chainmore/widgets/cards/resource_card.dart';
import 'package:chainmore/widgets/separator.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class CollectionCreationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<CollectionCreationPageModel>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(GlobalParams.appBarHeight),
        child: AppBar(
          elevation: 0,
          title: Text(tr("create_collection"),
              style: Theme.of(context).textTheme.subtitle1),
          centerTitle: true,
          key: model.scaffoldKey,
        ),
      ),
      body: Container(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
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
                      child: Column(children: [
                        Row(
                          children: [Text(tr("title"))],
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
                          children: [Text(tr("description"))],
                        ),
                        VEmptyView(20),
                        TextField(
                          controller: model.descEditingController,
                          focusNode: model.descFocusNode,
                          maxLines: 99,
                          minLines: 1,
                          maxLength: model.maxDescLength,
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
                        Row(children: [Text(tr("refer_resource"))]),
                        VEmptyView(20),
                        Container(
                          width: double.infinity,
                          child: OutlineButton(
                            padding: EdgeInsets.zero,
                            splashColor: Colors.transparent,
                            color: Theme.of(context).cardColor,
                            onPressed: model.logic.onSelectResources,
                            child: Icon(Icons.playlist_add),
                          ),
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          separatorBuilder: (context, index) {
                            return Separator();
                          },
                          itemBuilder: (context, index) {
                            return Dismissible(
                              background: Container(color: Theme.of(context).accentColor),
                              key: Key(index.toString()),
                              onDismissed: (direction) {
                                model.logic.removeRefResourceAt(index);
                              },
                              child: Container(
                                width: double.infinity,
                                child: ResourceCard(
                                  color: Theme.of(context).canvasColor,
                                  bean: model.resources[index],
                                  elevation: 0,
                                ),
                              ),
                            );
                          },
                          itemCount: model.resources.length,
                        ),
                        VEmptyView(30),
                        Container(
                          width: double.infinity,
                          child: FlatButton(
                            splashColor: Colors.transparent,
                            color: Theme.of(context).cardColor,
                            textColor: Theme.of(context).accentColor,
                            onPressed: () {
                              ///TODO Post
                            },
                            child: Text(tr("post")),
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

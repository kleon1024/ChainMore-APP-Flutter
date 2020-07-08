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
import 'package:provider/provider.dart';

class CollectionCreationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final globalModel = Provider.of<GlobalModel>(context);
    final model = Provider.of<CollectionCreationPageModel>(context)
      ..setContext(context, globalModel: globalModel);

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
                        VEmptyView(30),
                        Row(
                          children: [Text(tr("description"))],
                        ),
                        VEmptyView(20),
                        TextField(
                          controller: model.descEditingController,
                          focusNode: model.descFocusNode,
                          maxLines: 99,
                          minLines: 1,
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
                        VEmptyView(30),
                        Row(children: [Text(tr("refer_resource"))]),
                        VEmptyView(20),
                        Container(
                          width: double.infinity,
                          child: OutlineButton(
                            onLongPress: null,
                            padding: EdgeInsets.zero,
                            splashColor: Colors.transparent,
                            color: Theme.of(context).cardColor,
                            onPressed: model.logic.onSelectResources,
                            child: Column(children: [
                              Container(
                                height: ScreenUtil().setHeight(120),
                                child: Icon(Icons.playlist_add),
                              ),
                              Separator(),
                              ListView.separated(
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return ResourceCard(
                                    horizontalPadding: ScreenUtil().setWidth(15),
                                    color: Theme.of(context).canvasColor,
                                    bean: model.resources[index],
                                    elevation: 0,
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return Separator();
                                },
                                itemCount: model.resources.length,
                              ),
                            ]),
                          ),
                        ),
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

import 'dart:async';
import 'dart:convert';

import 'package:chainmore/model/global_model.dart';
import 'package:chainmore/model/resource_creation_page_model.dart';
import 'package:chainmore/widgets/h_empty_view.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ResourceCreationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final globalModel = Provider.of<GlobalModel>(context);
    final model = Provider.of<ResourceCreationPageModel>(context)
      ..setContext(context, globalModel: globalModel);

    final resourceStr =
        globalModel.logic.getResourceTypeStr(model.selectedResourceTypeId);
    final mediaStr =
        globalModel.logic.getMediaTypeStr(model.selectedMediaTypeId);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(tr("create_resource"),
            style: Theme.of(context).textTheme.subtitle1),
        centerTitle: true,
        key: model.scaffoldKey,
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
                          children: [Text(tr("link"))],
                        ),
                        VEmptyView(20),
                        TextField(
                          autofocus: true,
                          controller: model.uriEditingController,
                          maxLines: 16,
                          minLines: 1,
                          focusNode: model.uriFocusNode,
                          onSubmitted: model.logic.onSubmit,
                          keyboardType: TextInputType.url,
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
                        Row(children: [Text(tr("classification"))]),
                        Container(
                          width: double.infinity,
                          child: FlatButton(
                            onPressed: model.logic.onShowPicker,
                            color: Theme.of(context).cardColor,
                            child: Text(
                              tr(resourceStr) +
                                  " + " +
                                  tr(mediaStr) +
                                  " = " +
                                  tr(resourceStr + "_" + mediaStr),
                            ),
                          ),
                        ),
                        VEmptyView(20),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(0)),
                          title: Text(tr("paid_content"),
                              style: Theme.of(context).textTheme.bodyText1),
                          value: model.isPaid,
                          secondary: Icon(Icons.attach_money),
                          controlAffinity: ListTileControlAffinity.platform,
                          onChanged: model.logic.onPaidChecked,
                        ),
                        Container(
                          width: double.infinity,
                          child: RaisedButton(
                            splashColor: Colors.transparent,
                            color: Theme.of(context).cardColor,
                            textColor: Theme.of(context).accentColor,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(tr("create")),
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

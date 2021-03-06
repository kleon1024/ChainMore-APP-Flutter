import 'dart:async';
import 'dart:convert';

import 'package:chainmore/model/global_model.dart';
import 'package:chainmore/model/resource_creation_page_model.dart';
import 'package:chainmore/utils/params.dart';
import 'package:chainmore/widgets/cards/resource_card.dart';
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
    final model = Provider.of<ResourceCreationPageModel>(context);

    final resourceStr =
        globalModel.logic.getResourceTypeStr(model.selectedResourceTypeId) ??
            "article";
    final mediaStr =
        globalModel.logic.getMediaTypeStr(model.selectedMediaTypeId) ?? "text";

    return WillPopScope(
      onWillPop: () async {
        if (model.mode == ResourceMode.MODIFY) {
          model.logic.onPostProcess();
        }
        return true;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(GlobalParams.appBarHeight),
          child: AppBar(
            elevation: 0,
            title: Text(
                model.mode == ResourceMode.CREATE
                    ? tr("create_resource")
                    : tr("modify_resource"),
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
                        padding:
                            EdgeInsets.symmetric(horizontal: model.padding),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              model.existedResource == null
                                  ? VEmptyView(0)
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                          Expanded(
                                              child: ResourceCard(
                                                  bean: model.existedResource,
                                                  elevation: 0,
                                                  color: Theme.of(model.context)
                                                      .canvasColor)),
                                          IconButton(
                                            icon:
                                                model.existedResource.collected
                                                    ? Icon(Icons.star)
                                                    : Icon(Icons.star_border),
                                            onPressed: model
                                                .logic.onPressCollectButton,
                                          ),
                                        ]),
                              Row(
                                children: [
                                  Text(tr("link")),
                                  HEmptyView(10),
                                  model.isChecking
                                      ? CupertinoActivityIndicator()
                                      : Text(
                                          tr(model.logic.urlCheckStatusStr()),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .merge(TextStyle(
                                                  color: Theme.of(context)
                                                      .accentColor))),
                                ],
                              ),
                              VEmptyView(20),
                              TextField(
                                enabled: !model.isChecking,
                                autofocus:
                                    model.uriEditingController.text == "",
                                controller: model.uriEditingController,
                                maxLines: 16,
                                minLines: 1,
                                maxLength: model.maxUriLength,
                                focusNode: model.uriFocusNode,
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
                              Row(children: [Text(tr("classification"))]),
                              Container(
                                width: double.infinity,
                                child: OutlineButton(
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
                              CheckboxListTile(
                                dense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 0,
                                  horizontal: 0,
                                ),
                                title: Text(tr("paid_content"),
                                    style:
                                        Theme.of(context).textTheme.bodyText1),
                                value: model.isPaid,
//                          secondary: Icon(Icons.attach_money),
                                controlAffinity:
                                    ListTileControlAffinity.platform,
                                onChanged: model.logic.onPaidChecked,
                              ),
                              Container(
                                width: double.infinity,
                                child: FlatButton(
                                  splashColor: Colors.transparent,
                                  color: Theme.of(context).cardColor,
                                  textColor: Theme.of(context).accentColor,
                                  onPressed: model.checkStatus ==
                                              ResourceCheckStatus.NOT_EXIST ||
                                          model.checkStatus ==
                                              ResourceCheckStatus.CHECKED
                                      ? model.logic.onClickCreateButton
                                      : null,
                                  child: model.isSubmitting
                                      ? CupertinoActivityIndicator()
                                      : Text(model.mode == ResourceMode.CREATE
                                          ? tr("create")
                                          : tr("modify")),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                child: FlatButton(
                                  splashColor: Colors.transparent,
                                  color: Theme.of(context).cardColor,
                                  onPressed: model.checkStatus ==
                                              ResourceCheckStatus.UNCHECK ||
                                          model.checkStatus ==
                                              ResourceCheckStatus.NET_ERR
                                      ? model.logic.onClickRecheckButton
                                      : null,
                                  child: model.isChecking
                                      ? CupertinoActivityIndicator()
                                      : Text(tr("check_url")),
                                ),
                              ),
                              VEmptyView(120),
                            ]),
                      ),
                    ]),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

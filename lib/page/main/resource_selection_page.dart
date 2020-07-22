import 'package:chainmore/model/collection_creation_page_model.dart';
import 'package:chainmore/utils/params.dart';
import 'package:chainmore/widgets/cards/resource_card.dart';
import 'package:chainmore/widgets/form/labeled_checkbox.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResourceSelectionPage extends StatefulWidget {
  final CollectionCreationPageModel model;

  ResourceSelectionPage({Key key, this.model})
      : assert(model != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => ResourceSelectionPageState();
}

class ResourceSelectionPageState extends State<ResourceSelectionPage> {
  final List<bool> values = [];

  @override
  Widget build(BuildContext context) {
    values.clear();

    final resources = widget.model.logic.getResources();

    resources.forEach((element) {
      if (widget.model.resources.contains(element)) {
        values.add(true);
      } else {
        values.add(false);
      }
    });

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(GlobalParams.appBarHeight),
        child: AppBar(
          elevation: 0,
          title: Text(tr("resource_selection"),
              style: Theme.of(context).textTheme.subtitle1),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.filter_list,
                size: Theme.of(context).iconTheme.size,
              ),
              onPressed: () {
//              _onSelectClassifier();
              },
            ),
          ],
        ),
      ),
      body: CupertinoScrollbar(
        child: CustomScrollView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: <Widget>[
            SliverAnimatedList(
              initialItemCount: resources.length,
              itemBuilder: (context, index, animation) {
                return LabeledCheckbox(
                    value: values[index],
                    onChanged: (value) {
                      widget.model.logic
                          .onSelectResource(resources[index], value, index);
                      setState(() {});
                    },
                    child: ResourceCard(
                      color: Theme.of(context).canvasColor,
                      elevation: 0,
                      bean: resources[index],
                      horizontalPadding: ScreenUtil().setWidth(30),
                      verticalPadding: ScreenUtil().setHeight(15),
                    ));
              },
            )
          ],
        ),
      ),
    );
  }
}

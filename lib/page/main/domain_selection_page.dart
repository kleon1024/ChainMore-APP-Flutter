import 'package:chainmore/json/domain_bean.dart';
import 'package:chainmore/model/collection_creation_page_model.dart';
import 'package:chainmore/model/domain_creation_page_model.dart';
import 'package:chainmore/utils/navigator_util.dart';
import 'package:chainmore/utils/params.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:chainmore/widgets/cards/domain_card.dart';
import 'package:chainmore/widgets/cards/resource_card.dart';
import 'package:chainmore/widgets/form/labeled_checkbox.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class DomainSelectionPage extends StatefulWidget {
  final DomainCreationPageModel model;
  final bool depend;
  final bool aggregate;

  DomainSelectionPage({Key key, this.depend = false, this.aggregate = false, this.model})
      : assert(model != null),
        assert(depend != false || aggregate != false),
        super(key: key);

  @override
  State<StatefulWidget> createState() => DomainSelectionPageState();
}

class DomainSelectionPageState extends State<DomainSelectionPage> {
  final List<bool> values = [];

  @override
  Widget build(BuildContext context) {
    values.clear();

    final domains = widget.model.logic.getDomains();

    List<DomainBean> targetDomains = [];
    if (widget.depend) {
      targetDomains = widget.model.depDomains;
    } else if (widget.aggregate) {
      targetDomains = widget.model.aggDomains;
    }

    domains.forEach((element) {
      /// TODO Potential bug
      if (targetDomains.contains(element)) {
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
          title: Text(tr("resource_management"),
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
              initialItemCount: domains.length,
              itemBuilder: (context, index, animation) {
                return LabeledCheckbox(
                    value: values[index],
                    onChanged: (value) {
                      widget.model.logic
                          .onSelect(domains[index], value, index, widget.depend, widget.aggregate);
                      setState(() {});
                    },
                    child: DomainCard(
                      color: Theme.of(context).canvasColor,
                      elevation: 0,
                      bean: domains[index],
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

import 'package:chainmore/json/domain_bean.dart';
import 'package:chainmore/utils/params.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:chainmore/widgets/cards/domain_card.dart';
import 'package:chainmore/widgets/form/labeled_checkbox.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DomainSelectionPage extends StatefulWidget {
  final List<DomainBean> domains;
  final List<DomainBean> allDomains;
  final Function onSelect;

  DomainSelectionPage({Key key, this.domains, this.allDomains, this.onSelect})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => DomainSelectionPageState();
}

class DomainSelectionPageState extends State<DomainSelectionPage> {
  final List<bool> values = [];

  @override
  Widget build(BuildContext context) {
    values.clear();

    widget.allDomains.forEach((element) {
      if (Utils.containDomain(widget.domains, element)) {
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
          title: Text(tr("domain_selection"),
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
              initialItemCount: widget.allDomains.length,
              itemBuilder: (context, index, animation) {
                return LabeledCheckbox(
                    value: values[index],
                    onChanged: (value) {
                      widget.onSelect(widget.allDomains[index], value, index);
                      setState(() {});
                    },
                    child: DomainCard(
                      color: Theme.of(context).canvasColor,
                      elevation: 0,
                      bean: widget.allDomains[index],
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

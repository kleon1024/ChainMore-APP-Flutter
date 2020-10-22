import 'package:chainmore/json/domain_bean.dart';
import 'package:chainmore/utils/params.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:chainmore/widgets/cards/domain_card.dart';
import 'package:chainmore/widgets/form/labeled_checkbox.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
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
  bool searching = false;
  final searchFocusNode = FocusNode();
  final searchController = TextEditingController();

  onSearchFieldChanged(String value) {
    setState(() {});
  }

  onClearSearchText() {
    searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    values.clear();

    final availableDomains = [];

    if (searching) {
      print(searchController.text.trim());
      if (searchController.text.trim() == "") {
        availableDomains.addAll(widget.allDomains);
      } else {
        final List queries = searchController.text.trim().split(" ");
        final String fullQuery = searchController.text.trim();

        for (DomainBean domain in widget.allDomains) {
          int count = 0;
          if (domain.title == fullQuery) {
            count += 100;
          }
          for (String query in queries) {
            if (domain.title.contains(query) || domain.intro.contains(query)) {
              count += 1;
            }
          }
          if (count > 0) {
            domain.count = count;
            availableDomains.add(domain);
          }
        }

        availableDomains.sort((a, b) {
          return b.count - a.count;
        });
      }
    } else {
      availableDomains.addAll(widget.allDomains);
    }

    availableDomains.forEach((element) {
      if (Utils.containDomain(widget.domains, element)) {
        values.add(true);
      } else {
        values.add(false);
      }
    });

    final flexibleSpace = searching
        ? SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setHeight(15),
                        horizontal: ScreenUtil().setWidth(15)),
                    child: TextField(
                      autofocus: true,
                      focusNode: searchFocusNode,
                      controller: searchController,
                      cursorColor: Theme.of(context).accentColor,
                      onChanged: onSearchFieldChanged,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        isCollapsed: true,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: ScreenUtil().setWidth(0),
                            horizontal: ScreenUtil().setWidth(30)),
                        fillColor: Theme.of(context).highlightColor,
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10),
                          ),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10),
                          ),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10),
                          ),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        hintText: tr("filter"),
                        hintStyle: Theme.of(context).textTheme.bodyText1.merge(
                              TextStyle(
                                color: Theme.of(context).disabledColor,
                              ),
                            ),
                        prefixIcon: Icon(
                          Icons.filter_list,
                          size: Theme.of(context).textTheme.headline6.fontSize,
                          color: Theme.of(context).disabledColor,
                        ),
                        prefixIconConstraints:
                            BoxConstraints.tight(Size.fromWidth(28)),
                        suffixIcon: IconButton(
                          onPressed: onClearSearchText,
                          padding: EdgeInsets.zero,
                          iconSize: GlobalParams.smallIconSize,
                          color: Theme.of(context).highlightColor,
                          icon: Icon(Icons.cancel),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      searching = false;
                    });
                  },
                  icon: Text(
                    tr("cancel"),
                    style: Theme.of(context).textTheme.subtitle2,
                    softWrap: false,
                  ),
                ),
              ],
            ),
          )
        : VEmptyView(0);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(GlobalParams.appBarHeight),
        child: AppBar(
          elevation: 0,
          automaticallyImplyLeading: !searching,
          title: searching
              ? Container()
              : Text(tr("domain_selection"),
                  style: Theme.of(context).textTheme.subtitle1),
          centerTitle: true,
          actions: searching
              ? []
              : <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.filter_list,
                      size: Theme.of(context).iconTheme.size,
                    ),
                    onPressed: () {
                      setState(() {
                        searching = true;
                      });
                    },
                  )
                ],
          flexibleSpace: flexibleSpace,
        ),
      ),
      body: CupertinoScrollbar(
        child: CustomScrollView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return LabeledCheckbox(
                      value: values[index],
                      onChanged: (value) {
                        widget.onSelect(availableDomains[index], value, index);
                        setState(() {});
                      },
                      child: DomainCard(
                        color: Theme.of(context).canvasColor,
                        elevation: 0,
                        bean: availableDomains[index],
                        horizontalPadding: ScreenUtil().setWidth(30),
                        verticalPadding: ScreenUtil().setHeight(15),
                      ));
                },
                childCount: availableDomains.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}

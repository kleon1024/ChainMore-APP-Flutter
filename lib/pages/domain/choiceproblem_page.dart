import 'package:chainmore/models/certify_rule.dart';
import 'package:chainmore/models/choiceproblem.dart';
import 'package:chainmore/models/domain.dart';
import 'package:chainmore/network/apis.dart';
import 'package:chainmore/providers/certify_model.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:chainmore/widgets/widget_future_builder.dart';
import 'package:chainmore/widgets/widget_select_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ChoiceProblemPage extends StatefulWidget {
  final ChoiceProblem problem;

  ChoiceProblemPage(this.problem);

  @override
  _ChoiceProblemPageState createState() => _ChoiceProblemPageState();
}

class _ChoiceProblemPageState extends State<ChoiceProblemPage> {
  List<int> choices = List<int>();

  bool init = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CertifyModel certifyModel = Provider.of<CertifyModel>(context);
    if (!init) {
      if (certifyModel.hasRules()) {
        choices = certifyModel.getChoiceProblem(
            widget.problem.rule, widget.problem.id);
        if (choices == null) {
          choices = List<int>();
        }
      }
      init = false;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(ScreenUtil().setHeight(50)),
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                child: Text(widget.problem.body,
                    style: TextUtil.style(16, 600),
                    softWrap: true,
                    textAlign: TextAlign.start),
              ),
              VEmptyView(50),
              Flexible(
                  child: ListView.builder(
                      itemCount: widget.problem.choices.length,
                      itemBuilder: (BuildContext context, int index) {
                        return SelectButton(
                            String.fromCharCode(index + 65) +
                                ".  " +
                                widget.problem.choices[index].body,
                            initState: choices.contains(widget.problem.choices[index].id) ? true : false,
                            func: (bool selected) {
                          if (selected) {
                            choices.add(widget.problem.choices[index].id);
                            certifyModel.setChoiceProblem(widget.problem.rule,
                                widget.problem.id, choices);
                          } else {
                            choices.remove(widget.problem.choices[index].id);
                            certifyModel.setChoiceProblem(widget.problem.rule,
                                widget.problem.id, choices);
                          }
                        });
                      }))
            ],
          ),
        ),
      ),
    );
  }
}

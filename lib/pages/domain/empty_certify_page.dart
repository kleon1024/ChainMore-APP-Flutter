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

class EmptyCertifyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
            child: Text("未设置认证标准，可以直接认证", style: TextUtil.style(18, 600))),
      ),
    );
  }
}

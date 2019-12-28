import 'package:chainmore/models/domain.dart';
import 'package:chainmore/providers/domain_create_model.dart';
import 'package:chainmore/providers/edit_model.dart';
import 'package:chainmore/utils/colors.dart';
import 'package:chainmore/utils/navigator_util.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:chainmore/widgets/h_empty_view.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:chainmore/widgets/widget_category_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SearchDomainWidget extends StatelessWidget {
  final Domain domain;
  final bool login;
  final String state;

  SearchDomainWidget(
      {this.domain, this.login = false, this.state = "certified"});

  @override
  Widget build(BuildContext context) {
    String certifiedTagString = "前置未认证";

    if (state == "dependent" || state == "aggregate") {
      certifiedTagString = "领域未认证";
    } else if (state == "") {
      certifiedTagString = "";
    }

    Widget tag = login
        ? (state == "certified" ? domain.depended : domain.certified)
            ? HEmptyView(0)
            : CategoryTag(
                text: certifiedTagString,
                color: Colors.transparent,
                textColor: CMColors.blueLonely,
                onTap: () {
                  if (state == "certified") {
                  } else {
                    NavigatorUtil.goDomainCertifyPage(context, data: domain);
                  }
                },
              )
        : CategoryTag(
            text: "未登录",
            color: Colors.transparent,
            textColor: CMColors.blueLonely);

    return InkWell(
      onTap: () {
        if (state == "") {
          NavigatorUtil.goDomainPage(context, data: domain);
        } else {
          if (login) {
            if (state == "certified") {
              if (domain.depended) {
                EditModel editModel = Provider.of<EditModel>(context);
                editModel.setDomain(domain);
                Navigator.pop(context);
              } else {
                Utils.showToast("需要认证前置领域");
              }
            } else if (state == "dependent") {
              if (domain.certified) {
                DomainCreateModel domainCreateModel =
                    Provider.of<DomainCreateModel>(context);
                domainCreateModel.setDependentDomain(domain);
                Navigator.pop(context);
              } else {
                Utils.showToast("需要认证领域");
              }
            } else if (state == "aggregate") {
              if (domain.certified) {
                DomainCreateModel domainCreateModel =
                    Provider.of<DomainCreateModel>(context);
                domainCreateModel.setAggregateDomain(domain);
                Navigator.pop(context);
              } else {
                Utils.showToast("需要认证领域");
              }
            } else {
              Utils.showToast("领域未处理！");
            }
          } else {
            Utils.showToast("需要先登录！");
          }
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              domain.title,
              style: TextUtil.style(15, 400),
            ),
            certifiedTagString != "" ? tag : VEmptyView(0),
          ],
        ),
      ),
    );
  }
}

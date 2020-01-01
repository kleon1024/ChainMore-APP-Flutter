import 'package:chainmore/providers/user_model.dart';
import 'package:chainmore/utils/colors.dart';
import 'package:chainmore/utils/navigator_util.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:chainmore/widgets/h_empty_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:provider/provider.dart';

typedef CommentCallback = void Function(String content);

class CommentInputWidget extends StatelessWidget {
  final TextEditingController _editingController = TextEditingController();

  final CommentCallback onTapComment;
  final String hintText;

  CommentInputWidget(this.onTapComment, {this.hintText = "参与讨论"});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setWidth(120),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: ScreenUtil().setWidth(1.5),
            color: Colors.black12,
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(20)),
                    color: Colors.white,
                    child: TextField(
                      controller: _editingController,
                      style: common14TextStyle,
                      textInputAction: TextInputAction.send,
                      keyboardType: TextInputType.text,
                      onEditingComplete: sendComment,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: hintText,
                        hintStyle: common14GrayTextStyle,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(ScreenUtil().setWidth(15)),
                child: GestureDetector(
                  onTap: sendComment,
                  child: Container(
                    decoration: BoxDecoration(
                      color: CMColors.blueLonely,
                      borderRadius: BorderRadius.all(
                          Radius.circular(ScreenUtil().setWidth(20))),
                    ),
                    padding: EdgeInsets.fromLTRB(
                        ScreenUtil().setWidth(20),
                        ScreenUtil().setWidth(5),
                        ScreenUtil().setWidth(20),
                        ScreenUtil().setWidth(5),
                    ),
                    alignment: Alignment.center,
                    child: Text("发送", style: TextUtil.style(14, 600, color: Colors.white)),
                  ),
                ),
                ),
//                HEmptyView(ScreenUtil().setWidth(30))
              ],
            ),
          ),
        ],
      ),
    );
  }

  void sendComment() {
    String text = _editingController.text;
    if (text.isEmpty) {
      Utils.showToast('评论内容不能为空！');
      return;
    }
    onTapComment(_editingController.text);
  }

}

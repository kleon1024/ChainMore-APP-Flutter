import 'package:chainmore/models/comment.dart';
import 'package:chainmore/models/post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostPage extends StatefulWidget {
  final Post item;

  PostPage(this.item);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  double _expandedHeight = ScreenUtil().setWidth(630);
  List<Comment> _comments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[

        ],
      ),
    );
  }

}
import 'package:chainmore/models/login_config.dart';
import 'package:chainmore/models/post.dart';
import 'package:chainmore/models/web.dart';
import 'package:chainmore/network/apis.dart';
import 'package:chainmore/providers/user_model.dart';
import 'package:chainmore/utils/colors.dart';
import 'package:chainmore/utils/navigator_util.dart';
import 'package:chainmore/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final Web web;

  WebViewPage({Key key, this.web}) : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  WebViewController _controller;
  Post _post;

  bool collected = false;
  bool collecting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((d) async {
      if (mounted) {
        Loading.showLoading(context);
        var response =
            await API.getPost(context, params: {'id': widget.web.post.id});
        if (response != null) {
          _post = response;
          setState(() {
            collected = _post.collected;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<UserModel>(context);
    bool login = userModel.isLoggedIn();

    return Scaffold(
      floatingActionButton: Container(
        padding: EdgeInsets.only(
            bottom: ScreenUtil().setHeight(150),
            right: ScreenUtil().setWidth(10)),
        child: Container(
          height: ScreenUtil().setHeight(360),
          width: ScreenUtil().setWidth(80),
          child: Column(
            children: <Widget>[
              FloatingActionButton(
                heroTag: "collect",
                elevation: 0,
                backgroundColor: CMColors.blueLonely,
                child: Icon(collected ? Icons.star : Icons.star_border),
                onPressed: () {
                  if (_post == null) {
                    return;
                  }
                  print(widget.web.post);
                  if (login) {
                    if (!collecting) {
                      collecting = true;
                      if (collected) {
                        API.unCollectPost(context,
                            params: {'id': widget.web.post.id}).then((res) {
                          if (res != null) {
                            setState(() {
                              collected = !collected;
                            });
                          }
                          collecting = false;
                        });
                      } else {
                        API.collectPost(context,
                            params: {'id': widget.web.post.id}).then((res) {
                          if (res != null) {
                            setState(() {
                              collected = !collected;
                            });
                          }
                          collecting = false;
                        });
                      }
                    }
                  } else {
                    NavigatorUtil.goLoginPage(context,
                        data: LoginConfig(initial: false));
                  }
                },
              ),
              FloatingActionButton(
                heroTag: "close",
                elevation: 0,
                backgroundColor: Colors.black87,
                child: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          child: WebView(
            initialUrl: widget.web.url,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController c) {
              _controller = c;
            },
          navigationDelegate: (NavigationRequest request) {
            if(request.url.startsWith("http")) {
              return NavigationDecision.navigate;
            } else {
              return NavigationDecision.prevent;
            }
          },
            onPageFinished: (res) {
              Loading.hideLoading(context);
            },
          ),
        ),
      ),
    );

//    List<Widget> titleContent = [];
//    titleContent.add(Text("网页"));
//    if (loading) {
//      titleContent.add(CupertinoActivityIndicator());
//    }
//    titleContent.add(Container(width: 50.0));
//    return WebviewScaffold(
//      url: widget.url,
//      appBar: AppBar(
//        title: Row(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: titleContent,
//        ),
//      ),
//      withZoom: true,
//      withLocalStorage: true,
//      withJavascript: true,
//      withLocalUrl: true,
//    );
  }
}

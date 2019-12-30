import 'package:chainmore/models/web.dart';
import 'package:chainmore/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final Web web;

  WebViewPage({Key key, this.web}) : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        title: Text(widget.title),
//      ),
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
                child: Icon(Icons.star_border),
                onPressed: () {},
              ),
              FloatingActionButton(
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
//          navigationDelegate: (NavigationRequest request) {
//            print("Loading... ${request.url}");
//            if(request.url.startsWith("http")) {
//              return NavigationDecision.navigate;
//            } else {
//              return NavigationDecision.prevent;
//            }
//          },
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

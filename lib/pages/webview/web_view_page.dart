import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String url;

  WebViewPage({Key key, this.url}) : super(key : key);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    print("Initial url...${widget.url}");
    return Scaffold(
//      appBar: AppBar(
//        title: Text(widget.title),
//      ),
      body: Container(
        child: WebView(
          initialUrl: widget.url,
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
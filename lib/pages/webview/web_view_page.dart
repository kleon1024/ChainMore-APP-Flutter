import 'package:chainmore/utils/params.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class WebViewPage extends StatefulWidget {
  final url;

  WebViewPage({Key key, this.url}) : super(key: key);

  @override
  State<StatefulWidget> createState() => WebViewPageState();
}

class WebViewPageState extends State<WebViewPage> {
  InAppWebViewController webViewController;
  double progress = 0;
  String url = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(GlobalParams.appBarHeight),
        child: AppBar(
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.keyboard_arrow_left),
              onPressed: () {
                if (webViewController != null) {
                  webViewController.goBack();
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.keyboard_arrow_right),
              onPressed: () {
                if (webViewController != null) {
                  webViewController.goForward();
                }
              },
            ),
//            IconButton(
//              icon: Icon(Icons.call_made),
//              onPressed: () {},
//            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: progress < 1.0
                ? LinearProgressIndicator(value: progress, minHeight: 1)
                : Container(),
          ),
        ),
      ),
      body: InAppWebView(
          initialUrl: widget.url,
          initialHeaders: {},
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
              debuggingEnabled: true,
              useShouldOverrideUrlLoading: true,
            ),
          ),
          onWebViewCreated: (InAppWebViewController controller) {
            webViewController = controller;
          },
          onLoadStart: (InAppWebViewController controller, String url) {
            print("onLoadStart $url");
            setState(() {
              this.url = url;
            });
          },
          shouldOverrideUrlLoading:
              (controller, shouldOverrideUrlLoadingRequest) async {
            var url = shouldOverrideUrlLoadingRequest.url;
            var uri = Uri.parse(url);

            if (![
              "http",
              "https",
              "file",
              "chrome",
              "data",
              "javascript",
              "about"
            ].contains(uri.scheme)) {
              print("unrecognized uri scheme");
              print(url);
              print(uri.scheme);
              if (await canLaunch(url)) {
                // Launch the App
                await launch(
                  url,
                );
              }
              return ShouldOverrideUrlLoadingAction.CANCEL;
            }
            return ShouldOverrideUrlLoadingAction.ALLOW;
          },
          onLoadStop: (InAppWebViewController controller, String url) async {
            print("onLoadStop $url");
            setState(() {
              this.url = url;
            });
          },
          onProgressChanged: (InAppWebViewController controller, int progress) {
            setState(() {
              this.progress = progress / 100;
            });
          },
          onUpdateVisitedHistory: (InAppWebViewController controller,
              String url, bool androidIsReload) {
            print("onUpdateVisitedHistory $url");
            setState(() {
              this.url = url;
            });
          }),
    );
  }
}

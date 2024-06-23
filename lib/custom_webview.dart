import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomWebView extends StatefulWidget {
  final String initialUrl;

  const CustomWebView({Key? key, required this.initialUrl}) : super(key: key);

  @override
  CustomWebViewState createState() => CustomWebViewState();
}

class CustomWebViewState extends State<CustomWebView> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  late WebViewController _webViewController;
  String _url = "";

  @override
  void initState() {
    super.initState();
    _url = widget.initialUrl;
  }

  @override
  Widget build(BuildContext context) {
    if (_url.isEmpty) {
      return Center(child: CircularProgressIndicator()); // Show a loading indicator
    }

    return WebView(
      initialUrl: _url,
      onWebViewCreated: (WebViewController controller) {
        _controller.complete(controller);
        _webViewController = controller;
      },
      onPageFinished: (String url) {
        setState(() {
          _url = url;
        });
      },
      onWebResourceError: (WebResourceError error) {
        debugPrint('WebView error: $error');
      },
      javascriptMode: JavascriptMode.unrestricted,
    );
  }

  Future<void> loadUrl(String newUrl) async {
    final controller = await _controller.future;
    setState(() {
      _url = newUrl;
    });
    await controller.loadUrl(newUrl);
  }
}

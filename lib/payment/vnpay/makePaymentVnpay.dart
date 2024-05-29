import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String url;

  const WebViewPage({super.key, required this.url});

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    print('WebView URL: ${widget.url}');
    // Ensure proper initialization for Android.
    if (WebView.platform is AndroidWebView) {
      WebView.platform = AndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Page'),
      ),
      body: WebView(
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
        onPageStarted: (String url) {
          print('Page started loading: $url');
          _checkUrlForPaymentStatus(url);
        },
      ),
    );
  }

  void _checkUrlForPaymentStatus(String url) {
    if (url.contains('vnpay_return')) {
      Uri uri = Uri.parse(url);
      String? transactionStatus = uri.queryParameters['vnp_TransactionStatus'];

      if (transactionStatus == '00') {
        // Close the WebView and display success message
        Navigator.pop(context, '00');
      } else {
        // Close the WebView and display failure message
        Navigator.pop(context, '97');
      }
    }
  }

}
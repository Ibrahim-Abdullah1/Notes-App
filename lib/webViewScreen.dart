import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FullScreenWebView extends StatefulWidget {
  const FullScreenWebView({super.key});

  @override
  _FullScreenWebViewState createState() => _FullScreenWebViewState();
}

class _FullScreenWebViewState extends State<FullScreenWebView> {
  late final WebViewController _controller;
  bool isLoading = true; // Variable to track loading state

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
          onHttpError: (HttpResponseError error) {
            setState(() {
              isLoading = false; // Hide loading indicator on error
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              isLoading = false; // Hide loading indicator on error
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            // if (request.url
            //     .startsWith('https://nafeesonline-admin.trecsol.com/login')) {
            //   return NavigationDecision.prevent;
            // }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://nafeesonline-admin.trecsol.com/login'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(), // Show loading spinner
            ),
        ],
      ),
    );
  }
}

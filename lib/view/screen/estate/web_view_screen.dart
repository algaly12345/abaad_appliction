import 'dart:async';
import 'dart:io';
import 'package:abaad/view/base/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {

  final String url;
  WebViewScreen({@required this.url});

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  WebViewController controllerGlobal;
  double _progress = 0.0;
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [
          _buildProgressIndicator(),
          Expanded(
            child: _hasError
                ? Center(
              child: Text(
                "there_is_no_virtual_tour".tr,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            )
                : WebView(
              initialUrl: widget.url ?? '', // Handle null URL gracefully.
              javascriptMode: JavascriptMode.unrestricted,
              onProgress: (progress) {
                setState(() {
                  _progress = progress / 100; // Normalize progress to 0-1.
                });
              },
              onPageFinished: (url) {
                setState(() {
                  _progress = 0.0; // Reset progress when the page is loaded.
                });
              },
              onWebResourceError: (error) {
                setState(() {
                  _hasError = true;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return _progress > 0.0
        ? Center(
      child: LinearProgressIndicator(
        value: _progress,
        backgroundColor: Colors.grey,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
      ),
    )
        : SizedBox(); // Hide the progress indicator when progress is 0.
  }
}
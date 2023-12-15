import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Web View in Dialog Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                hintText: 'Enter the URL',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String url = _textEditingController.text;
                if (url.isNotEmpty) {
                  _showWebViewDialog(context, url);
                } else {
                  // Handle empty URL input
                  print('URL is empty');
                }
              },
              child: Text('Open Web View'),
            ),
          ],
        ),
      ),
    );
  }

  void _showWebViewDialog(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Web View'),
          content: Container(
            width: double.maxFinite,
            height: 300, // Adjust the height as needed
            child: WebView(
              initialUrl: url,
              javascriptMode: JavascriptMode.unrestricted,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

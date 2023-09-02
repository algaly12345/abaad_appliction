import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Button Color Change Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String selectedButton = 'سكني'; // Initialize with default value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Button Color Change Example'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedButton = 'سكني';
                  });
                },
                style: ElevatedButton.styleFrom(
                  primary: selectedButton == 'سكني'
                      ? Colors.green
                      : Theme.of(context).buttonColor,
                ),
                child: Text('residential'.tr),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedButton = 'تجاري';
                  });
                },
                style: ElevatedButton.styleFrom(
                  primary: selectedButton == 'تجاري'
                      ? Colors.green
                      : Theme.of(context).buttonColor,
                ),
                child: Text('commercial'.tr),
              ),
            ],
          ),
          SizedBox(height: 40),
          Text(
            'Selected Value: $selectedButton',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}

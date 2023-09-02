import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

void main() => runApp(QRCodeApp());

class QRCodeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: QRCodeScannerWidget(),
    );
  }
}

class QRCodeScannerWidget extends StatefulWidget {
  @override
  _QRCodeScannerWidgetState createState() => _QRCodeScannerWidgetState();
}

class _QRCodeScannerWidgetState extends State<QRCodeScannerWidget> {
  String result = "Scan a QR Code"; // Initialize with a default message

  Future<void> scanQRCode() async {
    try {
      final ScanResult scanResult = await BarcodeScanner.scan();
      setState(() {
        result = scanResult.rawContent;
      });
    }  catch (e) {
      setState(() {
        result = "Error: $e";
      });
    } catch (e) {
      setState(() {
        result = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Scanner'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              result,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: scanQRCode,
              child: Text('Scan QR Code'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:abaad/helper/route_helper.dart';
import 'package:abaad/view/base/custom_snackbar.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
class QRCodeScannerWidget extends StatefulWidget {
  final List<CameraDescription> cameras;

  QRCodeScannerWidget({@required this.cameras});

  @override
  _QRCodeScannerWidgetState createState() => _QRCodeScannerWidgetState();
}

class _QRCodeScannerWidgetState extends State<QRCodeScannerWidget> {
  String result = "Scan a QR Code"; // Initialize with a default message
  bool isFlashOn = false;

  Future<void> scanQRCode() async {
    try {
      final ScanResult scanResult = await BarcodeScanner.scan(
        options: ScanOptions(
          useCamera: -1, // Use the back camera by default
          autoEnableFlash: isFlashOn,
        ),
      );
      setState(() {
        result = scanResult.rawContent;
        Get.toNamed(RouteHelper.getDetailsRoute( 162));
      });
    } catch (e) {
      setState(() {
        result = "Error: $e";
      });
    }
  }

  void toggleFlash() {
    setState(() {
      isFlashOn = !isFlashOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Scanner'),
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Column(
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
            Positioned(
              bottom: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton.icon(
                    onPressed: toggleFlash,
                    icon: Icon(
                      Icons.flash_on,
                      size: 24,
                    ),
                    label: Text(''), // Empty text
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

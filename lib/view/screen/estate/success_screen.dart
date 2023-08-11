import 'dart:async';
import 'dart:io';
import 'dart:collection';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/helper/route_helper.dart';
import 'package:abaad/util/app_constants.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/view/base/custom_app_bar.dart';
import 'package:abaad/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SuccessScreen extends StatefulWidget {
  final Estate orderModel;
  SuccessScreen({@required this.orderModel});

  @override
  _SuccessScreenState createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  String selectedUrl;
  double value = 0.0;
  bool _canRedirect = true;
  bool _isLoading = true;
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  WebViewController controllerGlobal;

  @override
  void initState() {
    super.initState();
    selectedUrl = '${AppConstants.BASE_URL}/video?estate_id=${widget.orderModel.id}';

    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _exitApp(context),
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: CustomAppBar(title: 'payment'.tr, onBackPressed: () => _exitApp(context)),
        body: Center(
          child: Container(
            width: Dimensions.WEB_MAX_WIDTH,
            child: Stack(
              children: [
                WebView(


                  javascriptMode: JavascriptMode.unrestricted,
                  initialUrl: selectedUrl,
                  zoomEnabled: false,
                  gestureNavigationEnabled: true,
                  userAgent: 'Mozilla/5.0 (iPhone; CPU iPhone OS 9_3 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13E233 Safari/601.1',
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.future.then((value) => controllerGlobal = value);
                    _controller.complete(webViewController);
                  },
                  onPageStarted: (String url) {
                    print('Page started loading: $url');
                    setState(() {
                      _isLoading = true;
                    });
                    _redirect(url);
                  },
                  onPageFinished: (String url) {
                    print('Page finished loading: $url');
                    setState(() {
                      _isLoading = false;
                    });
                    _redirect(url);
                  },
                ),
                _isLoading ? Center(
                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
                ) : SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _redirect(String url) {


    String susscess=url.contains('status').toString();
    print('----------------1$susscess');


    if(susscess=="true"){
      //Get.offNamed(RouteHelper.getOrderSuccessRoute(widget.orderModel.id.toString(), 'success'));
    }

    if(_canRedirect) {

      bool _isSuccess = url.contains('success') && url.contains(AppConstants.BASE_URL);
      bool _isFailed = url.contains('fail') &&  url.contains(AppConstants.BASE_URL);
      bool _isCancel = url.contains('cancel') && url.contains(AppConstants.BASE_URL);

      if (_isSuccess || _isFailed || _isCancel) {


        _canRedirect = false;
      }
      if (_isSuccess) {
       // Get.offNamed(RouteHelper.getOrderSuccessRoute(widget.orderModel.id.toString(), 'success'));
      } else if (_isFailed || _isCancel) {
     //   Get.offNamed(RouteHelper.getOrderSuccessRoute(widget.orderModel.id.toString(), 'fail'));
      }
    }
  }

  Future<bool> _exitApp(BuildContext context) async {
    if (await controllerGlobal.canGoBack()) {
      controllerGlobal.goBack();
      return Future.value(false);
    } else {
   //   return Get.dialog(PaymentFailedDialog(orderID: widget.orderModel.id.toString()));
    }
  }

}

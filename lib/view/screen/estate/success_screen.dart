import 'dart:async';
import 'dart:io';
import 'dart:collection';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/helper/route_helper.dart';
import 'package:abaad/util/app_constants.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/images.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/custom_app_bar.dart';
import 'package:abaad/view/base/custom_button.dart';
import 'package:abaad/view/base/custom_dialog.dart';
import 'package:abaad/view/base/custom_snackbar.dart';
import 'package:abaad/view/base/dot.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SuccessScreen extends StatefulWidget {
  final int  estate_id;
  SuccessScreen({@required this.estate_id});

  @override
  _SuccessScreenState createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {

  double screenWidth = 600;
  double screenHeight = 400;
  Color textColor = const Color(0xFF32567A);

  @override
  void initState() {
    super.initState();


    print("---------------------------------------${widget.estate_id}");


  }

  VideoPlayerController _videoController;
  FilePickerResult _filePickerResult;
  double _uploadProgress = 0.0;
  bool _uploading = false;

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> pickAndPreviewVideo() async {

    FilePickerResult result = await FilePicker.platform.pickFiles(type: FileType.video);

    if (result != null) {
      setState(() {
        _filePickerResult = result;
        _videoController = VideoPlayerController.file(File(result.files.single.path))
          ..initialize().then((_) {
            setState(() {});
          });
      });
    }
  }

  Future<void> uploadVideo() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String  index_value = prefs.getString('estate_id');
    if (_filePickerResult != null) {
      String filePath = _filePickerResult.files.single.path;
      var request = http.MultipartRequest('POST', Uri.parse('${AppConstants.BASE_URL}/api/v1/estate/upload-video'));
      request.fields['id'] = "${index_value}";
      request.files.add(await http.MultipartFile.fromPath('video', filePath));

      setState(() {
        _uploading = true;
        _uploadProgress = 0.0;
      });
      var response = await request.send();
      response.stream.listen((event) {
        setState(() {
          _uploadProgress = response.contentLength != null
              ? event.length / response.contentLength
              : 0;
        });
      }).onDone(() {
        setState(() {
          _uploadProgress = 1.0;
          _uploading = false;
        });
      });

      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        showAnimatedDialog(context, Center(
          child: Container(
            width: 300,
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_LARGE),
            decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.RADIUS_EXTRA_LARGE)),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Image.asset(Images.checked, width: 100, height: 100),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
              Text('ok'.tr, style: robotoBold.copyWith(
                fontSize: 30, color: Theme.of(context).textTheme.bodyText1.color,
                decoration: TextDecoration.none,
              )),
            ]),
          ),
        ), dismissible: false);
        Future.delayed(Duration(seconds: 2), () {
          Get.offAllNamed(RouteHelper.getInitialRoute());
          // Get.offNamed(RouteHelper.getInitialRoute());
        });
      } else {
        print('Failed to upload video');
      }
    } else {
      print('No video file selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'complete_the_process'.tr, onBackPressed: () => Get.back()),
      body: Scaffold(
    body: Center(
    child: Column(


      children: <Widget>[
        Container(
          height: 90,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Image.asset(
            Images.success,
            fit: BoxFit.contain,
            color: Theme.of(context).primaryColor,

          ),
        ),

        Text(
          "thanks".tr,
          style:  robotoBold.copyWith(
            fontSize: 14,
            color: Theme.of(context).primaryColor,
          ),
        ),
        Text(
          "added_successfully".tr,
          style: robotoBold.copyWith(
              fontSize: 20,
              color: Theme.of(context).primaryColor),
        ),

        SizedBox(height: screenHeight * 0.01),
        Text(
          "attach_video".tr,
          textAlign: TextAlign.center,
          style: robotoBold.copyWith(
              fontSize: 15,
              color: Theme.of(context).primaryColor),
        ),
        SizedBox(height: 4,),
        Column(
          children: [

            GestureDetector(
              onTap: (){
                pickAndPreviewVideo();
              },
              child: _videoController != null && _videoController.value.isInitialized? Container(
                height: 230,
                width: 230,
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 1.0
                  ),
                  borderRadius: BorderRadius.all(
                      Radius.circular(5.0) //                 <--- border radius here
                  ),
                ),
                  child: AspectRatio(
                    aspectRatio: _videoController.value.aspectRatio,
                    child: VideoPlayer(_videoController),
                  ),
                ):
      Container(
      height: 230,
      width: 230,
      decoration: BoxDecoration(
        border: Border.all(
              width: 1.0
        ),
        borderRadius: BorderRadius.all(
              Radius.circular(5.0) //                 <--- border radius here
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          Images.video_place,
          fit: BoxFit.contain,


        ),
      ),
    ),
            ),
            // ElevatedButton(
            //   onPressed: pickAndPreviewVideo,
            //   child: Text('Pick and Preview Video'),
            // ),

            ElevatedButton.icon(
                onPressed: _uploading ? null : uploadVideo,
              icon: Icon(Icons.upload_file),  //icon data for elevated button
              label: Text("download_video".tr), //label text
              style: ElevatedButton.styleFrom(
                  primary:Theme.of(context).primaryColor //elevated btton background color
              ),
            ),
            ElevatedButton(
              onPressed: (){
                Get.offAllNamed(RouteHelper.getInitialRoute());
              }, //icon data for elevated button
              child: Text("i_don_t_want_upload".tr), //label text
              style: ElevatedButton.styleFrom(
                  primary:Theme.of(context).primaryColor //elevated btton background color
              ),
            ),
            if (_uploading)
              Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 8),
                  Text('loading_video'.tr),
                ],
              ),
            if (_uploadProgress > 0 && _uploadProgress < 1)
              LinearProgressIndicator(value: _uploadProgress),
          ],
        ),


      ],
    ),
    ),
    ),
    );
  }


}

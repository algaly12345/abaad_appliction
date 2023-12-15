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

class SuccessScreen2 extends StatefulWidget {
  final int  estate_id;
  SuccessScreen2({@required this.estate_id});

  @override
  _SuccessScreenState createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen2> {

  double screenWidth = 600;
  double screenHeight = 400;
  Color textColor = const Color(0xFF32567A);

  @override
  void initState() {
    super.initState();


    print("---------------------------------------${widget.estate_id}");


  }


  FilePickerResult _filePickerResult;
  double _uploadProgress = 0.0;
  bool _uploading = false;


  VideoPlayerController _videoSkeyController;
  FilePickerResult _fileSkyPickerResult;
  double _uploadSkyProgress = 0.0;
  bool _uploadingSky = false;

  @override
  void dispose() {
    _videoSkeyController?.dispose();
    super.dispose();
  }



  Future<void> pickSkyAndPreviewVideo() async {

    FilePickerResult result = await FilePicker.platform.pickFiles(type: FileType.video);

    if (result != null) {
      setState(() {
        _fileSkyPickerResult = result;
        _videoSkeyController = VideoPlayerController.file(File(result.files.single.path))
          ..initialize().then((_) {
            setState(() {});
          });
      });
    }
  }



  Future<void> uploadSkyVideo() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String  index_value = prefs.getString('estate_id');
    if (_fileSkyPickerResult != null) {
      String filePath = _fileSkyPickerResult.files.single.path;
      var request = http.MultipartRequest('POST', Uri.parse('${AppConstants.BASE_URL}/api/v1/estate/upload-sky-view'));
      request.fields['id'] = "${index_value}";
      request.files.add(await http.MultipartFile.fromPath('video', filePath));

      setState(() {
        _uploadingSky = true;
        _uploadSkyProgress = 0.0;
      });
      var response = await request.send();
      response.stream.listen((event) {
        setState(() {
          _uploadSkyProgress = response.contentLength != null
              ? event.length / response.contentLength
              : 0;
        });
      }).onDone(() {
        setState(() {
          _uploadSkyProgress = 1.0;
          _uploadingSky = false;
        });
      });

      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        Future.delayed(Duration(seconds: 2), () {

          Get.snackbar(
            'Thanks'.tr,
            'operation_accomplished_successfully'.tr,
            backgroundColor: Colors.green, // Customize snackbar color
            colorText: Colors.white, // Customize text color
            duration: Duration(seconds: 3), // Set duration in seconds
            snackPosition: SnackPosition.BOTTOM, // Set snackbar position
            margin: EdgeInsets.all(10), // Set margin around the snackbar
            isDismissible: true, // Allow dismissing the snackbar with a tap// Dismiss direction
          );
          // Get.offAllNamed(RouteHelper.getInitialRoute());
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
          height: 70,
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
          "attach_video".tr,
          style: robotoBold.copyWith(
              fontSize: 15,
              color: Theme.of(context).primaryColor),
        ),





        SizedBox(height: 4,),
        Column(
          children: [


            Text("video_drone".tr),
            GestureDetector(
              onTap: (){
                pickSkyAndPreviewVideo();
              },
              child: _videoSkeyController != null && _videoSkeyController.value.isInitialized? Container(
                height: 140,
                width: 140,
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 1.0
                  ),
                  borderRadius: BorderRadius.all(
                      Radius.circular(5.0) //                 <--- border radius here
                  ),
                ),
                child: AspectRatio(
                  aspectRatio: _videoSkeyController.value.aspectRatio,
                  child: VideoPlayer(_videoSkeyController),
                ),
              ):
              Container(
                height: 140,
                width: 140,
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
              onPressed: _uploadingSky ? null : uploadSkyVideo,
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
            if (_uploadingSky)
              Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 4),
                  Text('loading_video'.tr),
                ],
              ),
            if (_uploadSkyProgress > 0 && _uploadSkyProgress < 1)
              LinearProgressIndicator(value: _uploadSkyProgress),
          ],
        ),


      ],
    ),
    ),
    ),
    );
  }


}

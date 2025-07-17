
import 'dart:convert';
import 'dart:io';

import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/controller/user_controller.dart';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/util/app_constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

class SkyView extends StatefulWidget {
  final int index;
  Estate estate;

  SkyView({required this.index,required this.estate});

  @override
  State<SkyView> createState() => _SkyViewState();
}
class _SkyViewState extends State<SkyView> {
    String videoUrl;
  //  VideoPlayerController _controller;
  bool isPlaying = true; // Set to true to start video automatically

   VideoPlayerController _videoController;
   FilePickerResult _filePickerResult;
   double _uploadProgress = 0.0;
   bool _uploading = false;


   @override
  void initState() {
    super.initState();
    // Replace with initial video URL or empty string
    videoUrl =  '${AppConstants.BASE_URL}/storage/app/public/videos/${widget.estate.skyView}'; // Load the previously selected video URL here
    _videoController = VideoPlayerController.file(File(videoUrl))
      ..initialize().then((_) {
        setState(() {});
        if (isPlaying) {
          _videoController.play();
        }
      });

    _videoController = VideoPlayerController.network(
      '${AppConstants.BASE_URL}/storage/app/public/videos/${widget.estate.skyView}',
    )..initialize().then((_) {
      setState(() {});
    });
  }

  Future<void> pickVideo() async {
    final pickedFile = await ImagePicker().getVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        videoUrl = pickedFile.path;
        _videoController = VideoPlayerController.file(File(videoUrl))
          ..initialize().then((_) {
            setState(() {});
            if (isPlaying) {
              _videoController.play();
            }
          });
      });
    }
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


   Future<void> uploadVideo(String  id ) async {

     SharedPreferences prefs = await SharedPreferences.getInstance();

     if (_filePickerResult != null) {
       String filePath = _filePickerResult.files.single.path;
       var request = http.MultipartRequest('POST', Uri.parse('${AppConstants.BASE_URL}/api/v1/estate/upload-sky-view'));
       request.fields['id'] = "${id}";
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

         Get.find<UserController>().getEstateByUser(1, false,widget.estate.userId);
       } else {
         print('Failed to upload video');
       }
     } else {
       print('No video file selected');
     }
   }

  void toggleVideoPlayback() {
    if (_videoController.value.isPlaying) {
      _videoController.pause();
    } else {
      _videoController.play();
    }
    setState(() {
      isPlaying = _videoController.value.isPlaying;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _videoController.dispose();
    _videoController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _videoController.pause();

        return true;
      },
      child: Scaffold(

        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

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
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 1.0
                    ),
                    borderRadius: BorderRadius.all(
                        Radius.circular(5.0) //                 <--- border radius here
                    ),
                  ),
                  // child: Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Image.asset(
                  //     Images.video_place,
                  //     fit: BoxFit.contain,
                  //
                  //
                  //   ),
                  // ),
                ),
              ),
              // ElevatedButton(
              //   onPressed: pickAndPreviewVideo,
              //   child: Text('Pick and Preview Video'),
              // ),

              ElevatedButton.icon(
                onPressed:(){
                  _uploading ? null : uploadVideo(widget.estate.id.toString());
                },
                icon: Icon(Icons.upload_file),  //icon data for elevated button
                label: Text("download_video".tr), //label text
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
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                setState(() {
                  if (_videoController.value.isPlaying) {
                    _videoController.pause();
                  } else {
                    _videoController.play();
                  }
                });
              },
              child: Icon(
                _videoController.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
            ),
            SizedBox(height: 16),
            FloatingActionButton(
              onPressed: () {
                setState(() {
                  if (_videoController.value.isPlaying) {
                    _videoController.pause();
                  }
                  _videoController.seekTo(Duration.zero);
                });
              },
              child: Icon(Icons.stop),
            ),


          ],
        ),
      ),
    );

  }
}

class VideoPlayerWidget extends StatefulWidget {
   String videoUrl;
   VideoPlayerController controller;
   bool isPlaying;

  VideoPlayerWidget({
    required this.videoUrl,
    required this.controller,
   @ required this.isPlaying,
  });

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        VideoPlayer(widget.controller),
        if (!widget.isPlaying)
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                widget.controller.play();
                setState(() {
                  widget.isPlaying = true;
                });
              },
              child: Icon(
                Icons.play_circle_fill,
                size: 80,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ),
      ],
    );
  }
}
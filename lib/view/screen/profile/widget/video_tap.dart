
import 'dart:convert';
import 'dart:io';

import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/controller/user_controller.dart';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

class VideoTab extends StatefulWidget {
  final int index;
  Estate estate;

  VideoTab({@required this.index,@required this.estate});

  @override
  State<VideoTab> createState() => _VideoTabState();
}
class _VideoTabState extends State<VideoTab> {
   String videoUrl;
   VideoPlayerController _controller;
  bool isPlaying = true; // Set to true to start video automatically

  @override
  void initState() {
    super.initState();
    // Replace with initial video URL or empty string
    videoUrl =  '${AppConstants.BASE_URL}/storage/app/public/videos/${widget.estate.videoUrl}'; // Load the previously selected video URL here
    _controller = VideoPlayerController.file(File(videoUrl))
      ..initialize().then((_) {
        setState(() {});
        if (isPlaying) {
          _controller.play();
        }
      });

    _controller = VideoPlayerController.network(
      '${AppConstants.BASE_URL}/storage/app/public/videos/${widget.estate.videoUrl}',
    )..initialize().then((_) {
      setState(() {});
    });
  }

  Future<void> pickVideo() async {
    final pickedFile = await ImagePicker().getVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        videoUrl = pickedFile.path;
        _controller = VideoPlayerController.file(File(videoUrl))
          ..initialize().then((_) {
            setState(() {});
            if (isPlaying) {
              _controller.play();
            }
          });
      });
    }
  }

  Future<void> updateVideo() async {
    if (videoUrl.isNotEmpty) {
      final response = await http.put(
        Uri.parse('YOUR_LARAVEL_API_ENDPOINT/updateVideo'),
        body: {'video_url': videoUrl},
      );

      if (response.statusCode == 200) {
        // Video URL updated successfully.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Video updated successfully!')),
        );
      } else {
        // Handle error.
      }
    }
  }

  void toggleVideoPlayback() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
    setState(() {
      isPlaying = _controller.value.isPlaying;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
          _controller.pause();

        return true;
      },
      child: Scaffold(

        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 5.0,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: videoUrl.isNotEmpty
                        ? VideoPlayerWidget(
                      videoUrl: videoUrl,
                      controller: _controller,
                      isPlaying: isPlaying,
                    )
                        : Center(
                      child: Text('No video'),
                    ),
                  ),
                ),
              ),

              Container(
                padding:  EdgeInsets.all(4.0),
                width: double.infinity,
                color: Colors.transparent,
                child: OutlinedButton.icon(
                    onPressed: pickVideo,
                    icon:Icon(Icons.drive_folder_upload,color:Theme.of(context).primaryColor ),
                    label:  Text("upload_images".tr)),
              ),
              Padding(
                padding:  EdgeInsets.all(4.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: updateVideo,
                      style: ElevatedButton.styleFrom(
                      primary:Theme.of(context).primaryColor),
                      child:  Text('browse_and_add_photos'.tr)),),
              ),
              ElevatedButton(
                onPressed: toggleVideoPlayback,
                child: Text(isPlaying ? 'Pause' : 'Play'),
              ),
            ],
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                setState(() {
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                  } else {
                    _controller.play();
                  }
                });
              },
              child: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
            ),
            SizedBox(height: 16),
            FloatingActionButton(
              onPressed: () {
                setState(() {
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                  }
                  _controller.seekTo(Duration.zero);
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
    @required this.videoUrl,
    @required this.controller,
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

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
    return Scaffold(
     
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(
                child: Center(
                  child: widget.estate.videoUrl == ""
                      ? Text("No video available") // Display a message when video path is null
                      : _controller.value.isInitialized
                      ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                      : CircularProgressIndicator(),
                )
            ),
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
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: pickVideo,
              child: Text('Pick Video'),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: updateVideo,
              child: Text('Update'),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: toggleVideoPlayback,
              child: Text(isPlaying ? 'Pause' : 'Play'),
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
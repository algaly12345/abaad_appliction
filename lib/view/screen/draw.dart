import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Video Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ItemDetailScreen(),
    );
  }
}

class ItemDetailScreen extends StatefulWidget {
  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
   String videoUrl;

  @override
  void initState() {
    super.initState();
    // Replace with initial video URL or empty string
    videoUrl = '';
  }

  Future<void> pickVideo() async {
    final pickedFile = await ImagePicker().getVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        videoUrl = pickedFile.path;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Detail'),
      ),
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
                      ? VideoPlayerWidget(videoUrl: videoUrl)
                      : Container(),
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
          ],
        ),
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  VideoPlayerWidget({@required this.videoUrl});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
   VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(
      File(widget.videoUrl),
    )..initialize().then((_) {
      setState(() {});
      _controller.play();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? VideoPlayer(_controller)
        : CircularProgressIndicator();
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

class VideoUploadScreen extends StatefulWidget {
  @override
  _VideoUploadScreenState createState() => _VideoUploadScreenState();
}

class _VideoUploadScreenState extends State<VideoUploadScreen> {
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
    if (_filePickerResult != null) {
      String filePath = _filePickerResult.files.single.path;
      var request = http.MultipartRequest('POST', Uri.parse('http://192.168.43.55/abbaadRepo/api/v1/estate/upload-video'));
      request.fields['id'] = "147";
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
        print('Video uploaded successfully');
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
      appBar: AppBar(
        title: Text('Video Upload and Preview'),
      ),
      body: Column(
        children: [
          if (_videoController != null && _videoController.value.isInitialized)
            Container(
              height: 500,
              child: AspectRatio(
                aspectRatio: _videoController.value.aspectRatio,
                child: VideoPlayer(_videoController),
              ),
            ),
          ElevatedButton(
            onPressed: pickAndPreviewVideo,
            child: Text('Pick and Preview Video'),
          ),
          ElevatedButton(
            onPressed: _uploading ? null : uploadVideo,
            child: Text('Upload Video'),
          ),
          if (_uploading)
            Column(
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 8),
                Text('Uploading...'),
              ],
            ),
          if (_uploadProgress > 0 && _uploadProgress < 1)
            LinearProgressIndicator(value: _uploadProgress),
        ],
      ),
    );
  }
}





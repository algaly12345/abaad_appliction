import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidgetState extends StatefulWidget {
  String videoPath;
  VideoPlayerWidgetState({Key key,required this.videoPath}) : super(key: key);

  @override
  State<VideoPlayerWidgetState> createState() => _VideoPlayerWidgetStateState();
}

class _VideoPlayerWidgetStateState extends State<VideoPlayerWidgetState> {
  VideoPlayerController _controller;

  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("https://www.facebook.com/watch/?v=260219463456186")
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _isFullScreen
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
            : Container(
          height: 200, // Adjust the height as needed
          child: VideoPlayer(_controller),
        ),
        ButtonBar(
          alignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
              onPressed: () {
                setState(() {
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                  } else {
                    _controller.play();
                  }
                });
              },
            ),
            IconButton(
              icon: Icon(_isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen),
              onPressed: () {
                setState(() {
                  _isFullScreen = !_isFullScreen;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}


// class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
//    VideoPlayerController _controller;
//   bool _isFullScreen = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.asset(widget.videoPath)
//       ..initialize().then((_) {
//         setState(() {});
//       });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         _isFullScreen
//             ? AspectRatio(
//           aspectRatio: _controller.value.aspectRatio,
//           child: VideoPlayer(_controller),
//         )
//             : Container(
//           height: 200, // Adjust the height as needed
//           child: VideoPlayer(_controller),
//         ),
//         ButtonBar(
//           alignment: MainAxisAlignment.center,
//           children: [
//             IconButton(
//               icon: Icon(
//                 _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//               ),
//               onPressed: () {
//                 setState(() {
//                   if (_controller.value.isPlaying) {
//                     _controller.pause();
//                   } else {
//                     _controller.play();
//                   }
//                 });
//               },
//             ),
//             IconButton(
//               icon: Icon(_isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen),
//               onPressed: () {
//                 setState(() {
//                   _isFullScreen = !_isFullScreen;
//                 });
//               },
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//   }
// }

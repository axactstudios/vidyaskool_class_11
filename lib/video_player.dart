import 'dart:io';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoPlayer extends StatefulWidget {
  String path;
  VideoPlayer(this.path);
  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  FlickManager flickManager; var aspectratio;

  VideoPlayerController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // var dir = await getExternalStorageDirectory();
    // String path =
    //     '/storage/emulated/0/${widget.section}/${widget.subject}/${widget.day}/${widget.video}.m4v';
    String path2 = '/storage/sdcard1/Contents/Test.mp4';
    print('____&&&&&&&_____${widget.path}');
    // print(path);

    // File video = File(path);
    File file = File(widget.path);
    print('$file=================');
    // if (file != null)
    //   print(file);
    // else
    //   print('Lag gaye');
    VideoPlayerController _controller = new VideoPlayerController.file(file)
      ..initialize();

    _controller.addListener(() {
      if (_controller.value.hasError) {
        print(
            '=============================${_controller.value.errorDescription}=============');
      }
      if (_controller.value.initialized) {}
      if (_controller.value.isBuffering) {}
    });
    flickManager = FlickManager(videoPlayerController: _controller);
    aspectratio=_controller.value.aspectRatio;
  }

  void delete() {
    final dir = Directory(widget.path);
    dir.deleteSync(recursive: true);
  }

  @override
  void dispose() async {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    // TODO: implement dispose
    await delete();
    super.dispose();
    flickManager.dispose();
    //delete();
  }

  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    final deviceratio=width/height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          width:width*0.85,
          child: AspectRatio(
            aspectRatio: aspectratio,
            child: FlickVideoPlayer(

              flickManager: flickManager,
              preferredDeviceOrientation: [
                DeviceOrientation.landscapeRight,
                DeviceOrientation.landscapeLeft
              ],
            ),
          ),
        ),
      ),
    );
  }
}

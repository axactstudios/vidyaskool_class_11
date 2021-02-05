import 'dart:convert';
import 'dart:io';

// import 'package:ext_storage/ext_storage.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoPlayer2 extends StatefulWidget {
  // String section, subject, day, video;
  // VideoPlayer(this.section, this.subject, this.day, this.video);
  File file;
  VideoPlayer2(this.file);
  @override
  _VideoPlayer2State createState() => _VideoPlayer2State();
}

class _VideoPlayer2State extends State<VideoPlayer2> {
  FlickManager flickManager;

  VideoPlayerController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // var dir = await getExternalStorageDirectory();
    // String path =
    //     '/storage/emulated/0/${widget.section}/${widget.subject}/${widget.day}/${widget.video}.m4v';
    String path2 = '/storage/sdcard1/Contents/Test.mp4';
    // print(widget.path);
    // print(path);

    // File video = File(path);

    // print('$file=================');
    // if (file != null)
    //   print(file);
    // else
    //   print('Lag gaye');
    setUp();
  }

  void setUp() async {
    File f = widget.file;
    VideoPlayerController _controller =
    new VideoPlayerController.file(widget.file)..initialize();
    print('starting');
    _controller.addListener(() {
      if (_controller.value.hasError) {
        print(
            '=============================${_controller.value.errorDescription}=============');
      }
      if (_controller.value.initialized) {}
      if (_controller.value.isBuffering) {}
    });
    flickManager = FlickManager(videoPlayerController: _controller);
    print('done');
  }

  void delete() {
    // final dir = Directory(widget.path);
    // dir.deleteSync(recursive: true);
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: FlickVideoPlayer(
        flickManager: flickManager,
        preferredDeviceOrientation: [
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft
        ],
      ),
    );
  }
}

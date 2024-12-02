// Video by Pixabay: https://www.pexels.com/video/bee-on-a-flower-854251/

import 'package:TapBiz/devkit/ui/reusable/global_widget.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayer1Page extends StatefulWidget {
  @override
  _VideoPlayer1PageState createState() => _VideoPlayer1PageState();
}

class _VideoPlayer1PageState extends State<VideoPlayer1Page> {
  // initialize global widget
  final _globalWidget = GlobalWidget();

  late VideoPlayerController _controller;

  @override
  void initState() {
    _controller = VideoPlayerController.asset('assets/devkit/videos/demo.mp4');
    _controller.addListener(() {
      setState(() {});
    });
    _controller.initialize().then((_) => setState(() {}));

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _globalWidget.globalAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24, 24, 24, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: _globalWidget.createDetailWidget(
                  title: 'Video Player 1',
                  desc:
                      'This is the example of video player from local source / assets.\nVideo by Pixabay'),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : Container(),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: VideoProgressIndicator(_controller, allowScrubbing: true),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: Center(
                child: _globalWidget.createButton(
                    buttonName: _controller.value.isPlaying ? 'Pause' : 'Play',
                    onPressed: () {
                      setState(() {
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                      });
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

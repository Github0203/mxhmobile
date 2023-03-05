import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
 
class VideoPlayerLayout extends StatefulWidget {
  final String? urlMP4;
  const VideoPlayerLayout(String string, {this.urlMP4, Key? key}) : super(key: key);
 
  @override
  State<VideoPlayerLayout> createState() => _VideoPlayerLayoutState();
}
 
class _VideoPlayerLayoutState extends State<VideoPlayerLayout> {
  late VideoPlayerController controller;
  // String videoUrl = '$widget.urlMP4!';
 
  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.network('$widget.urlMP4');
 
    controller.addListener(() {
      setState(() {});
    });
    controller.setLooping(true);
    controller.initialize().then((_) => setState(() {}));
    controller.play();
  }
 
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
          onTap: () {
            if (controller.value.isPlaying) {
              controller.pause();
            } else {
              controller.play();
            }
          },
          child: AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: VideoPlayer(controller),
          ),
        ),
      ),
    );
  }
}
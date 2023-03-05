import 'package:video_player/video_player.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';


import 'package:flutter/services.dart';
class VideoItem extends StatefulWidget {
  File? pathVideo;
  VideoItem(this.pathVideo);

  @override
  State<VideoItem> createState() => _VideoItemState();
}




class _VideoItemState extends State<VideoItem> {
VideoPlayerController? _controller;

@override
void initState() {
super.initState();
_controller = VideoPlayerController.network(widget.pathVideo!.path)
  ..initialize().then((_) {
    setState(() {});  //when your thumbnail will show.
  });
}

@override
void dispose() {
super.dispose();
_controller!.dispose();
}

@override
Widget build(BuildContext context) {
return _controller!.value.isInitialized
      ? Container(
          // width: 200.0,
          // height: 200.0,
          child: VideoPlayer(_controller!),
        )
      // : CircularProgressIndicator();
      : SizedBox();
 }
}
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
 
class VideoThumbnail extends StatefulWidget {
  String videoPath;
  VideoThumbnail(this.videoPath);

  @override
  State<VideoThumbnail> createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<VideoThumbnail> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoPath)
      ..initialize().then((_) {
        setState(() {}); //when your thumbnail will show.
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      child: InkWell(
        child: _controller.value.isInitialized
            ? Container(
                width: 100.0,
                height: 56.0,
                child: Stack(
                  children:[
                     VideoPlayer(_controller),
                     Container(
                      decoration: new BoxDecoration(
     color:   Color.fromARGB(255, 82, 110, 85).withOpacity(0.5),//here i want to add opacity

   border: new Border.all(color: Colors.black54,
   ),),
                      ),
                     Positioned.fill(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Container(
                                                      padding: EdgeInsets.all(3.0),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(30),
                                                        color: Color.fromARGB(66, 214, 201, 201),
                                                        boxShadow: [
                                                          BoxShadow(color: Color.fromARGB(157, 34, 18, 18), spreadRadius: 3),
                                                        ],
                                                      ),
                                                      child: Icon(Icons.play_arrow_outlined, size:30)     ,
                                                    )           
                                                  ),
                                                ),
                                              ),
                  ]
                  ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
        // onTap: () {
        //   // Navigator.push(
        //   //   context,
        //   //   MaterialPageRoute(
        //   //     builder: (context) => VideoViewer(widget.videoPath), //VideoViewer
        //   //   ),
        //   // );
        // },
      ),
    );
  }
}
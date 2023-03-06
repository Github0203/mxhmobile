import 'dart:math';
import 'package:flutter/material.dart';


class PhotoGrid extends StatefulWidget {
      final int? maxImages;
      final List<String>? imageUrls;
      final Function(int)? onImageClicked;
      final Function? onExpandClicked;

  PhotoGrid(
      {@required this.imageUrls,
      @required this.onImageClicked,
      @required this.onExpandClicked,
      this.maxImages = 4,
      Key? key})
      : super(key: key);

  @override
  createState() => _PhotoGridState();
}

class _PhotoGridState extends State<PhotoGrid> {
  @override
  Widget build(BuildContext context) {
    var images = buildImages();
    final double itemHeight = (MediaQuery.of(context).size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = MediaQuery.of(context).size.width / 4;
 
    // print(widget.imageUrls.);
    return 
     GridView.count(
      childAspectRatio: 1,          
      crossAxisCount: widget.imageUrls!.length == 1 ? 1 : widget.imageUrls!.length == 2 ? 2 : widget.imageUrls!.length == 3 ? 3 : 2,
      crossAxisSpacing: 5.0,
      mainAxisSpacing: 5.0,
      children: images,
    );
    // GridView(
    //   gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
    //     maxCrossAxisExtent: 200,
    //     crossAxisSpacing: 5,
    //     mainAxisSpacing:  5,
    //     childAspectRatio: 1,
    //   ),
    //   children: images,
    // );
  }

  List<Widget> buildImages() {
    double setWidth = MediaQuery.of(context).size.width;
    double setHeight = MediaQuery.of(context).size.height;
    int numImages = widget.imageUrls!.length;
    return List<Widget>.generate(min(numImages, widget.maxImages!), (index) {
      String imageUrl = widget.imageUrls![index];

      // If its the last image
      if (index == widget.maxImages! - 1) {
        // Check how many more images are left
        int remaining = numImages - widget.maxImages!;

        // If no more are remaining return a simple image widget
        if (remaining == 0) {
          return GestureDetector(

            child: Container(
              child: 
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),

            ),
            onTap: () => widget.onImageClicked!(index),
          );
        } else {
          // Create the facebook like effect for the last image with number of remaining  images
          return GestureDetector(
            onTap: () => widget.onExpandClicked!(),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(imageUrl, fit: BoxFit.cover),
                Positioned.fill(
                  child: Container(
                    alignment: Alignment.center,
                    color: Color.fromARGB(137, 255, 255, 255),
                    child: Text(
                      '+' + remaining.toString(),
                      style: TextStyle(fontSize: 32),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      } else {
        return GestureDetector(
          child: Container(
             width: setWidth - 26,
              // height: 300,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          onTap: () => widget.onImageClicked!(index),
        );
      }
    });
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'models.dart';

class Utils {
  static String getImgPath(String name, {String format: 'jpg'}) {
    // return 'assets/images/$name.$format';
    return name;
  }

  static String getImgNetwork(String name, {String format: 'jpg'}) {
    return 'assets/images/$name.$format';
  }

  static Future<T?> pushPage<T extends Object>(
      BuildContext context, Widget page) {
    return Navigator.push(
      context,
      CupertinoPageRoute(builder: (ctx) => page),
    );
  }

  // static void showSnackBar(BuildContext context, String msg) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(msg),
  //       duration: Duration(seconds: 2),
  //     ),
  //   );
  // }

  static Widget getWidget(String url) {
    if (url.startsWith('http')) {
      //return CachedNetworkImage(imageUrl: url, fit: BoxFit.cover);
      // return Image.network(url, fit: BoxFit.cover);
      Image.network(
                  getImgPath(url),
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                );
    }
    if (url.endsWith('.png')) {
      // return Image.asset(url,
      //     fit: BoxFit.cover, package: 'flutter_gallery_assets');
      Image.network(
                  getImgPath(url),
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                );
    }
    if (url.endsWith('.jpg')) {
      // return Image.asset(url,
      //     fit: BoxFit.cover, package: 'flutter_gallery_assets');
      return Image.network(
                  getImgPath(url),
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                );
    }
    //return Image.file(File(url), fit: BoxFit.cover);
    // return Image.asset(getImgPath(url), fit: BoxFit.cover);
    return  Image.network(
                  getImgPath(url),
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                );
  }

  static Image? getBigImage(String? url) {
    if (url == null || url.isEmpty) return null;
    if (url.startsWith('http')) {
      //return Image(image: CachedNetworkImageProvider(url), fit: BoxFit.cover);
      return Image.network(url, fit: BoxFit.cover);
    }
    if (url.endsWith('.png')) {
      return Image.asset(url,
          fit: BoxFit.cover, package: 'flutter_gallery_assets');
    }
    //return Image.file(File(url), fit: BoxFit.cover);
    return Image.asset(getImgPath(url), fit: BoxFit.cover);
  }

  // static List<ImageBean> getImageData() {
  //   List<String> urlList = [
  //     'http://c.files.bbci.co.uk/A0D0/production/_103786114_fae87d76-efaa-47ba-b80d-c8631f28a42e.jpg',
  //     'https://vnn-imgs-f.vgcloud.vn/2021/07/12/09/5a8c73f8277a46b29cd14c5f1cdac0b9.jpg',
  //     'https://vnn-imgs-f.vgcloud.vn/2021/07/12/09/5a8c73f8277a46b29cd14c5f1cdac0b9.jpg',
  //     'https://vnn-imgs-f.vgcloud.vn/2021/07/12/09/5a8c73f8277a46b29cd14c5f1cdac0b9.jpg',
  //     'https://vnn-imgs-f.vgcloud.vn/2021/07/12/09/5a8c73f8277a46b29cd14c5f1cdac0b9.jpg',
  //     'https://vnn-imgs-f.vgcloud.vn/2021/07/12/09/5a8c73f8277a46b29cd14c5f1cdac0b9.jpg',
  //     'https://vnn-imgs-f.vgcloud.vn/2021/07/12/09/5a8c73f8277a46b29cd14c5f1cdac0b9.jpg',
  //     'https://vnn-imgs-f.vgcloud.vn/2021/07/12/09/5a8c73f8277a46b29cd14c5f1cdac0b9.jpg',
  //     'https://vnn-imgs-f.vgcloud.vn/2021/07/12/09/5a8c73f8277a46b29cd14c5f1cdac0b9.jpg',
  //   ];
  //   List<ImageBean> list = [];
  //   for (int i = 0; i < urlList.length; i++) {
  //     String url = urlList[i];
  //     list.add(ImageBean(
  //       originPath: url,
  //       middlePath: url,
  //       thumbPath: url,
  //       originalWidth: i == 0 ? 264 : null,
  //       originalHeight: i == 0 ? 258 : null,
  //     ));
  //   }
  //   return list;
  // }
}
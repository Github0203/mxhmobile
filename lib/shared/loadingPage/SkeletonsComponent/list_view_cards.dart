import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class ListviewCardsExamplePage extends StatefulWidget {
  int? count;
  ListviewCardsExamplePage({this.count, Key? key}) : super(key: key);

  @override
  State<ListviewCardsExamplePage> createState() => _ListviewCardsExamplePageState();
}

class _ListviewCardsExamplePageState extends State<ListviewCardsExamplePage> {
  @override
  Widget build(BuildContext context) {
    return _skeletonView();
   

  }

  Widget _skeletonView() => ListView.builder(
        // padding: padding,
        physics: NeverScrollableScrollPhysics(),
        itemCount: widget.count,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(color: Color.fromARGB(255, 184, 183, 183)),
            child: SkeletonItem(
                child: Column(
              children: [
                Row(
                  children: [
                    SkeletonAvatar(
                      style: SkeletonAvatarStyle(
                        shape: BoxShape.circle,
                        width: 50,
                        height: 50,
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: SkeletonParagraph(
                        style: SkeletonParagraphStyle(
                            lines: 3,
                            spacing: 6,
                            lineStyle: SkeletonLineStyle(
                              randomLength: true,
                              height: 10,
                              borderRadius: BorderRadius.circular(8),
                              minLength: MediaQuery.of(context).size.width / 6,
                              maxLength: MediaQuery.of(context).size.width / 3,
                            )),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                SkeletonParagraph(
                  style: SkeletonParagraphStyle(
                      lines: 3,
                      spacing: 6,
                      lineStyle: SkeletonLineStyle(
                        randomLength: true,
                        height: 10,
                        borderRadius: BorderRadius.circular(8),
                        minLength: MediaQuery.of(context).size.width / 2,
                      )),
                ),
                SizedBox(
                  height: 12,
                ),
                SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                    width: double.infinity,
                    minHeight: MediaQuery.of(context).size.height / 8,
                    maxHeight: MediaQuery.of(context).size.height / 3,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SkeletonAvatar(
                            style: SkeletonAvatarStyle(width: 20, height: 20)),
                        SizedBox(width: 8),
                        SkeletonAvatar(
                            style: SkeletonAvatarStyle(width: 20, height: 20)),
                        SizedBox(width: 8),
                        SkeletonAvatar(
                            style: SkeletonAvatarStyle(width: 20, height: 20)),
                      ],
                    ),
                    SkeletonLine(
                      style: SkeletonLineStyle(
                          height: 16,
                          width: 64,
                          borderRadius: BorderRadius.circular(8)),
                    )
                  ],
                )
              ],
            )),
          ),
        ),
      );

  Widget _contentView() => ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Container(
            color: Color.fromARGB(255, 209, 207, 207),
            height: doubleInRange(MediaQuery.of(context).size.height / 8,
                MediaQuery.of(context).size.height / 2),
            child: Center(
              child: Text(
                "CONTENT",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );
}

//  ListView.builder(
//         physics: NeverScrollableScrollPhysics(),
//         itemBuilder: (context, index) => Container(),
//       )

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/models/social_model/post_model_sub.dart';

import '../../../layout/socialapp/cubit/cubit.dart';
import '../../../layout/socialapp/cubit/state.dart';
import '../../../layout/socialapp/sociallayout.dart';
import '../../../models/social_model/post_model.dart';
import '../../../models/social_model/social_user_model.dart';
import '../../../shared/components/components.dart';
import '../../../shared/styles/iconbroken.dart';
import '../CommentsScreenSub.dart';
import '../new_post/new_post.dart';
import 'package:multi_image_layout/multi_image_layout.dart';
import 'dart:io';
import 'package:socialapp/modules/addMedias/addMedias.dart';
import 'package:socialapp/layout/gallery/gallery_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:socialapp/layout/video/video_player.dart';
import 'package:socialapp/shared/network/UrlTypeHelper';

// ignore: must_be_immutable
class viewDetailPost extends StatelessWidget {
  String? idPost;
  String? idPostSub;
viewDetailPost( this.idPost,this.idPostSub);

  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBarNoPop(
          context: context,
          title: 'Chi tiết',
          actions: []),
      body: Builder(builder: (context) {
        // SocialCubit.get(context).getPosts();
        SocialCubit.get(context).viewDetailPost(idPost!, idPostSub!);

        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            SocialUserModel? userModel =
                SocialCubit.get(context).socialUserModel;
            double setWidth = MediaQuery.of(context).size.width;
            double setheight = MediaQuery.of(context).size.height;

            return ConditionalBuilder(
              condition: 
              SocialCubit.get(context).posts2.isNotEmpty &&
                  userModel != null,
              builder: (context) => 
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                  
                  Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: 5,
                    margin: EdgeInsets.zero,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 13),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                           UrlTypeHelper.getType(SocialCubit.get(context).getdetailpostviewImage!.postImage.toString()) == UrlType.IMAGE ?
                          Image.network(
                            SocialCubit.get(context).getdetailpostviewImage!.postImage.toString(),
                            fit: BoxFit.fill,
                            loadingBuilder: (BuildContext context,
                                Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress
                                              .cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                          )
                          :
                          UrlTypeHelper.getType(SocialCubit.get(context).getdetailpostviewImage!.postImage.toString()) == UrlType.VIDEO ?
                          Center(
                            child: Container(
                              height: 300,
                              width: setWidth*0.8,
                              child: VideoThumbnail(SocialCubit.get(context).getdetailpostviewImage!.postImage.toString())),
                          )
                          :
                          Container(),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              InkWell(
                                 onTap: () async {
                      SocialUserModel? postUser =
                          SocialCubit.get(context).socialUserModel;
                      await SocialCubit.get(context).likedByMeSub(
                          // liked: true,
                          postUser: postUser,
                          context: context,
                          // postModel: model,
                          postId: idPost,
                          postIdSub: SocialCubit.get(context).getdetailpostview!.postIdSub.toString()
                                                 );
                    },
                                child: Row(
                                  children: [
                                    Icon(
                                      IconBroken.Heart,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                    Text(
                                         SocialCubit.get(context).getdetailpostview!.likes.toString(),
                                      style: TextStyle(fontSize: 13),
                                    ),
                                    Text(
                                         ' likes',
                                      style: TextStyle(fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                              //if(model.comments != 0)
                              Spacer(),
                              InkWell(
                                  onTap: () {
                                    navigateTo(
                                        context,
                                        CommentsScreenSub(
                                          likes: SocialCubit.get(context).getdetailpostview!.likes, 
                                          postId: idPost,
                                          postUid: SocialCubit.get(context).getdetailpostview!.uId,
                                          postIdSub: SocialCubit.get(context).getdetailpostview!.postIdSub,
                                          ));
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(
                                        IconBroken.Chat,
                                        color: Colors.amber,
                                        size: 20,
                                      ),
                                      Text(
                                        SocialCubit.get(context).getdetailpostview!.comments.toString(),
                                          style: TextStyle(fontSize: 10)),
                                      Text(
                                        " comments",
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                           myDivider(),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                       navigateTo(
                                        context,
                                        CommentsScreenSub(
                                          likes: SocialCubit.get(context).getdetailpostview!.likes, 
                                          postId: idPost,
                                          postUid: SocialCubit.get(context).getdetailpostview!.uId,
                                          postIdSub: SocialCubit.get(context).getdetailpostview!.postIdSub,
                                          ));
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                              radius: 13,
                              backgroundImage:
                                  NetworkImage(SocialCubit.get(context).getdetailpostview!.image.toString())),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            "Write a comment",
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // InkWell(
                  //   onTap: () async {
                  //     SocialUserModel? postUser =
                  //         SocialCubit.get(context).socialUserModel;
                  //     await SocialCubit.get(context).likedByMeSub(
                  //         postUser: postUser,
                  //         context: context,
                  //         // postModel: getmodel,
                  //         postId: getmodel!.postId,
                  //                              );
                  //   },
                  //   child: Row(
                  //     children: const [
                  //       Icon(
                  //         IconBroken.Heart,
                  //         color: Colors.red,
                  //         size: 20,
                  //       ),
                  //       Text(
                  //         ' Like',
                  //         style: TextStyle(fontSize: 13),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(
                    width: 15,
                  ),
                  PopupMenuButton(
                    onSelected: (value) {
                      if (value == 'Share') {
                        // SocialCubit.get(context).createNewPost(
                        //     name: SocialCubit.get(context).model!.name,
                        //     profileImage: SocialCubit.get(context).model!.profilePic,
                        //     postText: postModel.postText,
                        //     postImage: postModel.postImage,
                        //     date: getDate() ,
                        //     time: TimeOfDay.now().format(context).toString()
                        // ) ;
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                          value: 'Share',
                          child: Row(
                            children: const [
                              Icon(Icons.share, color: Colors.green),
                              Text(
                                "Share now",
                              ),
                            ],
                          ))
                    ],
                    child: Row(
                      children: const [
                        Icon(
                          Icons.share,
                          color: Colors.green,
                          size: 20,
                        ),
                        Text(
                          "Share",
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                       

                  ],
                ),
              ),
              fallback: (context) => Center(child: CircularProgressIndicator()),
            );
          },
        );
      }),
    );
  }

  Widget buildPost(
          PostModel model,
          SocialUserModel userModel,
          context,
          index,
          GlobalKey<ScaffoldState> scaffoldKey,
          List<PostModelSub>? lengthsubpost) =>
      Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 5,
        margin: EdgeInsets.zero,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {},
                    child: CircleAvatar(
                        radius: 22,
                        backgroundImage: NetworkImage('${model.image}')),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                          onTap: () {},
                          child: Text(
                            '${model.name}',
                          )),
                      Text(
                        '${model.date} at ${model.time}',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  Spacer(),
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: TextButton(
                          onPressed: () {
                            SocialCubit.get(context).deletePost(model.postId);
                          },
                          child: Text('Delete post'),
                        ),
                      ),
                      PopupMenuItem(
                        child: TextButton(
                          onPressed: () {
                            SocialCubit.get(context).getPosts;
                          },
                          child: Text('Edit post'),
                        ),
                      ),
                    ],
                    child: Row(
                      children: const [
                        Text(
                          "Tùy chọn",
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              myDivider(),
              model.text != null
                  ? Text(
                      '${model.text}',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    )
                  : Text('${model.text}', style: TextStyle(fontSize: 20)),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 6.0),
                    child: SizedBox(
                      height: 20,
                      child: MaterialButton(
                        onPressed: () {},
                        minWidth: 1.0,
                        padding: EdgeInsets.zero,
                        child: Text(
                          "#Software",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {},
                    child: Row(
                      children: [
                        Icon(
                          IconBroken.Heart,
                          color: Colors.red,
                          size: 20,
                        ),
                        Text(
                          '${model.likes}',
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  //if(model.comments != 0)
                  Spacer(),
                  InkWell(
                      onTap: () {
                        navigateTo(
                                        context,
                                        CommentsScreenSub(
                                          likes: SocialCubit.get(context).getdetailpostview!.likes, 
                                          postId: idPost,
                                          postUid: SocialCubit.get(context).getdetailpostview!.uId,
                                          postIdSub: SocialCubit.get(context).getdetailpostview!.postIdSub,
                                          ));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            IconBroken.Chat,
                            color: Colors.amber,
                            size: 20,
                          ),
                          Text('${model.comments} ',
                              style: TextStyle(fontSize: 10)),
                          Text(
                            "Comments",
                            style: TextStyle(fontSize: 10),
                          ),
                        ],
                      )),
                ],
              ),
             
              SizedBox(
                height: 10,
              ),
              myDivider(),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                       navigateTo(
                                        context,
                                        CommentsScreenSub(
                                          likes: SocialCubit.get(context).getdetailpostview!.likes, 
                                          postId: idPost,
                                          postUid: SocialCubit.get(context).getdetailpostview!.uId,
                                          postIdSub: SocialCubit.get(context).getdetailpostview!.postIdSub,
                                          ));
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                              radius: 13,
                              backgroundImage:
                                  NetworkImage('${userModel.image}')),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            "Write a comment",
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      SocialUserModel? postUser =
                          SocialCubit.get(context).socialUserModel;
                      await SocialCubit.get(context).likedByMeSub(
                          
                          postUser: postUser,
                          context: context,
                          // postModel: model,
                          postId: model.postId,
                                               );
                    },
                    child: Row(
                      children: const [
                        Icon(
                          IconBroken.Heart,
                          color: Colors.red,
                          size: 20,
                        ),
                        Text(
                          ' Like',
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  PopupMenuButton(
                    onSelected: (value) {
                      if (value == 'Share') {
                        // SocialCubit.get(context).createNewPost(
                        //     name: SocialCubit.get(context).model!.name,
                        //     profileImage: SocialCubit.get(context).model!.profilePic,
                        //     postText: postModel.postText,
                        //     postImage: postModel.postImage,
                        //     date: getDate() ,
                        //     time: TimeOfDay.now().format(context).toString()
                        // ) ;
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                          value: 'Share',
                          child: Row(
                            children: const [
                              Icon(Icons.share, color: Colors.green),
                              Text(
                                "Share now",
                              ),
                            ],
                          ))
                    ],
                    child: Row(
                      children: const [
                        Icon(
                          Icons.share,
                          color: Colors.green,
                          size: 20,
                        ),
                        Text(
                          "Share",
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      );
}

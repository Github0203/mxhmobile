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
import 'package:socialapp/modules/feeds/feedDetailPost.dart';
import 'package:flutter/cupertino.dart';

// ignore: must_be_immutable
class feedDetail extends StatelessWidget {
  final String? userName;
  String? idPost;
  String? indexImagePost;
  String? idPostSub;
  feedDetail(this.userName, this.idPost, this.indexImagePost, this.idPostSub);

  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBarNoPop(
          context: context,
          title: 'Bài viết của ' + userName.toString(),
          actions: []),
      body: Builder(builder: (context) {
        // SocialCubit.get(context).getPosts();
        SocialCubit.get(context).getMyData();
        SocialCubit.get(context).getDetailSubPost(idPost!);

        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            SocialUserModel? userModel =
                SocialCubit.get(context).socialUserModel;
            double setWidth = MediaQuery.of(context).size.width;
            double setheight = MediaQuery.of(context).size.height;

            return ConditionalBuilder(
              condition: SocialCubit.get(context).posts2.isNotEmpty &&
                  SocialCubit.get(context).socialUserModel != null,
              builder: (context) => 
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => buildPost(
                          SocialCubit.get(context)
                              .posts1[int.parse(indexImagePost!)],
                          userModel!,
                          context,
                          index,
                          scaffoldKey,
                          SocialCubit.get(context).posts1[index].albumImages),
                      separatorBuilder: (context, index) => SizedBox(
                        height: 8,
                      ),
                      itemCount: 1,
                    ),
                    SizedBox(
                      height: 10,
                    ),

                      ListView.separated(
                       separatorBuilder: (context, index1) => SizedBox(
                        height: 8,
                      ),
                      itemCount: SocialCubit.get(context).posts2.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index1) => 
              Center(
                child: 
                GestureDetector(
                  onTap: () => navigateTo(context, viewDetailPost(SocialCubit.get(context).posts1[index1].postId.toString(), SocialCubit.get(context).posts2[index1].postIdSub.toString())),
                  child: Card(
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
                            Image.network(SocialCubit.get(context).posts2[index1].postImage.toString(),
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
                            ),
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
                            postUser: postUser,
                            context: context,
                            // postModel: model,
                            postId: idPost,
                            postIdSub: SocialCubit.get(context).posts2[index1].postIdSub.toString()
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
                                           SocialCubit.get(context).posts2[index1].likes.toString(),
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
                                            likes: SocialCubit.get(context).posts2[index1].likes, 
                                            postId: idPost,
                                            postUid: SocialCubit.get(context).posts2[index1].uId,
                                            postIdSub: SocialCubit.get(context).posts2[index1].postIdSub,
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
                                          SocialCubit.get(context).posts2[index1].comments.toString(),
                                            style: TextStyle(fontSize: 10)),
                                        Text(
                                          " comments",
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                           
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
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
                    onTap: () async {
                      SocialUserModel? postUser =
                          SocialCubit.get(context).socialUserModel;
                      await SocialCubit.get(context).likedByMe(
                          
                          postUser: postUser,
                          context: context,
                          // postModel: model,
                          postId: model.postId,
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
                          '${model.likes}',
                          style: TextStyle(fontSize: 13),
                        ),
                        textModel(text: ' likes')
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
                              likes: model.likes,
                              postId: model.postId,
                              postIdSub: idPostSub,
                              postUid: model.uId,
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
                            likes: model.likes,
                            postId: model.postId,
                            postIdSub: idPostSub,
                            postUid: model.uId,
                          ),
                        );
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
                      await SocialCubit.get(context).likedByMe(
                          postUser: postUser,
                          context: context,
                          postModel: model,
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


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/layout/socialapp/sociallayout.dart';
import 'package:socialapp/modules/feeds/feedDetail.dart';
import 'package:socialapp/modules/new_post/new_post_personal.dart';

import '../../../layout/socialapp/cubit/cubit.dart';
import '../../../layout/socialapp/cubit/state.dart';
import '../../../shared/components/components.dart';
import '../../../shared/styles/changeThemeButton/changeThemeButton.dart';
import '../../../shared/styles/iconbroken.dart';
import '../edit_profile/edit_ProfileScreen.dart';
import 'package:socialapp/layout/button/buttonanimationRequireFriend.dart';
import 'package:socialapp/models/social_model/post_model.dart';
import 'package:socialapp/models/social_model/post_model_sub.dart';
import 'package:socialapp/models/social_model/social_user_model.dart';
import 'package:socialapp/modules/CommentsScreen.dart';
import 'package:socialapp/modules/CommentsScreenAlbum.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialapp/layout/gallery/gallery_view.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:socialapp/modules/albums/loadalbums.dart';
import 'package:socialapp/shared/components/switches.dart';
import 'package:socialapp/shared/network/UrlTypeHelper';
import 'package:socialapp/layout/video/video_player.dart';
import 'package:stacked_card_carousel/stacked_card_carousel.dart';
import 'package:socialapp/layout/video/video_player.dart';
import 'package:socialapp/shared/components/components.dart';
import 'package:socialapp/modules/feeds/feedDetailPostAlbum.dart';

class Photos_Detail_Page extends StatelessWidget {
  final String? titleAlbum;
  final String? idAlbum;
  final String? indexImagePost;
  PostModel? getpostModel;
  PostModelSub getpostModelSub;

  
  Photos_Detail_Page(this.getpostModel, this.getpostModelSub, this.titleAlbum, this.idAlbum, this.indexImagePost, {Key? key}) : super(key: key);
 


  @override
  Widget build(BuildContext context) {
    bool loadingne = false;
     var scaffoldKey = GlobalKey<ScaffoldState>();


    return Scaffold(
      appBar: defaultAppBarNoPop(
       
          context: context,
          title: 'Chi tiết album ' + '"' + titleAlbum.toString() + '"',
          actions: []),
      body: Builder(
        builder: (context) {
          SocialCubit.get(context).getPostsAlbum();
          SocialCubit.get(context).getDetailAlbumImages(idAlbum);
    
          return BlocConsumer<SocialCubit, SocialStates>(
            listener: (context,state){
   
            },
            builder: (context,state)
              {                 
                // SocialUserModel? userModel = SocialCubit.get(context).socialUserModel;
                double setWidth = MediaQuery.of(context).size.width;
                double setheight = MediaQuery.of(context).size.height;
                var userModel = SocialCubit.get(context).socialUserModel;
             
                return ConditionalBuilder(
                   condition: SocialCubit.get(context).posts4.isNotEmpty &&
                    SocialCubit.get(context).socialUserModel != null,
                builder: (context) =>
                 SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                           ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => buildPost(
                          SocialCubit.get(context)
                              .posts3[int.parse(indexImagePost!)],
                          userModel!,
                          context,
                          index,
                          scaffoldKey,
                          SocialCubit.get(context).posts3[index].albumImages),
                      separatorBuilder: (context, index) => SizedBox(
                        height: 8,
                      ),
                      itemCount: 1,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                          Container(
                            height: MediaQuery.of(context).size.height*0.8,
                            width: MediaQuery.of(context).size.width-20,
                            padding: EdgeInsets.all(10),
                            child: StackedCardCarousel(
                              items: 
                              SocialCubit.get(context).posts4.map((getImageuRi) => 
                              UrlTypeHelper.getType(getImageuRi.postImage.toString()) == UrlType.IMAGE ?
                                    GestureDetector (
                                      onTap: () =>  {
                                        navigateTo(context, viewDetailPostAlbum( idAlbum.toString(), getImageuRi.postIdSub.toString())),
                                      },
                                      child: Column(
                                        children: [
                                          AbsorbPointer(
                                            child: Container(
                                              width: setWidth*0.8,
                                              height: setheight*0.4,
                                              child: Image.network(
                                                getImageuRi.postImage.toString(),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                    :
                                    UrlTypeHelper.getType(getImageuRi.postImage.toString()) == UrlType.VIDEO ?
                                    GestureDetector (
                                      onTap: () =>  {
                                        navigateTo(context, viewDetailPostAlbum( idAlbum.toString(), getImageuRi.postIdSub.toString())),
                                      },
                                      child: Column(
                                        children: [
                                          AbsorbPointer(
                                            child: Container(
                                              width: setWidth*0.8,
                                              height: setheight*0.4,
                                              child: VideoThumbnail(getImageuRi.postImage.toString()),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                    :
                                    Container()).toList()
      ),
                          ),
                        ],
                      ),
                    ),
                  ),
                 fallback: (context) => 
                 Center(
                  child: CircularProgressIndicator(),
                 )
                );
              }
    
    
          );
        }
      ),
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
              model.nameAlbum != null
                  ? Text(
                      '${model.nameAlbum}',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    )
                  : Text('${model.nameAlbum}', style: TextStyle(fontSize: 20)),
                  textModel13(text: '-------------',),
              model.des != null
                  ? Text(
                      '${model.des}',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    )
                  : Text('${model.des}', style: TextStyle(fontSize: 15)),
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
                      await SocialCubit.get(context).likedByMeAlbum(
                          
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
                            CommentsScreenAlbum(
                              likes: model.likes,
                              postId: model.postId,
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
                          CommentsScreenAlbum(
                            likes: model.likes,
                            postId: model.postId,
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


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/models/social_model/post_model_sub.dart';
import 'package:socialapp/modules/new_post/edit_post.dart';

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
import 'package:readmore/readmore.dart';
import 'package:expandable/expandable.dart';
import 'package:socialapp/modules/new_post/edit_post.dart';
import 'package:socialapp/shared/network/UrlTypeHelper';
import 'package:socialapp/layout/video/video_player.dart';

// ignore: must_be_immutable
class feedDetail extends StatefulWidget {
  final String? userName;
  String? idPost;
  String? indexImagePost;
  String? idPostSub;
  feedDetail(this.userName, this.idPost, this.indexImagePost, this.idPostSub);

  @override
  State<feedDetail> createState() => _feedDetailState();
}

class _feedDetailState extends State<feedDetail> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool navigatorbutton = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBarNoPop(
          context: context,
          title: 'Bài viết của ' + widget.userName.toString(),
          actions: []),
      body: Builder(builder: (context) {
        SocialCubit.get(context).getPostsDetail(widget.idPost);
        SocialCubit.get(context).getMyData();
        SocialCubit.get(context).getDetailSubPost(widget.idPost!);

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
                         SocialCubit.get(context).postModel!,
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
                Column(
                  children: [
                    // Text(SocialCubit.get(context).posts2.length.toString()),
                    GestureDetector(
                      onTap: () => navigateTo(context, viewDetailPost(widget.idPost, SocialCubit.get(context).posts2[index1].postIdSub.toString())),
                      child: 
                      SocialCubit.get(context).posts2[index1].type == "yes" ?
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
                                textModel(text: 
                                SocialCubit.get(context).posts2[index1].text.toString() == null ?
                                ''
                                :
                                SocialCubit.get(context).posts2[index1].text.toString()
                                ),
                                SizedBox(
                                  height: 10,
                                ),

                                Row(
                children: [
                  Expanded(
                    // height: 30,
                    child: Column(
                      children: [
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          // scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                                          itemCount: SocialCubit.get(context).posts2[index1].tags!.length.clamp(0, 2),
                                          itemBuilder: (context, indextag) {
                                            return  Padding(
                          padding: const EdgeInsetsDirectional.only(end: 6.0),
                          child: SizedBox(
                            height: SocialCubit.get(context).posts2[index1].tags!.length < 3 ?
                            26
                            : SocialCubit.get(context).posts2[index1].tags!.length  == 3 ? 30 :
                            SocialCubit.get(context).posts2[index1].tags!.length > 3 ?
                             SocialCubit.get(context).posts2[index1].tags!.length * 4.5 : 0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start  ,
                              children: [
                                Text(
                                  "# " + SocialCubit.get(context).posts2[index1].tags![indextag],
                                  style: TextStyle(color: Colors.blue),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ),
                        );
                                          },
                                        ),
SocialCubit.get(context).posts2[index1].tags!.length >= 3 ?     
     ExpandableNotifier(  // <-- Provides ExpandableController to its children
      child: Column(
        children: [
          Expandable(           // <-- Driven by ExpandableController from ExpandableNotifier
            collapsed: ExpandableButton(  // <-- Expands when tapped on the cover photo
              child: Text('More...', style: TextStyle( 
      fontSize: 18,
      height: 2, //line height 200%, 1= 100%, were 0.9 = 90% of actual line height
      fontWeight: FontWeight.w300
  ),
  ),
            ),
            expanded: Column(  
              children: [
                
                ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                                          itemCount: SocialCubit.get(context).posts2[index1].tags!.length -2,
                                          itemBuilder: (context, indextag1) {
                                            return  Padding(
                          padding: const EdgeInsetsDirectional.only(end: 3.0),
                          child: SizedBox(
                            height: SocialCubit.get(context).posts2[index1].tags!.length < 3 ?
                            20
                            : SocialCubit.get(context).posts2[index1].tags!.length  == 3 ? 30 :
                            SocialCubit.get(context).posts2[index1].tags!.length > 3 ?
                             SocialCubit.get(context).posts2[index1].tags!.length * 5 : 0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start  ,
                              children: [
                                Text(
                                  "# " + SocialCubit.get(context).posts2[index1].tags!.sublist(2,SocialCubit.get(context).posts2[index1].tags!.length)[indextag1],
                                  style: TextStyle(color: Colors.blue),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ),
                        );
                                          },
                                        ),
                ExpandableButton(       // <-- Collapses when tapped on
                  child: Text("Hide",textAlign: TextAlign.left, style: TextStyle( 
      fontSize: 18,
      height: 2, //line height 200%, 1= 100%, were 0.9 = 90% of actual line height
      fontWeight: FontWeight.w300
  ),),
                ),
              ]
            ),
          ),
        ],
      ),
    )
    :
    Container(),
                             
                                        
                      ],
                    ),
                  ),
                ],
              ),
             Center(
              child: UrlTypeHelper.getType(SocialCubit.get(context).posts2[index1].postImage.toString()) == UrlType.IMAGE ?
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
                                )
              :
              UrlTypeHelper.getType(SocialCubit.get(context).posts2[index1].postImage.toString()) == UrlType.VIDEO ?
              VideoThumbnail(SocialCubit.get(context).posts2[index1].postImage.toString())
              :
              Container(),
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
                                postId: widget.idPost,
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
                                                postId: widget.idPost,
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
                        )
                      :
                      Container()
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
                        height : 0,
                        child: 
                         model.uId == SocialCubit.get(context).socialUserModel!.uId ? 
                        TextButton(
                          onPressed: () {  
                            showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
    title: Text('Delete'),
    titlePadding: EdgeInsetsDirectional.only(start:13,top: 15 ),
    content: Text('Are you sure?'),
    elevation: 8,
    contentPadding: EdgeInsets.all(15),
    actions: [
      OutlinedButton(
          onPressed: (){
               SocialCubit.get(context).deletePost(model.postId); 
               Navigator.pop(context);
               Navigator.pop(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Icon(Icons.done_all_outlined),
              SizedBox(width:10),
              Text('Yes'),
            ],
          ),
      ),
       ElevatedButton(
          style:ButtonStyle(backgroundColor:MaterialStateProperty.all(Colors.blueAccent)) ,
          onPressed: (){
            Navigator.pop(context);
          },
          child:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
           Text('Cancel',style: TextStyle(color: Colors.white))
            ],
          ),
        ),
    ]
                        );
                      });
    
                         },
                          child: Text('Delete post'),
                      )
                          : Container()
                      ),
                      
                      PopupMenuItem(
                          height : 0,
                        child: 
                         model.uId == SocialCubit.get(context).socialUserModel!.uId ? 
                        
                        TextButton(onPressed: () { 
                          setState(() {
      navigatorbutton = true;
    }); 
                          SocialCubit.get(context).listDeleteTemp!.clear();
                          SocialCubit.get(context).getDetailSubPost(model.postId!);
  
 // ); 
 
  showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        navigatorbutton == true ?
                                    Future.delayed(Duration(seconds: 5), () {
                                      SocialCubit.get(context).getTagsPosttoEdit(model.postId!);
                            Navigator.pop(context);
                            SocialCubit.get(context).geteditDetailPost(model.postId!);
             navigateTo(context, EditPostScreen(postId: model.postId));
                                    }) : '';
        return WillPopScope(
            onWillPop: () {
    setState(() {
      navigatorbutton = false;
    });
    Navigator.pop(context);
    return Future(() => false);
  },
            child:AlertDialog(
            // title: new Text("Alert Title"),
            content:   Column(
            mainAxisSize: MainAxisSize.min,
            children: const <Widget>[
              CircularProgressIndicator(),
              SizedBox(height: 10,),
              Text("Loading"),
            ],
          ),
           
          )
        );
      },
    );
   
    // navigatorbutton == true ?
    //                       Future.delayed(Duration(seconds: 5), () {
    //                         Navigator.pop(context);
    //                         SocialCubit.get(context).geteditDetailPost(model.postId!);
    //          navigateTo(context, EditPostScreen(postId: model.postId));
    //     })
    //     :
    //     Navigator.pop(context);
                       
                         },
                          child: Text('Edit post'),
                      )
                      :
                      Container()
                      ),
                      
                      PopupMenuItem(
                        height : 0,
                        child: 
                         model.uId != SocialCubit.get(context).socialUserModel!.uId ?
                      TextButton(
                        onPressed: () {  
                            showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
    title: Text('Unfollow'),
    titlePadding: EdgeInsetsDirectional.only(start:13,top: 15 ),
    content: Text('Are you sure?'),
    elevation: 8,
    contentPadding: EdgeInsets.all(15),
    actions: [
      OutlinedButton(
          onPressed: (){
                SocialCubit.get(context).unFollowingFromPost(SocialCubit.get(context).socialUserModel!.uId, '${model.uId}' );
               Navigator.pop(context);
               Navigator.pop(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Icon(Icons.done_all_outlined),
              SizedBox(width:10),
              Text('Yes'),
            ],
          ),
      ),
       ElevatedButton(
          style:ButtonStyle(backgroundColor:MaterialStateProperty.all(Colors.blueAccent)) ,
          onPressed: (){
            Navigator.pop(context);
          },
          child:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
           Text('Cancel',style: TextStyle(color: Colors.white))
            ],
          ),
        ),
    ]
                        );
                      });
                        SocialCubit.get(context).unFollowingFromPost(SocialCubit.get(context).socialUserModel!.uId, '${model.uId}' );
                      }, child: Text('Unfollow'))
                        :
                      Container()
                      )
                    
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
              model.text != null ?
                            ReadMoreText(
                  '${model.text}',
                  trimLines: 2,
                  colorClickableText: Colors.pink,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: '...Show more',
                  trimExpandedText: ' show less',
                ) : Text(''),
              Row(
                children: [
                  Expanded(
                    // height: 30,
                    child: Column(
                      children: [
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          // scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                                          itemCount: SocialCubit.get(context).posts1[index].tags!.length.clamp(0, 2),
                                          itemBuilder: (context, indextag) {
                                            return  Padding(
                          padding: const EdgeInsetsDirectional.only(end: 3.0),
                          child: SizedBox(
                            height: SocialCubit.get(context).posts1[index].tags!.length < 3 ?
                            26
                            : SocialCubit.get(context).posts1[index].tags!.length  == 3 ? 30 :
                            SocialCubit.get(context).posts1[index].tags!.length > 3 ?
                             SocialCubit.get(context).posts1[index].tags!.length * 4.5 : 0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start  ,
                              children: [
                                Text(
                                  "# " + SocialCubit.get(context).posts1[index].tags![indextag],
                                  style: TextStyle(color: Colors.blue),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ),
                        );
                                          },
                                        ),
SocialCubit.get(context).posts1[index].tags!.length >= 3 ?     
     ExpandableNotifier(  // <-- Provides ExpandableController to its children
      child: Column(
        children: [
          Expandable(           // <-- Driven by ExpandableController from ExpandableNotifier
            collapsed: ExpandableButton(  // <-- Expands when tapped on the cover photo
              child: Text('More...', style: TextStyle( 
      fontSize: 18,
      height: 2, //line height 200%, 1= 100%, were 0.9 = 90% of actual line height
      fontWeight: FontWeight.w300
  ),
  ),
            ),
            expanded: Column(  
              children: [
                
                ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                                          itemCount: SocialCubit.get(context).posts1[index].tags!.length -2,
                                          itemBuilder: (context, indextag1) {
                                            return  Padding(
                          padding: const EdgeInsetsDirectional.only(end: 3.0),
                          child: SizedBox(
                            height: SocialCubit.get(context).posts1[index].tags!.length < 3 ?
                            26
                            : SocialCubit.get(context).posts1[index].tags!.length  == 3 ? 30 :
                            SocialCubit.get(context).posts1[index].tags!.length > 3 ?
                             SocialCubit.get(context).posts1[index].tags!.length * 4.5 : 0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start  ,
                              children: [
                                Text(
                                  "# " + SocialCubit.get(context).posts1[index].tags!.sublist(2,SocialCubit.get(context).posts1[index].tags!.length)[indextag1],
                                  style: TextStyle(color: Colors.blue),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ),
                        );
                                          },
                                        ),
                ExpandableButton(       // <-- Collapses when tapped on
                  child: Text("Hide",textAlign: TextAlign.left, style: TextStyle( 
      fontSize: 18,
      height: 2, //line height 200%, 1= 100%, were 0.9 = 90% of actual line height
      fontWeight: FontWeight.w300
  ),),
                ),
              ]
            ),
          ),
        ],
      ),
    )
    :
    Container(),
                             
                                        
                      ],
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
                              postIdSub: widget.idPostSub,
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
                            postIdSub: widget.idPostSub,
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
                  // InkWell(
                  //   onTap: () async {
                  //     SocialUserModel? postUser =
                  //         SocialCubit.get(context).socialUserModel;
                  //     await SocialCubit.get(context).likedByMe(
                  //         postUser: postUser,
                  //         context: context,
                  //         postModel: model,
                  //         postId: model.postId,
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
      );
}


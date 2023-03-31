
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
import 'package:readmore/readmore.dart';
import 'package:expandable/expandable.dart';
import 'package:socialapp/modules/new_post/edit_post_album.dart';

class Photos_Detail_Page extends StatefulWidget {
  final String? titleAlbum;
  final String? idAlbum;
  final String? indexImagePost;
  PostModel? getpostModel;
  PostModelSub getpostModelSub;

  
  Photos_Detail_Page(this.getpostModel, this.getpostModelSub, this.titleAlbum, this.idAlbum, this.indexImagePost, {Key? key}) : super(key: key);

  @override
  State<Photos_Detail_Page> createState() => _Photos_Detail_PageState();
}

class _Photos_Detail_PageState extends State<Photos_Detail_Page> {
  bool navigatorbutton = true;
  @override
  Widget build(BuildContext context) {
    bool loadingne = false;
     var scaffoldKey = GlobalKey<ScaffoldState>();


    return Scaffold(
      appBar: defaultAppBarNoPop(
       
          context: context,
          title: 'Chi tiết album ' + '"' + widget.titleAlbum.toString() + '"',
          actions: []),
      body: Builder(
        builder: (context) {
          SocialCubit.get(context).getPostsAlbum();
          SocialCubit.get(context).getDetailAlbumImages(widget.idAlbum);
    
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
                              .posts3[int.parse(widget.indexImagePost!)],
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
                                         SocialCubit.get(context).viewDetailPostAlbum(widget.idAlbum.toString(), getImageuRi.postIdSub.toString()),
                                        Future.delayed(Duration(seconds: 1), () {                                          
        navigateTo(context, viewDetailPostAlbum( widget.idAlbum.toString(), getImageuRi.postIdSub.toString()));
    // countnotification = cubit.listNotificationDisplayyes! + 1;
         }),
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
                                         SocialCubit.get(context).viewDetailPostAlbum(widget.idAlbum.toString(), getImageuRi.postIdSub.toString()),
                                        Future.delayed(Duration(seconds: 1), () {                                          
        navigateTo(context, viewDetailPostAlbum( widget.idAlbum.toString(), getImageuRi.postIdSub.toString()));
    // countnotification = cubit.listNotificationDisplayyes! + 1;
         }),
                                       },
                                      // onTap: () =>  {
                                      //   navigateTo(context, viewDetailPostAlbum( widget.idAlbum.toString(), getImageuRi.postIdSub.toString())),
                                      // },
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
             mainAxisAlignment: MainAxisAlignment.start,
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
               SocialCubit.get(context).deletePostAlbum(model.postId); 
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
                          SocialCubit.get(context).getDetailSubPostAlbum(model.postId!);
  
 // ); 
 
  showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        navigatorbutton == true ?
                                    Future.delayed(Duration(seconds: 5), () {
                                      SocialCubit.get(context).getTagsPostAlbumtoEdit(model.postId!);
                            Navigator.pop(context);
                            SocialCubit.get(context).geteditDetailPostAlbum(model.postId!);
             navigateTo(context, EditPostScreenAlbum(postId: model.postId));
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
              model.nameAlbum != null
                  ? Text(
                      '${model.nameAlbum}',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    )
                  : Text('${model.nameAlbum}', style: TextStyle(fontSize: 20)),
                  textModel13(text: '-------------',),
                  model.des != null ?
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ReadMoreText(
                                              '${model.des}',
                                              trimLines: 2,
                                              colorClickableText: Colors.pink,
                                              trimMode: TrimMode.Line,
                                              trimCollapsedText: '...Show more',
                                              trimExpandedText: ' show less',
                                            ),
                            ) : Text(''),
              
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      // height: 30,
                      child: Column(
                        children: [
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            // scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                                            itemCount: SocialCubit.get(context).posts3[index].tags!.length.clamp(0, 2),
                                            itemBuilder: (context, indextag) {
                                              return  Padding(
                            padding: const EdgeInsetsDirectional.only(end: 3.0),
                            child: SizedBox(
                              height: SocialCubit.get(context).posts3[index].tags!.length < 3 ?
                              26
                              : SocialCubit.get(context).posts3[index].tags!.length  == 3 ? 30 :
                              SocialCubit.get(context).posts3[index].tags!.length > 3 ?
                               SocialCubit.get(context).posts3[index].tags!.length * 4.5 : 0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start  ,
                                children: [
                                  Text(
                                    "# " + SocialCubit.get(context).posts3[index].tags![indextag],
                                    style: TextStyle(color: Colors.blue),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                            ),
                          );
                                            },
                                          ),
              SocialCubit.get(context).posts3[index].tags!.length >= 3 ?     
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
                                            itemCount: SocialCubit.get(context).posts3[index].tags!.length -2,
                                            itemBuilder: (context, indextag1) {
                                              return  Padding(
                            padding: const EdgeInsetsDirectional.only(end: 3.0),
                            child: SizedBox(
                              height: SocialCubit.get(context).posts3[index].tags!.length < 3 ?
                              26
                              : SocialCubit.get(context).posts3[index].tags!.length  == 3 ? 30 :
                              SocialCubit.get(context).posts3[index].tags!.length > 3 ?
                               SocialCubit.get(context).posts3[index].tags!.length * 4.5 : 0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start  ,
                                children: [
                                  Text(
                                    "# " + SocialCubit.get(context).posts3[index].tags!.sublist(2,SocialCubit.get(context).posts3[index].tags!.length)[indextag1],
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


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
import '../CommentsScreen.dart';
import '../new_post/new_post.dart';
import 'package:multi_image_layout/multi_image_layout.dart';
import 'dart:io';
import 'package:socialapp/shared/loadingPage/SkeletonsComponent/list_view_cards.dart';
import 'package:socialapp/layout/gallery/gallery_view.dart';
import 'package:socialapp/modules/feeds/feedDetail.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:readmore/readmore.dart';
import 'package:expandable/expandable.dart';
 

class Feeds extends StatefulWidget {

  @override
  State<Feeds> createState() => _FeedsState();
}

class _FeedsState extends State<Feeds> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
   bool _isLoading = true;
   bool navigatorbutton = true;
   ScrollController scrollController = ScrollController(
  initialScrollOffset: 2, // or whatever offset you wish
  keepScrollOffset: true,
);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  // 1. Using Timer
    Timer(Duration(seconds: 5), () {
      setState(() {
        _isLoading = false;
      });
    });
  }
  Widget build(BuildContext context) {
    
    return Builder(
      builder: (context) {
        
        SocialCubit.get(context).getMyData();
         print('MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM');
        print(SocialCubit.get(context).posts1.length.toString());
        Future.delayed(Duration(seconds: 3), () {
          
          SocialCubit.get(context).getAllUsersFriend();
          SocialCubit.get(context).getPosts();
          if(SocialCubit.get(context).posts1.length == 0){
            _isLoading = false;
          }
        });
   


        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {
                if (state is SocialCreatePostSuccessState){
    showToast(text: "Đã thêm bài viết thành công", state: ToastStates.SUCCESS);
                // loadingne = true;
                }
                if (state is SocialCreatePostErrorState){
    showToast(text: "Thêm bài viết thất bại", state: ToastStates.ERROR);
                }
          },
          builder: (context, state) {
            SocialUserModel? userModel = SocialCubit.get(context).socialUserModel;
            double setWidth = MediaQuery.of(context).size.width;
            double setheight = MediaQuery.of(context).size.height;

            return RefreshIndicator(
              onRefresh: () async { setState(() {}); },
              child: ConditionalBuilder(
                condition: 
                SocialCubit.get(context).posts1.isNotEmpty &&
                    SocialCubit.get(context).socialUserModel != null,
                builder: (context) => 
                userModel == null ?
                Center(child: SizedBox(
                  width: setWidth-20,
                  height: 1000,
                  child: ListviewCardsExamplePage(count: 3),
                )) 
                :
                SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        elevation: 5,
                        margin: EdgeInsets.all(8),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    navigateTo(context,SocialLayout(4));
                                  },
                                  child: CircleAvatar(
                                      radius: 22,
                                      backgroundImage:
                                      NetworkImage('${userModel!.image}')),
                                ),
            
                                TextButton(
                                  onPressed: () {
                                    SocialCubit.get(context).postImage = null;
                                    navigateTo(context, NewPostScreen());
                                  },
                                  child: SizedBox(
                                    width: 200,
                                    child: Text("What is in your mind ...",
                                      style: const TextStyle(color: Colors.grey),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ),
                              ],
                            ),
            
                            Row(
                              children: [
            
                                Expanded(
                                  child: TextButton(
                                      onPressed: () {
            
                                         navigateTo(context, NewPostScreen());
            
                                      },
                                      child: Row(
                                        children: const [
                                          Icon(IconBroken.Image),
                                          SizedBox(width: 5,),
                                          Text("image/video",
                                              ),
                                        ],
                                      )),
                                ),
                               Spacer(),
            
                                Expanded(
                                  child: TextButton(
                                      onPressed: () {},
                                      child: Row(
                                        children: const [
                                          Icon(
                                            Icons.tag,
                                            color: Colors.red,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "#TAGS",
                                            style: TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      )),
                                ),
            
            
            
                              ],
                            )
                          ],
                        ),
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) =>
                         buildPost(SocialCubit.get(context).posts1[index],userModel,context, index,scaffoldKey, SocialCubit.get(context).posts1[index].albumImages),
                        separatorBuilder: (context, index) => SizedBox(
                          height: 8,
                        ),
                        itemCount: (SocialCubit.get(context).posts1.length),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                
                fallback: (context) => 
                userModel == null ?
                Center(child: SizedBox(
                  width: setWidth-20,
                  height: 1000,
                  child: ListviewCardsExamplePage(count: 3),
                ))
                :
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      navigateTo(context,SocialLayout(4));
                                    },
                                    child: CircleAvatar(
                                        radius: 22,
                                        backgroundImage:
                                        NetworkImage('${userModel!.image}')),
                                  ),
                
                                  TextButton(
                                    onPressed: () {
                                      
                                     
                                      navigateTo(context, NewPostScreen());
                                     
                                    },
                                    child: SizedBox(
                                      width: 100,
                                      child: Text("What is in your mind ...",
                                        style: const TextStyle(color: Colors.grey),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                             SingleChildScrollView(
                               child: Center(
                                child:
                                _isLoading == true ?
                                SizedBox(
                                  width: setWidth -20,
                                  height: 500,
                                  child: ListviewCardsExamplePage(count: 1))
                                : 
                                textModel(text: 'No have post yet')
                                                         
                                ),
                             ),
                            ]
                  ),
                )
              ),
            );
          },
        );
      }
    );
  }

  Widget buildPost(PostModel model, SocialUserModel userModel ,context, index,GlobalKey<ScaffoldState> scaffoldKey, List<PostModelSub>? lengthsubpost) => Card(
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
                    onTap: () {
                                    navigateTo(context,SocialLayout(4));
                                  },
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
                          onTap: () {

                          },
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
              
              // if (model.subPost.postImage.toString() != null)
                // Padding(
                //     padding: const EdgeInsetsDirectional.only(top: 10),
                //     child: Image(
                //       image: NetworkImage('${model.postImage}'),
                //     )),
                // if (model.subPost != null)
                Padding(
                    padding: const EdgeInsetsDirectional.only(top: 10),
                //     child: MultiImageViewer(
                // images: [
                  
                // ],),
                child: 
                  StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .doc('${model.postId}')
                .collection('posts')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) return const Text('Loading...');
              final int surveysCount = snapshot.data!.docs.length;
              List<DocumentSnapshot> documents = snapshot.data!.docs;
              
              List<String> listpostIdSubID = [];
              documents.forEach((doc) {
                    listpostIdSubID.add(doc['postIdSub'].toString(),);
              });
              
              List<String> urls = [];
              
              documents.forEach((doc) {
                if(doc['display'] == 'yes'){
                    urls.add(doc['postImage'].toString(),);
                }
              });

              print(urls.length.toString());
              

              return Center(
                child:
                Container(
                   width: MediaQuery.of(context).size.width - 26,
              height: urls.length == 1 ?
                      250 : 
                      urls.length == 2 ?
                      130 :
                      urls.length == 3 ?
                      140 : 
                      urls.length >= 4 ?
                      400 : 0,
              color: Color.fromARGB(0, 212, 212, 212),
              constraints: BoxConstraints(
    maxHeight: double.infinity,
),
                  child: 
                  PhotoGrid(
                            imageUrls: urls,
                            onImageClicked: (i) => 
                                        // onTap:() {
              Navigator.push(
    context, CupertinoPageRoute(
      builder: (context) => feedDetail('${userModel.name}', '${model.postId}', i.toString(),
                                       listpostIdSubID.toString() , 
                                        )))
            // },
    ,
                            onExpandClicked: () => print('Expand Image was clicked'),
                            maxImages: 4,
                          ),
                ),
              );
            }),
                
              

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
                  controller: scrollController,
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
                          postModel: model,
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
                            CommentsScreen(likes: model.likes, postId: model.postId,postUid: model.uId,));
                      },
                      child: Row(

                        mainAxisAlignment: MainAxisAlignment.end,
                        children:  [
                          Icon(
                            IconBroken.Chat,
                            color: Colors.amber,
                            size: 20,
                          ),
                          Text('${model.comments} ', style: TextStyle(fontSize: 10)),
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
                          CommentsScreen(likes: model.likes, postId: model.postId,postUid: model.uId,),
                        );
                      },
                      child: Row(

                        children: [

                          CircleAvatar(
                              radius: 13,
                              backgroundImage: NetworkImage('${userModel.image}')),
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
                      SocialUserModel ? postUser = SocialCubit.get(context).socialUserModel;
                      await SocialCubit.get(context).likedByMe(
                          postUser: postUser,
                          context: context,
                          postModel: model,
                          postId: model.postId
                      );

                    },
                    child: Row(
                      children: [
                        // Icon(
                        //   IconBroken.Heart,
                        //   color: Colors.red,
                        //   size: 20,
                        // ),
                        // Text(
                        //   SocialCubit.get(context).likedpost.toString(),
                        //   style: TextStyle(fontSize: 13),
                        // ),
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


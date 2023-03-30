import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/layout/socialapp/sociallayout.dart';
import 'package:socialapp/modules/feeds/feedDetail.dart';
import 'package:socialapp/modules/new_post/new_post_album.dart';

import '../../../layout/socialapp/cubit/cubit.dart';
import '../../../layout/socialapp/cubit/state.dart';
import '../../../shared/components/components.dart';
import '../../../shared/styles/changeThemeButton/changeThemeButton.dart';
import '../../../shared/styles/iconbroken.dart';
import '../edit_profile/edit_ProfileScreen.dart';
import './photos_videos.dart';
import 'package:socialapp/layout/button/buttonanimationRequireFriend.dart';
import 'package:socialapp/layout/button/buttonanimationFollow.dart';
import 'package:socialapp/models/social_model/post_model.dart';
import 'package:socialapp/models/social_model/post_model_sub.dart';
import 'package:socialapp/models/social_model/social_user_model.dart';
import 'package:socialapp/modules/CommentsScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialapp/layout/gallery/gallery_view.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

import 'dart:async';
import 'dart:math';

import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:readmore/readmore.dart';
import 'package:expandable/expandable.dart';


class ProfileScreen extends StatefulWidget {
  
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {


@override
  void initState() {
    super.initState();
    // requestPermission();
    // // getToken();
    // initInfo();
  }


  @override
  Widget build(BuildContext context) {
    bool loadingne = false;
     var scaffoldKey = GlobalKey<ScaffoldState>();
    return Builder(
      builder: (context) {

        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context,state){
              if (state is SocialCreatePostSuccessState){
    showToast(text: "Đã thêm bài viết thành công", state: ToastStates.SUCCESS);
                loadingne = true;
                }
                if (state is SocialCreatePostErrorState){
    showToast(text: "Thêm bài viết thất bại", state: ToastStates.ERROR);
                }
          },
          builder: (context,state)
            {                 
              // SocialUserModel? userModel = SocialCubit.get(context).socialUserModel;
              double setWidth = MediaQuery.of(context).size.width;
              double setheight = MediaQuery.of(context).size.height;
              var socialUserModel = SocialCubit.get(context).socialUserModel;
              var profileImage = SocialCubit.get(context).profileImage;
              var coverImage = SocialCubit.get(context).coverImage;
              SocialCubit.get(context).getPostsFriend(socialUserModel!.uId);
              SocialCubit.get(context).getFollowers(socialUserModel.uId);
              SocialCubit.get(context).getFollowerings(socialUserModel.uId);
              return ConditionalBuilder(
                 condition: SocialCubit.get(context).posts1.isNotEmpty &&
                  SocialCubit.get(context).socialUserModel != null,
              builder: (context) =>
               SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 180,
                          child: Stack(
                            alignment: AlignmentDirectional.bottomCenter,
                            children: [
                              Align(
                                child: Container(
                                  height: 140,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(topLeft:Radius.circular(4),topRight:Radius.circular(4) ),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              '${socialUserModel!.cover}'),
                                          fit: BoxFit.cover)),
                                ),
                                alignment: AlignmentDirectional.topCenter,
                              ),
                              CircleAvatar(
                                radius: 64,
                                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundImage: NetworkImage(
                                      '${socialUserModel.image}'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5,),
                        Text(
                          '${socialUserModel.name}',
                          style:Theme.of(context).textTheme.bodyText1,
                        ),
                        Text(
                          '${socialUserModel.bio}',
                          style:Theme.of(context).textTheme.caption,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  child: Column(
                                    children: [
                                      Text(
                                        SocialCubit.get(context).posts1.length.toString(),
                                        style: Theme.of(context).textTheme.subtitle2,
                                      ),
                                      Text(
                                        'Posts',
                                        style: Theme.of(context).textTheme.caption,
                                      ),
                                    ],
              
                                  ),
                                  onTap: (){},
                                ),
                              ),
              
                              
                              Expanded(
                                child: InkWell(
                                  child: Column(
                                    children: [
                                      Text(
                                        SocialCubit.get(context).followModel!.length.toString(),
                                        
                                        style: Theme.of(context).textTheme.subtitle2,
                                      ),
                                      Text(
                                        'Followers',
                                        style: Theme.of(context).textTheme.caption,
                                      ),
                                    ],
              
                                  ),
                                  onTap: (){},
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  child: Column(
                                    children: [
                                      Text(
                                        // '103',
                                        SocialCubit.get(context).getIDFollowing == null ?
                                        '0' :
                                        SocialCubit.get(context).getIDFollowing.toString(),
                                        style: Theme.of(context).textTheme.subtitle2,
                                      ),
                                      Text(
                                        'Followings',
                                        style: Theme.of(context).textTheme.caption,
                                      ),
                                    ],
              
                                  ),
                                  onTap: (){},
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                child:const Text('Add Photos',style: TextStyle(color: Colors.blue),) , 
                                onPressed: (){
                                SocialCubit.get(context).paths = null;
                                  navigateTo(context, NewPostPersonalScreen());
                                },
                                style:OutlinedButton.styleFrom(primary: Colors.grey)
                              ),
              
                            ),
                            SizedBox(width: 10,),
                            OutlinedButton(
              
                              child:Icon(IconBroken.Edit, size:16,color: Colors.blue,) , onPressed: (){
                                SocialCubit.get(context).coverImage = null;
                                SocialCubit.get(context).profileImage = null;
                                navigateTo(context,
                                 EditProfileScreen());
                            },
                                style:OutlinedButton.styleFrom(primary: Colors.grey)
              
                            ),
              
                          ],
                        ),
                        Column(
              
                          children: [
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(10),
                              child: Row(
                                          
                                children: [
                                          
                                  Icon(Icons.dark_mode_outlined,size: 20,),
                                  Text( '  Night Mode',style: TextStyle(fontSize: 15),),
                                  Spacer(),
                                  SwitchWidget(),
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(10),
                              height: 60,
                              child: InkWell(
                                onTap: (){
                                  SocialCubit.get(context).signOut(context);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children:
                                  const [
                                    Icon(Icons.power_settings_new,size: 20,),
                                    SizedBox(width: 10,),
                                    Text('SignOut',style: TextStyle(fontSize: 15),)
                                  ],
                                ),
                              ),
                            ),
                           Container(
                             child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                               mainAxisSize: MainAxisSize.max,
                                               crossAxisAlignment: CrossAxisAlignment.start,
                                               children: [
                                                 Expanded(
                                                   child: TextButton(
                                                     // onPressed: () {
                                                     //   // SocialCubit.get(context).getPostImage();
                                                     //   SocialCubit.get(context).selectImages();
                                                     // },
                                                 onPressed: () {
                                                  SocialCubit.get(context).getUserDataFriend(socialUserModel.uId);
                                                  SocialCubit.get(context).getImageDataCubut(socialUserModel.uId);
                                                 navigateTo(context, Photos_videos(socialUserModel.name, ));
                                                 },
                                                     child: Row(
                                                       mainAxisAlignment: MainAxisAlignment.start,
                                                       children: const [
                              Icon(IconBroken.Image),
                              SizedBox(
                                width: 5,
                              ),
                              Text('photo / video'),
                                                       ],
                                                     ),
                                                   ),
                                                 ),
                                               ],
                                             ),
                           ),
                           SizedBox(height: 10,),
                            /////// what is in your
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                              decoration: BoxDecoration(
                              color: Colors.white,
                                                          borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
    ],
                              ),
                              child: Row(
                                                        children: [
                              InkWell(
                                onTap: () {
                                  navigateTo(context,SocialLayout(4));
                                },
                                child: CircleAvatar(
                                    radius: 22,
                                    backgroundImage:
                                    NetworkImage(socialUserModel.image.toString())),
                              ),
                            
                              TextButton(
                                onPressed: () {
                                  navigateTo(context, NewPostPersonalScreen());
                                },
                                child: SizedBox(
                                  // width: 100,
                                  child: Text("What is in your mind ...",
                                    style: const TextStyle(color: Colors.grey),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ),
                                                        ],
                                                      ),
                            ),

                              SizedBox(height: 30,),
                            ////// post of persion
                            Container(
                              child:  ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => buildPost(SocialCubit.get(context).posts1[index],socialUserModel,context, index,scaffoldKey, SocialCubit.get(context).posts1[index].albumImages),
                        separatorBuilder: (context, index) => SizedBox(
                        height: 8,
                        ),
                        itemCount: 
                        (SocialCubit.get(context).posts1.length)
                      ),
                            ),
                          ],
                        ),
              
                      ],
                    ),
                  ),
                ),
               fallback: (context) => SingleChildScrollView(
                 child: Column(
                        children: [
                          SizedBox(
                            height: 180,
                            child: Stack(
                              alignment: AlignmentDirectional.bottomCenter,
                              children: [
                                Align(
                                  child: Container(
                                    height: 140,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(topLeft:Radius.circular(4),topRight:Radius.circular(4) ),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                '${socialUserModel!.cover}'),
                                            fit: BoxFit.cover)),
                                  ),
                                  alignment: AlignmentDirectional.topCenter,
                                ),
                                CircleAvatar(
                                  radius: 64,
                                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                  child: CircleAvatar(
                                    radius: 60,
                                    backgroundImage: NetworkImage(
                                        '${socialUserModel.image}'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 5,),
                          Text(
                            '${socialUserModel.name}',
                            style:Theme.of(context).textTheme.bodyText1,
                          ),
                          Text(
                            '${socialUserModel.bio}',
                            style:Theme.of(context).textTheme.caption,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    child: Column(
                                      children: [
                                        Text(
                                          SocialCubit.get(context).posts1.length.toString(),
                                          style: Theme.of(context).textTheme.subtitle2,
                                        ),
                                        Text(
                                          'Posts',
                                          style: Theme.of(context).textTheme.caption,
                                        ),
                                      ],
                             
                                    ),
                                    onTap: (){},
                                  ),
                                ),
                             
                                
                                Expanded(
                                  child: InkWell(
                                    child: Column(
                                      children: [
                                        Text(
                                          SocialCubit.get(context).followModel!.length.toString(),
                                          style: Theme.of(context).textTheme.subtitle2,
                                        ),
                                        Text(
                                          'Followers',
                                          style: Theme.of(context).textTheme.caption,
                                        ),
                                      ],
                             
                                    ),
                                    onTap: (){},
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    child: Column(
                                      children: [
                                        Text(
                                          SocialCubit.get(context).getIDFollowing == null ?
                                        '0' :
                                        SocialCubit.get(context).getIDFollowing.toString(),
                                          
                                          style: Theme.of(context).textTheme.subtitle2,
                                        ),
                                        Text(
                                          'Followings',
                                          style: Theme.of(context).textTheme.caption,
                                        ),
                                      ],
                             
                                    ),
                                    onTap: (){},
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  child:const Text('Add Photos',style: TextStyle(color: Colors.blue),) , onPressed: (){
                                  SocialCubit.get(context).paths = null;
                                  SocialCubit.get(context).editsubpostTempWhenCreatePost = null;
                                    navigateTo(context, NewPostPersonalScreen());
                                  },
                                  style:OutlinedButton.styleFrom(primary: Colors.grey)
                                ),
                             
                              ),
                              SizedBox(width: 10,),
                              OutlinedButton(
                             
                                child:Icon(IconBroken.Edit, size:16,color: Colors.blue,) , onPressed: (){
                                  SocialCubit.get(context).coverImage = null;
                                  SocialCubit.get(context).profileImage = null;
                                  navigateTo(context,
                                   EditProfileScreen());
                              },
                                  style:OutlinedButton.styleFrom(primary: Colors.grey)
                             
                              ),
                             
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                             
                              children: [
                                Row(
                             
                                  children: [
                             
                                    Icon(Icons.dark_mode_outlined,size: 20,),
                                    Text( '  Night Mode',style: TextStyle(fontSize: 15),),
                                    Spacer(),
                                    SwitchWidget(),
                                  ],
                                ),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(10),
                                  height: 60,
                                  child: InkWell(
                                    onTap: (){
                                      SocialCubit.get(context).signOut(context);
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children:
                                      const [
                                        Icon(Icons.power_settings_new,size: 20,),
                                        SizedBox(width: 10,),
                                        Text('SignOut',style: TextStyle(fontSize: 15),)
                                      ],
                                    ),
                                  ),
                                ),
                             SizedBox(height: 10,),
                             Container(
                             child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                               mainAxisSize: MainAxisSize.max,
                                               crossAxisAlignment: CrossAxisAlignment.start,
                                               children: [
                                                 Expanded(
                                                   child: TextButton(
                                                     // onPressed: () {
                                                     //   // SocialCubit.get(context).getPostImage();
                                                     //   SocialCubit.get(context).selectImages();
                                                     // },
                                                 onPressed: () {
                                                  SocialCubit.get(context).getUserDataFriend(socialUserModel.uId);
                                                  SocialCubit.get(context).getImageDataCubut(socialUserModel.uId);
                                                 navigateTo(context, Photos_videos(socialUserModel.name, ));
                                                 },
                                                     child: Row(
                                                       mainAxisAlignment: MainAxisAlignment.start,
                                                       children: const [
                              Icon(IconBroken.Image),
                              SizedBox(
                                width: 5,
                              ),
                              Text('photo / video'),
                                                       ],
                                                     ),
                                                   ),
                                                 ),
                                               ],
                                             ),
                           ),
                             SizedBox(height: 10,),
                                /////// what is in your
                                Container(
                                  padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                                  decoration: BoxDecoration(
                                  color: Colors.white,
                                                              borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3), // changes position of shadow
                                    ),
                   ],
                                  ),
                                  child: Row(
                                                            children: [
                                  InkWell(
                                    onTap: () {
                                      navigateTo(context,SocialLayout(4));
                                    },
                                    child: CircleAvatar(
                                        radius: 22,
                                        backgroundImage:
                                        NetworkImage(socialUserModel.image.toString())),
                                  ),
                                
                                  TextButton(
                                    onPressed: () {
                                      navigateTo(context, NewPostPersonalScreen());
                                    },
                                    child: SizedBox(
                                      // width: 100,
                                      child: Text("What is in your mind ...",
                                        style: const TextStyle(color: Colors.grey),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ),
                                                            ],
                                                          ),
                                ),
               
                                  SizedBox(height: 30,),
                                ////// post of persion
                                Center(
                              child:textModel(
                                fontSize: 20,
                                text: 'Chưa có bài viết nào'
                                )
                              ),
                              ],
                            ),
                          ),
                             
                        ],
                      ),
               ),
              );
            }


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
          child: 
           model.uId.toString() == userModel.uId.toString() ?
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {

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
                        

                        child: TextButton(onPressed: () {  SocialCubit.get(context).deletePost(model.postId); },
                          child: Text('Delete post'),
                      ),
                      ),
                      PopupMenuItem(

                        child: TextButton(onPressed: () { 
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
                    urls.add(doc['postImage'].toString(),);
              });

              print(urls.length.toString());
              

              return Center(
                child:
                Container(
                   width: MediaQuery.of(context).size.width - 26,
              height: urls.length == 1 ?
                      250 : 
                      urls.length == 2 ?
                      210 :
                      urls.length == 3 ?
                      140 : 
                      urls.length >= 4 ?
                      400 : 0,
color: Color.fromARGB(192, 175, 171, 171),
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
                        Icon(
                          IconBroken.Heart,
                          color: Colors.red,
                          size: 20,
                        ),
                        Text(
                          SocialCubit.get(context).likedpost.toString(),
                          style: TextStyle(fontSize: 13),
                        ),
                        textModel(text: ' likes')
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
          )
          :
          Container(
            // padding: EdgeInsets.all(10),
            // child: Center(
            //   child: textModel(text: defaulTextNoPost,),
            // ),
          )
        ),
      );


}









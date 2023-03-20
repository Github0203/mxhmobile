import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/layout/button/buttonanimationRequireAccept.dart';
import 'package:socialapp/layout/button/buttonanimationUnFriend.dart';
import 'package:socialapp/layout/button/buttonanimationCancelReuire.dart';
import 'package:socialapp/layout/socialapp/sociallayout.dart';
import 'package:socialapp/modules/CommentsScreenAlbum.dart';
import 'package:socialapp/modules/feeds/feedDetail.dart';
import 'package:socialapp/modules/new_post/new_post_personal.dart';
import 'package:socialapp/modules/search/searchFriend.dart';

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
import 'package:socialapp/layout/socialapp/cubit/cubit.dart';
import 'package:socialapp/layout/socialapp/sociallayout.dart';
import 'package:socialapp/shared/cubit/cubit.dart';
import 'package:socialapp/shared/cubit/states.dart';

import 'dart:async';
import 'dart:math';

import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:socialapp/shared/styles/themes.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';




Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
      print("onBackgroundMessage: $message");
    }
    


class ProfileScreenFriend extends StatefulWidget {
  SocialUserModel? getuserModelFriend;
  String? userId; 
  
  ProfileScreenFriend({Key? key, this.getuserModelFriend, this.userId}) : super(key: key);

  @override
  State<ProfileScreenFriend> createState() => _ProfileScreenFriendState();
}

class _ProfileScreenFriendState extends State<ProfileScreenFriend> {


  //  @override
  //     void initState() {
  //       super.initState();
    
  //   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  //   FirebaseMessaging.onMessage.listen(
  //     (RemoteMessage message) async {
  //       print("onMessage: $message");
  //   });
  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
  //       print("onMessageOpenedApp: $message");
            
  //               navigateTo(context, SearchFriendPage()); 
  //       //   if (message.data["navigation"] == "/your_route") {
  //       //     int _yourId = int.tryParse(message.data["id"]) ?? 0;
  //       //     navigateTo(context, SearchFriendPage());
  //       // }
  //     });
  //     }
    



  @override
  Widget build(BuildContext context) {
    bool loadingne = false;
     var scaffoldKey = GlobalKey<ScaffoldState>();
     
     print('check da truyen user hay chua');
    //  print(widget.getuserModelFriend!.uId.toString());
     print('check truyen id user bang thong bao');
    //  print(widget.userId!.toString());
     print('check nut add friend');
     print(SocialCubit.get(context).showbuttonAddFriend);

     print('check nut check friend');
     print(SocialCubit.get(context).checkfriend);
     print('check check me');
     print(SocialCubit.get(context).checkme);
    return Builder(
      builder: (context) {
        print('TRƯỚC KHI SET NULL');
        print(widget.userId);
        print('------------------');
        if(widget.getuserModelFriend == null){
         SocialCubit.get(context).getUserDataFriend(widget.userId!);
          widget.getuserModelFriend = SocialCubit.get(context).socialUserModelFriend;
         print('SAU KHI SET NULL');
        // print(widget.getuserModelFriend!.uId);
         
        // Future.delayed(Duration(seconds: 10), () {
        
            SocialCubit.get(context).getPostsFriend(widget.getuserModelFriend!.uId.toString());
        SocialCubit.get(context).checkFollowing(widget.getuserModelFriend!.uId, SocialCubit.get(context).socialUserModel!, DateFormat.jm().format(DateTime.now()),);
         SocialCubit.get(context).checkREQUIREDFRIEND(widget.getuserModelFriend!.uId, SocialCubit.get(context).socialUserModel!, DateFormat.jm().format(DateTime.now()),);
         SocialCubit.get(context).getFollowings(widget.getuserModelFriend!.uId);
         SocialCubit.get(context).getFRIEND(widget.getuserModelFriend!.uId);
        //  });
       
        }
        else{
        SocialCubit.get(context).getUserData(widget.getuserModelFriend!.uId.toString());    
        SocialCubit.get(context).getPostsFriend(widget.getuserModelFriend!.uId.toString());
        SocialCubit.get(context).checkFollowing(widget.getuserModelFriend!.uId, SocialCubit.get(context).socialUserModel!, DateFormat.jm().format(DateTime.now()),);
         SocialCubit.get(context).checkREQUIREDFRIEND(widget.getuserModelFriend!.uId, SocialCubit.get(context).socialUserModel!, DateFormat.jm().format(DateTime.now()),);
         SocialCubit.get(context).getFollowings(widget.getuserModelFriend!.uId);
         SocialCubit.get(context).getFRIEND(widget.getuserModelFriend!.uId);
        }
         

        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context,state){
           
          },
          builder: (context,state)
            {                 
              // SocialUserModel? userModel = SocialCubit.get(context).socialUserModel;
              double setWidth = MediaQuery.of(context).size.width;
              double setheight = MediaQuery.of(context).size.height;
              var socialUserModelMine = SocialCubit.get(context).socialUserModel;
              var profileImage = SocialCubit.get(context).profileImage;
              var coverImage = SocialCubit.get(context).coverImage;
              return ConditionalBuilder(
                 condition: 
                 SocialCubit.get(context).posts1.isNotEmpty &&
                  widget.getuserModelFriend != null,
              builder: (context) =>
               MaterialApp(
                    debugShowCheckedModeBanner: false,
                themeMode:  AppCubit.get(context).isDarkMode ? ThemeMode.dark: ThemeMode.light,
                 home: Scaffold(
                   appBar: defaultAppBarNoPop(
            context: context,
            title: 'Trang cá Nhân',
            actions: [
                
            ],
          ),
         
                   body: SingleChildScrollView(
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
                                                  '${widget.getuserModelFriend!.cover}'),
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
                                          '${widget.getuserModelFriend!.image}'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 5,),
                            Text(
                              '${widget.getuserModelFriend!.name}',
                              style:Theme.of(context).textTheme.bodyText1,
                            ),
                            Text(
                              '${widget.getuserModelFriend!.bio}',
                              style:Theme.of(context).textTheme.caption,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Text(
                                            '100',
                                            style: Theme.of(context).textTheme.subtitle2,
                                          ),
                                          Text(
                                            'Posts',
                                            style: Theme.of(context).textTheme.caption,
                                          ),
                                        ],
                               
                                      ),
                                    ),
                                  ),
                               
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Text(
                                            '265',
                                            style: Theme.of(context).textTheme.subtitle2,
                                          ),
                                          Text(
                                            'Photos',
                                            style: Theme.of(context).textTheme.caption,
                                          ),
                                        ],
                               
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      child: Column(
                                        children: [
                                          Text(
                                            '10K',
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
                                    child: GestureDetector(
                                      child: Column(
                                        children: [
                                          Text(
                                            '103',
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
                                ((SocialCubit.get(context).showbuttonAddFriend == false ))?
                                Expanded(child: buttonanimationRequireFriend(uIdMine: socialUserModelMine!.uId.toString(),getuserModelFriend: widget.getuserModelFriend,),)
                                :
                                Container(),
                                (((SocialCubit.get(context).checkme == false)&& (SocialCubit.get(context).checkfriend ==false)) && (SocialCubit.get(context).accept == 'yes' )) ?
                                Expanded(child: buttonanimationUnFriend(uIdMine: socialUserModelMine!.uId.toString(),getuserModelFriend: widget.getuserModelFriend,),)
                                :
                                Container(),
                                (((SocialCubit.get(context).checkme == false)&& (SocialCubit.get(context).checkfriend ==false)) && (SocialCubit.get(context).checkRequirer == null )) ?
                                Expanded(child: buttonanimationRequireAccept(uIdMine: socialUserModelMine!.uId.toString(),getuserModelFriend: widget.getuserModelFriend,),)
                                :
                                Container(),
                                ((((SocialCubit.get(context).checkme == false)&& (SocialCubit.get(context).checkfriend ==false)) && (SocialCubit.get(context).checkRequirer == 'yes' ))
                                ||
                                (((SocialCubit.get(context).checkme == false)&& (SocialCubit.get(context).checkfriend ==false)) && (SocialCubit.get(context).checkRequirer == null ))
                                 ) ?
                                Expanded(child: buttonanimationCancelRequire(uIdMine: socialUserModelMine!.uId.toString(),getuserModelFriend: widget.getuserModelFriend,),)
                                :
                                Container(),
                                Expanded(child: buttonanimationFollow(uIdMine: socialUserModelMine!.uId.toString(),getuserModelFriend: widget.getuserModelFriend,)),
                              ],
                            ),
                            SizedBox(height: 20,),
                            Column(
                               
                              children: [
                               
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
                                  GestureDetector(
                                    onTap: () {
                                      navigateTo(context,SocialLayout(4));
                                    },
                                    child: CircleAvatar(
                                        radius: 22,
                                        backgroundImage:
                                        NetworkImage(socialUserModelMine.image.toString())),
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
                            itemBuilder: (context, index) => buildPost(SocialCubit.get(context).posts1[index],widget.getuserModelFriend!,context, index,scaffoldKey, SocialCubit.get(context).posts1[index].albumImages),
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
                 ),
               darkTheme: MyTheme.darkTheme ,
            theme: MyTheme.lightTheme,

                //  builder: BotToastInit(),
                //  navigatorObservers: [BotToastNavigatorObserver()],
               ),
              
               fallback: (context) => 
               MaterialApp(
                    debugShowCheckedModeBanner: false,
                themeMode:  AppCubit.get(context).isDarkMode ? ThemeMode.dark: ThemeMode.light,
                 home: Scaffold(
                   appBar: defaultAppBarNoPop(
            context: context,
            title: 'Trang cá Nhân',
            actions: [
                
            ],
          ),
         
                   body: SingleChildScrollView(
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
                                                  '${widget.getuserModelFriend!.cover}'),
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
                                          '${widget.getuserModelFriend!.image}'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 5,),
                            Text(
                              '${widget.getuserModelFriend!.name}',
                              style:Theme.of(context).textTheme.bodyText1,
                            ),
                            Text(
                              '${widget.getuserModelFriend!.bio}',
                              style:Theme.of(context).textTheme.caption,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Text(
                                            '100',
                                            style: Theme.of(context).textTheme.subtitle2,
                                          ),
                                          Text(
                                            'Posts',
                                            style: Theme.of(context).textTheme.caption,
                                          ),
                                        ],
                               
                                      ),
                                    ),
                                  ),
                               
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Text(
                                            '265',
                                            style: Theme.of(context).textTheme.subtitle2,
                                          ),
                                          Text(
                                            'Photos',
                                            style: Theme.of(context).textTheme.caption,
                                          ),
                                        ],
                               
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      child: Column(
                                        children: [
                                          Text(
                                            '10K',
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
                                    child: GestureDetector(
                                      child: Column(
                                        children: [
                                          Text(
                                            '103',
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
                                ((SocialCubit.get(context).showbuttonAddFriend == false ))?
                                Expanded(child: buttonanimationRequireFriend(uIdMine: socialUserModelMine!.uId.toString(),getuserModelFriend: widget.getuserModelFriend,),)
                                :
                                Container(),
                                (((SocialCubit.get(context).checkme == false)&& (SocialCubit.get(context).checkfriend ==false)) && (SocialCubit.get(context).accept == 'yes' )) ?
                                Expanded(child: buttonanimationUnFriend(uIdMine: socialUserModelMine!.uId.toString(),getuserModelFriend: widget.getuserModelFriend,),)
                                :
                                Container(),
                                (((SocialCubit.get(context).checkme == false)&& (SocialCubit.get(context).checkfriend ==false)) && (SocialCubit.get(context).checkRequirer == null )) ?
                                Expanded(child: buttonanimationRequireAccept(uIdMine: socialUserModelMine!.uId.toString(),getuserModelFriend: widget.getuserModelFriend,),)
                                :
                                Container(),
                                ((((SocialCubit.get(context).checkme == false)&& (SocialCubit.get(context).checkfriend ==false)) && (SocialCubit.get(context).checkRequirer == 'yes' ))
                                ||
                                (((SocialCubit.get(context).checkme == false)&& (SocialCubit.get(context).checkfriend ==false)) && (SocialCubit.get(context).checkRequirer == null ))
                                 ) ?
                                Expanded(child: buttonanimationCancelRequire(uIdMine: socialUserModelMine!.uId.toString(),getuserModelFriend: widget.getuserModelFriend,),)
                                :
                                Container(),
                                Expanded(child: buttonanimationFollow(uIdMine: socialUserModelMine!.uId.toString(),getuserModelFriend: widget.getuserModelFriend,)),
                              ],
                            ),
                            SizedBox(height: 20,),
                            Column(
                               
                              children: [
                               
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
                                  GestureDetector(
                                    onTap: () {
                                      navigateTo(context,SocialLayout(4));
                                    },
                                    child: CircleAvatar(
                                        radius: 22,
                                        backgroundImage:
                                        NetworkImage(socialUserModelMine.image.toString())),
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
                               
                              ],
                            ),
                               
                          ],
                        ),
                      ),
                    ),
                 ),
               darkTheme: MyTheme.darkTheme ,
            theme: MyTheme.lightTheme,

                //  builder: BotToastInit(),
                //  navigatorObservers: [BotToastNavigatorObserver()],
               ),
              
              );
            }


        );
      }
    );
  }

   Widget buildPost(PostModel model, SocialUserModel userModel ,context, index,GlobalKey<ScaffoldState> scaffoldKey, List<PostModelSub>? getsubpost) => 
  Column(
    children: [
      // Text(getuserModel!.uId.toString()),
      // // Text(model.uId.toString()),
      widget.getuserModelFriend!.uId.toString() == widget.getuserModelFriend!.uId.toString() ?//getsubpost![index].uId.toString() ?
   
   Card(
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
              model.text != null
                  ? Text(
                      '${model.text}',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    )
                  : Text('${model.text}', style: TextStyle(fontSize: 20)),
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
                      280 : 
                      urls.length == 2 ?
                      210 :
                      urls.length == 3 ?
                      140 : 
                      urls.length >= 4 ?
                      400 : 0,

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
                          liked: true,
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
      )
      :
      // getsubpost![index].uId == null ?
      //  Center(
      //                         child:textModel(
      //                           fontSize: 20,
      //                           text: 'Chưa có bài viết nào'
      //                           )
      //                         )
      // :
      Container(),


    ],
  );
}

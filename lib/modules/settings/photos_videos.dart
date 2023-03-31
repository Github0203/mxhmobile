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
import 'package:socialapp/layout/button/buttonanimationRequireFriend.dart';
import 'package:socialapp/models/social_model/post_model.dart';
import 'package:socialapp/models/social_model/post_model_sub.dart';
import 'package:socialapp/models/social_model/social_user_model.dart';
import 'package:socialapp/modules/CommentsScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialapp/layout/gallery/gallery_view.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:socialapp/modules/albums/loadalbums.dart';
import 'package:socialapp/shared/components/switches.dart';

class Photos_videos extends StatelessWidget {
  String? userName;

  
  Photos_videos(this.userName, {Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    bool loadingne = false;
     var scaffoldKey = GlobalKey<ScaffoldState>();
     double setWidth = MediaQuery.of(context).size.width;
        double setheight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: defaultAppBarNoPop(
          context: context,
          title: 'Album của ' + userName.toString(),
          actions: []),
      body: Builder(
        builder: (context) {
          // SocialCubit.get(context).getPosts();
    
          return BlocConsumer<SocialCubit, SocialStates>(
            listener: (context,state){

            },
            builder: (context,state)
              {                 
             print('00000000000000000000000000000000000000000');
             print(SocialCubit.get(context).posts3.toString());
                return ConditionalBuilder(
                   condition: SocialCubit.get(context).posts3.isNotEmpty &&
                    SocialCubit.get(context).getsocialUserModelFriend != null,
                builder: (context) =>
                 SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                         LoadAlbums(),
                        ],
                      ),
                    ),
                  ),
                 fallback: (context) => 
                 Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(child: textModel(text: 'Chưa có Album nào')),
                      SizedBox(height: 10),
                      Container(
                        width: setWidth*0.3,
                        child: OutlinedButton(
                                    child:Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const <Widget>[
                                        Icon(IconBroken.Image, color: Colors.blueAccent,),
                                      SizedBox(
                                        width: 5,
                                      ),
                                         Text('Add Photos',style: TextStyle(color: Colors.blue),),
                                      ],
                                    ) , onPressed: (){
                                    SocialCubit.get(context).paths = null;
                                    SocialCubit.get(context).editsubpostTempWhenCreatePost = null;
                                      navigateTo(context, NewPostPersonalScreen());
                                    },
                                    style:OutlinedButton.styleFrom(primary: Colors.grey)
                                  ),
                      ),                      // TextButton.icon(onPressed: onPressed, icon: (icon), label: label)
                    ],
                  ),
                 )
                );
              }
    
    
          );        }
      ),
    );
  }


 
}

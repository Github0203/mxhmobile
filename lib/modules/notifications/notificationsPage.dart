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
import 'package:socialapp/modules/notifications/loadnotifications.dart';
import 'package:socialapp/shared/components/switches.dart';
import 'searchNotification.dart';

class notificationsPage extends StatelessWidget {


  
  const notificationsPage( {Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    bool loadingne = false;
     var scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      appBar: defaultAppBarNoPop(
          context: context,
          title: 'Notification',
          actions: [
            TextButton(onPressed: (
              
            ) {
              navigateTo(context, searchNotification());
            }, child: Text('View all'))
          ]),
      body: Builder(
        builder: (context) {
          SocialCubit.get(context).getNotificationwithSeenisNo(SocialCubit.get(context).socialUserModel!.uId.toString());
    
          return BlocConsumer<SocialCubit, SocialStates>(
            listener: (context,state){

            },
            builder: (context,state)
              {                 
                // SocialUserModel? userModel = SocialCubit.get(context).socialUserModel;
                double setWidth = MediaQuery.of(context).size.width;
                double setheight = MediaQuery.of(context).size.height;
                var socialUserModel = SocialCubit.get(context).socialUserModel;
                var profileImage = SocialCubit.get(context).profileImage;
                var coverImage = SocialCubit.get(context).coverImage;
                return 
                ConditionalBuilder(
                   condition: SocialCubit.get(context).listNotificationSeenno!.isNotEmpty &&
                    SocialCubit.get(context).socialUserModel != null,
                builder: (context) =>
                 SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                         LoadNotifications(),
                        ],
                      ),
                    ),
                  ),
                 fallback: (context) => 
                 Column(
                   children: [
                     Container(
                      child: Center(child: LoadNotifications()),
                     ),
                   ],
                 )
                );
              }
    
    
          );
        }
      ),
    );
  }


 
}

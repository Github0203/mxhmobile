import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/layout/socialapp/sociallayout.dart';
import 'package:socialapp/models/social_model/NotificationModel.dart';
import 'package:socialapp/modules/feeds/feedDetail.dart';
import 'package:socialapp/modules/new_post/new_post_album.dart';
import 'package:socialapp/modules/settings/Profile_screen_friend.dart';

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

class LoadNotificationsAll extends StatelessWidget {


  
  const LoadNotificationsAll( {Key? key}) : super(key: key);


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
              navigateTo(context, LoadNotificationsAll());
            }, child: Text('View all'))
          ]),
      body: Builder(
        builder: (context) {
          SocialCubit.get(context).getNotificationAll(SocialCubit.get(context).socialUserModel!.uId.toString());
    
          return BlocConsumer<SocialCubit, SocialStates>(
            listener: (context,state){

            },
            builder: (context,state)
              {                 
                double setWidth = MediaQuery.of(context).size.width;
        double setheight = MediaQuery.of(context).size.height;
        List<NotificationModel>? reversedLissAll = SocialCubit.get(context).listNotification!.reversed.toList();
                return ConditionalBuilder(
                   condition: SocialCubit.get(context).listNotification!.isNotEmpty &&
                    SocialCubit.get(context).socialUserModel != null,
                builder: (context) =>
                 SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Container(
                                height: setheight * 0.7,
                                width: setWidth - 20,
                                //  color: Colors.red,
                                child: ListView.separated(
                                  // reverse: true,
                                  itemBuilder: (context, index1) => 
                                  Container(
                                    margin: EdgeInsets.all(5),
                                    child: PhysicalModel(
                                      color:
                                      reversedLissAll[index1].seen == 'no' ?
                                      Color.fromARGB(255, 25, 228, 255)
                                      :
                                          Color.fromARGB(255, 233, 233, 233),
                                       
                                      elevation: 8,
                                      shadowColor:
                                          Color.fromARGB(255, 143, 139, 139),
                                      borderRadius: BorderRadius.circular(20),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20.0),
                                        child: ListTile(
                                          onTap:() {
                                            SocialCubit.get(context).updateNotificationItem(reversedLissAll[index1].uIdReciver.toString(), reversedLissAll[index1].iDNotification.toString());
          
                                            ((reversedLissAll[index1].type == '1') || (reversedLissAll[index1].type == '2')) ?
                                            navigateTo(context, ProfileScreenFriend(userId: reversedLissAll[index1].uIdSender.toString()))
                                            :
                                            ''
                                            ;
                                          },
                                          leading: Container(
                                            height: 50,
                                            width: 40,
                                            child: CircleAvatar(
                                                radius: 25,
                                                backgroundImage: NetworkImage(
                                                    SocialCubit.get(context)
                                                        .listNotification![
                                                            index1]
                                                        .image
                                                        .toString())),
                                          ),
                                          title: 
                                          Transform.translate(
                                            offset: Offset(0, 0),
                                            child: Text(SocialCubit.get(context)
                                                .listNotification![index1]
                                                .title
                                                .toString(),
                                                style: TextStyle(
                                                  color:
                                                  reversedLissAll[index1].seen == 'no' ?
                                                   Color.fromARGB(255, 255, 255, 255)
                                                  :
                                                  Color.fromARGB(255, 121, 121, 121)
                                                  ),
                                                ),
                                          ),
                                          subtitle: Text(reversedLissAll[index1].body.toString(),
                                          style: TextStyle(fontWeight: FontWeight.w800),
                                          ),
                                          trailing: Column(
                                            children: [
                                              Text(
                                                reversedLissAll[index1].time.toString(),
                                              style: TextStyle(
                                                      fontWeight: FontWeight.w800,
                                                      color:
                                                      reversedLissAll[index1].seen == 'no' ?
                                                       Color.fromARGB(255, 255, 255, 255)
                                                      :
                                                      Color.fromARGB(255, 121, 121, 121)
                                                      ),
                                              ),
                                              Text(
                                                reversedLissAll[index1].date.toString(),
                                              style: TextStyle(
                                                      // fontWeight: FontWeight.w800,
                                                      color:
                                                      reversedLissAll[index1].seen == 'no' ?
                                                       Color.fromARGB(255, 255, 255, 255)
                                                      :
                                                      Color.fromARGB(255, 121, 121, 121)
                                                      ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  separatorBuilder: (context, index1) => SizedBox(
                                    height: 5,
                                  ),
                                  itemCount: (SocialCubit.get(context)
                                      .listNotification!
                                      .length),
                                )),
                            
                        ],
                      ),
                    ),
                  ),
                 fallback: (context) => 
                 Column(
                   children: [
                    SizedBox(height: 20,),
                     Container(
                      child: Center(child: CircularProgressIndicator()),
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

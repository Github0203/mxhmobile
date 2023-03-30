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
import 'package:socialapp/layout/button/buttonanimationRequireFriend.dart';
import 'package:socialapp/models/social_model/post_model.dart';
import 'package:socialapp/models/social_model/post_model_sub.dart';
import 'package:socialapp/models/social_model/social_user_model.dart';
import 'package:socialapp/modules/CommentsScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialapp/layout/gallery/gallery_view.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:slide_switcher/slide_switcher.dart';
import 'package:socialapp/modules/albums/albulmModouls/Grid_Group.dart';
import 'package:socialapp/modules/albums/albulmModouls/Grid_Group_Video.dart';
import 'package:intl/intl.dart';

class LoadNotifications extends StatefulWidget {
  List<PostModelSub>? getlistpostmodelsub;

  LoadNotifications({this.getlistpostmodelsub, Key? key}) : super(key: key);

  @override
  State<LoadNotifications> createState() => _LoadNotificationsState();
}

class _LoadNotificationsState extends State<LoadNotifications> {
  int? switcherIndex = 0;

  @override
  Widget build(BuildContext context) {
    bool loadingne = false;
    var scaffoldKey = GlobalKey<ScaffoldState>();
    return Builder(builder: (context) {
      Future.delayed(Duration(seconds: 1), () {
        SocialCubit.get(context).getNotificationwithSeenisNo(
            SocialCubit.get(context).socialUserModel!.uId.toString());
        SocialCubit.get(context).getNotificationwithSeenisYes(
            SocialCubit.get(context).socialUserModel!.uId.toString());
      });

      return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {
        //           if (state is SocialCreatePostSuccessState){
        // showToast(text: "Đã thêm bài viết thành công", state: ToastStates.SUCCESS);
        //             loadingne = true;
        //             }
        //             if (state is SocialCreatePostErrorState){
        // showToast(text: "Thêm bài viết thất bại", state: ToastStates.ERROR);
        //             }
      }, builder: (context, state) {
        // SocialUserModel? userModel = SocialCubit.get(context).socialUserModel;
        double setWidth = MediaQuery.of(context).size.width;
        double setheight = MediaQuery.of(context).size.height;
        List<NotificationModel>? reversedListSeenno = SocialCubit.get(context).listNotificationSeenno!.reversed.toList();
        List<NotificationModel>? reversedListSeenyes = SocialCubit.get(context).listNotificationSeenyes!.reversed.toList();
        return ConditionalBuilder(
          condition:
              SocialCubit.get(context).listNotificationSeenno!.isNotEmpty &&
                  SocialCubit.get(context).socialUserModel != null,
          builder: (context) => 
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                child: Column(children: [
                  Center(
                    child: SlideSwitcher(
                      children: [
                        Text(
                          'Not seen',
                          style: TextStyle(
                              fontSize: 15,
                              color: switcherIndex == 0
                                  ? Colors.white.withOpacity(0.9)
                                  : Colors.grey),
                        ),
                        Text(
                          'Seen',
                          style: TextStyle(
                              fontSize: 15,
                              color: switcherIndex == 1
                                  ? Colors.white.withOpacity(0.9)
                                  : Colors.grey),
                        ),
                      ],
                      onSelect: (int index) => {
                        setState(() => switcherIndex = index),
                        SocialCubit.get(context).getAllVideos(SocialCubit.get(context).getsocialUserModelFriend!.uId.toString()),
                        // SocialCubit.get(context).getAllimgne(),
                      },
                      containerColor: Colors.transparent,
                      containerBorder:
                          Border.all(color: Color.fromARGB(255, 3, 119, 165)),
                      slidersGradients: const [
                        LinearGradient(
                          colors: [
                            Color.fromRGBO(47, 105, 255, 1),
                            Color.fromRGBO(188, 47, 255, 1),
                          ],
                        ),
                        LinearGradient(
                          colors: [
                            Color.fromRGBO(47, 105, 255, 1),
                            Color.fromRGBO(0, 192, 169, 1),
                          ],
                        ),
                        // LinearGradient(
                        //   colors: [
                        //     Color.fromRGBO(255, 105, 105, 1),
                        //     Color.fromRGBO(255, 62, 62, 1),
                        //   ],
                        // ),
                      ],
                      indents: 1,
                      containerHeight: 50,
                      containerWight: 315,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SingleChildScrollView(
                      child: switcherIndex == 0
                          ? 
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
                                    reversedListSeenno[index1].seen == 'no' ?
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
                                          SocialCubit.get(context).updateNotificationItem(reversedListSeenno[index1].uIdReciver.toString(), reversedListSeenno[index1].iDNotification.toString());

                                          ((reversedListSeenno[index1].type == '1') || (reversedListSeenno[index1].type == '2')) ?
                                          navigateTo(context, ProfileScreenFriend(userId: reversedListSeenno[index1].uIdSender.toString()))
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
                                                      .listNotificationSeenno![
                                                          index1]
                                                      .image
                                                      .toString())),
                                        ),
                                        title: 
                                        Transform.translate(
                                          offset: Offset(0, 0),
                                          child: Text(SocialCubit.get(context)
                                              .listNotificationSeenno![index1]
                                              .title
                                              .toString(),
                                              style: TextStyle(
                                                color:
                                                reversedListSeenno[index1].seen == 'no' ?
                                                 Color.fromARGB(255, 255, 255, 255)
                                                :
                                                Color.fromARGB(255, 121, 121, 121)
                                                ),
                                              ),
                                        ),
                                        subtitle: Text(reversedListSeenno[index1].body.toString(),
                                        style: TextStyle(fontWeight: FontWeight.w800),
                                        ),
                                        trailing: Column(
                                          children: [
                                            Text(
                                              reversedListSeenno[index1].time.toString(),
                                            style: TextStyle(
                                                    fontWeight: FontWeight.w800,
                                                    color:
                                                    reversedListSeenno[index1].seen == 'no' ?
                                                     Color.fromARGB(255, 255, 255, 255)
                                                    :
                                                    Color.fromARGB(255, 121, 121, 121)
                                                    ),
                                            ),
                                            Text(
                                              reversedListSeenno[index1].date.toString(),
                                            style: TextStyle(
                                                    // fontWeight: FontWeight.w800,
                                                    color:
                                                    reversedListSeenno[index1].seen == 'no' ?
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
                                    .listNotificationSeenno!
                                    .length),
                              ))
                          
                          : 
                          Container(
                              height: setheight * 0.7,
                              width: setWidth - 20,
                              //  color: Colors.red,
                              child: ListView.separated(
                                // reverse: true,
                                itemBuilder: (context, index2) => 
                                Container(
                                  margin: EdgeInsets.all(5),
                                  child: PhysicalModel(
                                    color:
                                    reversedListSeenyes[index2].seen == 'no' ?
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
                                          // SocialCubit.get(context).updateNotificationItem(reversedListSeenyes[index1].uIdReciver.toString(), reversedListSeenyes[index1].iDNotification.toString());

                                          ((reversedListSeenyes[index2].type == '1') || (reversedListSeenyes[index2].type == '2')) ?
                                          navigateTo(context, ProfileScreenFriend(userId: reversedListSeenyes[index2].uIdSender.toString()))
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
                                                      .listNotificationSeenyes![
                                                          index2]
                                                      .image
                                                      .toString())),
                                        ),
                                        title: 
                                        Transform.translate(
                                          offset: Offset(0, 0),
                                          child: Text(SocialCubit.get(context)
                                              .listNotificationSeenyes![index2]
                                              .title
                                              .toString(),
                                              style: TextStyle(
                                                color:
                                                reversedListSeenyes[index2].seen == 'no' ?
                                                 Color.fromARGB(255, 255, 255, 255)
                                                :
                                                Color.fromARGB(255, 121, 121, 121)
                                                ),
                                              ),
                                        ),
                                        subtitle: Row(
                                          children: [
                                            Text(reversedListSeenyes[index2].body.toString(),
                                            style: TextStyle(fontWeight: FontWeight.w800),
                                            ),
                                          ],
                                        ),
                                        trailing: Column(
                                          children: [
                                            Text(
                                              reversedListSeenyes[index2].time.toString(),
                                            style: TextStyle(
                                                    fontWeight: FontWeight.w800,
                                                    color:
                                                    reversedListSeenyes[index2].seen == 'no' ?
                                                     Color.fromARGB(255, 255, 255, 255)
                                                    :
                                                    Color.fromARGB(255, 121, 121, 121)
                                                    ),
                                            ),
                                            Text(
                                              reversedListSeenyes[index2].date.toString(),
                                            style: TextStyle(
                                                    // fontWeight: FontWeight.w800,
                                                    color:
                                                    reversedListSeenyes[index2].seen == 'no' ?
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
                                    .listNotificationSeenyes!
                                    .length),
                              )
                              ),
                            ),
                ]),
              ),
            ),
          ),
          fallback: (context) => Column(
            children: [
              SizedBox(height: 20,),
              Center(
                child: Text('No have notification'),
              ),
              SizedBox(height: 20,),
              Container(
                width: 200,
                child: OutlinedButton(
                        onPressed: (){
                          setState(() {});
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                Icon(Icons.restart_alt_outlined),
                SizedBox(width:10),
                Text('Refesh page'),
                          ],
                        ),
                          ),
              ),
            ],
          ),
        );
      });
    });
  }
}

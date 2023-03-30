import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/layout/socialapp/sociallayout.dart';
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
import 'package:search_app_bar_page/search_app_bar_page.dart';
import 'package:socialapp/models/social_model/social_user_model.dart';


class searchNotification extends StatefulWidget {
  
  searchNotification({Key? key}) : super(key: key);

  @override
  State<searchNotification> createState() => _searchNotificationState();
}

class _searchNotificationState extends State<searchNotification> {
  String namesearch = "";

  // @override
  // void initState() {
  //   super.initState();
  //   // imageList = Utils.getImageData();
  //   // super.dispose();

  // }

  @override
  Widget build(BuildContext context) {
    bool loadingne = false;
     var scaffoldKey = GlobalKey<ScaffoldState>();
     Stream streamQuery;
    return Builder(
      builder: (context) {
         SocialCubit.get(context).getNotificationAll(SocialCubit.get(context).socialUserModel!.uId.toString());

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
                 condition: SocialCubit.get(context).listNotification!.isNotEmpty != null,
              builder: (context) =>
        Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Card(
          child: TextField(
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.search), hintText: 'Search...'),
            onChanged: (val) {
              setState(() {
                namesearch = val;
                //  streamQuery = FirebaseFirestore.instance.collection('queryable')
                //         .where('fieldName', isGreaterThanOrEqualTo: name)
                //         .where('fieldName', isLessThan: name +'z')
                //         .snapshots();
              });
            },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: 
    //       (namesearch != "")
    //           ? FirebaseFirestore.instance
    //               .collection('users')
    //               .where('queryable', isGreaterThanOrEqualTo: namesearch,
    // isLessThan: namesearch + 'z')
    //               .snapshots()
              // : 
              FirebaseFirestore.instance.collection("users").doc(SocialCubit.get(context).socialUserModel!.uId).collection('notifications').snapshots(),
          builder: (context, snapshot) {
            return (snapshot.connectionState == ConnectionState.waiting)
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                  child: Container(
                  width: setWidth-20,
                  height: setheight *0.8,
                    child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot data = snapshot.data!.docs[index];
                          
                          return 
                          data['name'].contains(namesearch) ?
                          Column(
                            children: [
                             Container(
                                    margin: EdgeInsets.all(5),
                                    child: PhysicalModel(
                                      color:
                                      data['seen'] == 'no' ?
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
                                            SocialCubit.get(context).updateNotificationItem(data['uIdReciver'], data['iDNotification']);
          
                                            ((data['type'] == '1') || ((data['type'] == '2'))) ?
                                            navigateTo(context, ProfileScreenFriend(userId: (data['uIdSender'])))
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
                                                  data['image'])),
                                          ),
                                          title: 
                                          Transform.translate(
                                            offset: Offset(0, 0),
                                            child: Text(
                                              data['title'],
                                                style: TextStyle(
                                                  color:
                                                  data['seen'] == 'no' ?
                                                   Color.fromARGB(255, 255, 255, 255)
                                                  :
                                                  Color.fromARGB(255, 121, 121, 121)
                                                  ),
                                                ),
                                          ),
                                          subtitle: Text(
                                            data['body'],
                                          style: TextStyle(fontWeight: FontWeight.w800),
                                          ),
                                          trailing: Column(
                                            children: [
                                              Text(
                                                data['time'],
                                              style: TextStyle(
                                                      fontWeight: FontWeight.w800,
                                                      color:
                                                      data['seen'] == 'no' ?
                                                       Color.fromARGB(255, 255, 255, 255)
                                                      :
                                                      Color.fromARGB(255, 121, 121, 121)
                                                      ),
                                              ),
                                              Text(
                                                data['date'],
                                              style: TextStyle(
                                                      // fontWeight: FontWeight.w800,
                                                      color:
                                                      data['seen'] == 'no'?
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
                                  
                                  SizedBox(height: 10,)
                            ],
                          )
                          :
                          // Center(child: Text('No math any user'));
                          Container();
                        },
                      ),
                  ),
                );
          },
        ),
      ),
    ),
               fallback: (context) => 
              Column(
                children: [
                  SizedBox(height: 20,),
                  textModel(text: 'No have more notificatiton any')
                ],
              ),
              
              );
            }


        );
      }
    );
  }



}



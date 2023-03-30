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


class SearchFriendPage extends StatefulWidget {
  
  SearchFriendPage({Key? key}) : super(key: key);

  @override
  State<SearchFriendPage> createState() => _SearchFriendPageState();
}

class _SearchFriendPageState extends State<SearchFriendPage> {
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
        //  SocialCubit.get(context).getAllUsersFriend(SocialCubit.get(context).socialUserModel!.uId.toString());

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
                 condition: SocialCubit.get(context).usersfriend.isNotEmpty != null,
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
              FirebaseFirestore.instance.collection("users").snapshots(),
          builder: (context, snapshot) {
            return (snapshot.connectionState == ConnectionState.waiting)
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                  child: Container(
                  width: setWidth-20,
                  height: setheight *0.8,
                    child: ListView.builder(
                        itemCount: namesearch == '' ? 0 : snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot data = snapshot.data!.docs[index];
                          
                          return 
                          data['queryable'].contains(namesearch) ?
                          Column(
                            children: [
                              GestureDetector(
                                onTap: (){
          navigateTo(context, ProfileScreenFriend(  
            userId: data['uId']
          ));
        },
                                child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      CircleAvatar(
                                                          radius: 25, backgroundImage: NetworkImage(
                                                            // '${comment.image}'
                                                            data['image'],
                                                            )),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(data['name'],),
                                      ],
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
              Container(),
              
              );
            }


        );
      }
    );
  }



}



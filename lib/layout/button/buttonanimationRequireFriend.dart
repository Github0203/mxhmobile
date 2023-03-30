import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:socialapp/layout/socialapp/cubit/cubit.dart';
import 'package:socialapp/models/social_model/social_user_model.dart';
import 'package:easy_localization/easy_localization.dart';


class buttonanimationRequireFriend extends StatefulWidget {
  String? uIdMine;
   SocialUserModel? getuserModelFriend;
  
  buttonanimationRequireFriend({Key? key, this.uIdMine, this.getuserModelFriend}) : super(key: key);
 


  @override
  _buttonanimationRequireFriendState createState() => _buttonanimationRequireFriendState();
}

class _buttonanimationRequireFriendState extends State<buttonanimationRequireFriend> {
  ButtonState stateOnlyText = ButtonState.idle;
  ButtonState stateOnlyCustomIndicatorText = ButtonState.idle;
  ButtonState stateTextWithIconFollow = ButtonState.idle;
  ButtonState stateTextWithIconFollowing = ButtonState.fail;
  ButtonState stateTextWithIconMinWidthState = ButtonState.idle;

  


  Widget buildTextWithIcon() {
    return ProgressButton.icon(
      iconedButtons: {


      ButtonState.idle: IconedButton(
          text: 
          'Add Friend',
          icon: Icon(Icons.add, color: Colors.white),
          color:  Colors.deepPurple.shade500,
           ),


      ButtonState.loading:
          IconedButton(text: "Loading", color: Colors.deepPurple.shade700),

          
      ButtonState.fail: IconedButton(
          text:"Following1",
          
          icon: Icon(Icons.follow_the_signs_outlined, color: Colors.white),
          color:  Colors.green.shade500,
           ),
      ButtonState.success: IconedButton(
          text: "Success",
          icon: Icon(
            Icons.check_circle,
            color: Colors.white,
          ),
          color: Colors.green.shade400)
    }, onPressed: onPressedIconWithText, state: stateTextWithIconFollow);
  }



  @override
  Widget build(BuildContext context) {
    return 
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buildTextWithIcon(),
          ],
        ),
    );
  }

  

  void onPressedIconWithText() async {
    switch (stateTextWithIconFollow) {
      case ButtonState.idle:
        //  stateTextWithIconFollow = ButtonState.loading;
        Future.delayed(Duration(seconds: 1), () {
          // SocialCubit.get(context).getUserDataFriend(widget.uIdMine!);
          // stateTextWithIconFollow = ButtonState.loading;
           SocialCubit.get(context).AddFRIEND(userModelFriend: widget.getuserModelFriend, dateTime: DateFormat.jm().format(DateTime.now()),);
        });

        break;
      case ButtonState.fail:
        break;
      case ButtonState.loading:
        // TODO: Handle this case.
        break;
      case ButtonState.success:
        // TODO: Handle this case.
        break;
    }
    SocialCubit.get(context).AddNotification(
      uIdReciver: widget.getuserModelFriend!.uId,
      uIdSender: widget.uIdMine!,
      image: SocialCubit.get(context).socialUserModel!.image.toString(),
      title: 'You have 1 friend request from',
      body: SocialCubit.get(context).socialUserModel!.name.toString(),
      type: '1',
      seen: 'no',
      display: 'yes'
      );
   SocialCubit.get(context).sendPushMessageFriendRequire(widget.getuserModelFriend!.token.toString(), 'You have 1 friend request from',SocialCubit.get(context).socialUserModel!.name.toString(), SocialCubit.get(context).socialUserModel!.uId) ;
    // setState(() {
    //   if(SocialCubit.get(context).checkfriend == true) {
    //   stateTextWithIconFollowing = stateTextWithIconFollow;
    //   }
    //   else{
    //     stateTextWithIconFollow = stateTextWithIconFollowing;
    //   }
    // });
  }

}
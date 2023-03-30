import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:socialapp/layout/socialapp/cubit/cubit.dart';
import 'package:socialapp/models/social_model/social_user_model.dart';
import 'package:easy_localization/easy_localization.dart';


class buttonanimationFollow extends StatefulWidget {
  String? uIdMine;
   SocialUserModel? getuserModelFriend;
  
  buttonanimationFollow({Key? key, this.uIdMine, this.getuserModelFriend}) : super(key: key);
 


  @override
  _buttonanimationFollowState createState() => _buttonanimationFollowState();
}

class _buttonanimationFollowState extends State<buttonanimationFollow> {
  ButtonState stateOnlyText = ButtonState.idle;
  ButtonState stateOnlyCustomIndicatorText = ButtonState.idle;
  ButtonState stateTextWithIconFollow = ButtonState.idle;
  ButtonState stateTextWithIconFollowing = ButtonState.fail;
  ButtonState stateTextWithIconMinWidthState = ButtonState.idle;

  


  Widget buildTextWithIcon() {
    return ProgressButton.icon(
      iconedButtons: {


      ButtonState.idle: IconedButton(
          text: "Flollow",
          icon: Icon(Icons.follow_the_signs_outlined, color: Colors.white),
          color: Colors.deepPurple.shade500,
           ),


      ButtonState.loading:
          IconedButton(text: "Loading", color: Colors.deepPurple.shade700),

          
      ButtonState.fail: IconedButton(
          text: SocialCubit.get(context).checkfollow == true ? "Flollow1" : "Following1",
          
          icon: Icon(Icons.follow_the_signs_outlined, color: Colors.white),
          color: SocialCubit.get(context).checkfollow == true ? Colors.deepPurple.shade500 : Colors.green.shade500,
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
          stateTextWithIconFollow = ButtonState.loading;
           print('kiem tra check folloew theo doi');
          print(SocialCubit.get(context).checkfollow);
          print('ggg');
       
            SocialCubit.get(context).Addfollower(userModelFriend: widget.getuserModelFriend!, );
      
          setState(() {
            // if(SocialCubit.get(context).checkfollow == false) {
            //   // SocialCubit.get(context).unFollowing(widget.getuserModelFriend!.uId, SocialCubit.get(context).getIDFollow.toString());
            //   stateTextWithIconFollow = ButtonState.idle;
            // }
            // if(SocialCubit.get(context).checkfollow == true) {
            //   // SocialCubit.get(context).Addfollower(userModelFriend: widget.getuserModelFriend!, dateTime: DateFormat.jm().format(DateTime.now()),);
            //   stateTextWithIconFollow = ButtonState.idle;
            // }
            // ;
          }
          );
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
      title: SocialCubit.get(context).socialUserModel!.name.toString(),
      body: ' followed you.',
      type: '2',
      seen: 'no',
      display: 'yes'
      );
      SocialCubit.get(context).sendPushMessageFriendRequire(widget.getuserModelFriend!.token.toString(), ' followed you.',SocialCubit.get(context).socialUserModel!.name.toString(), SocialCubit.get(context).socialUserModel!.uId) ;
  }

}
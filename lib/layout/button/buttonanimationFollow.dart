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
          text: SocialCubit.get(context).checkfollow == false ? "Following" : "Flollow",
          icon: Icon(Icons.follow_the_signs_outlined, color: Colors.white),
          color: SocialCubit.get(context).checkfollow == false ? Colors.green.shade500 : Colors.deepPurple.shade500,
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
          if(SocialCubit.get(context).checkfollow == true)
          {
            SocialCubit.get(context).Addfollower(userModelFriend: widget.getuserModelFriend!, dateTime: DateFormat.jm().format(DateTime.now()),);
          }
          else
          {
                SocialCubit.get(context).unFollowing(widget.getuserModelFriend!.uId, SocialCubit.get(context).getIDFollow.toString());
          }
          setState(() {
            if(SocialCubit.get(context).checkfollow == false) {
              // SocialCubit.get(context).unFollowing(widget.getuserModelFriend!.uId, SocialCubit.get(context).getIDFollow.toString());
              stateTextWithIconFollow = ButtonState.idle;
            }
            if(SocialCubit.get(context).checkfollow == true) {
              // SocialCubit.get(context).Addfollower(userModelFriend: widget.getuserModelFriend!, dateTime: DateFormat.jm().format(DateTime.now()),);
              stateTextWithIconFollow = ButtonState.idle;
            }
            ;
            // SocialCubit.get(context).Addfollower(uId: widget.getuserModel!.uId.toString(), userModel: widget.getuserModel!, dateTime: DateFormat.jm().format(DateTime.now()),);
            // stateTextWithIcon = Random.secure().nextBool()
            //     ? ButtonState.success
            //     : 
            //     ButtonState.fail;
          }
          );
        });

        break;
      case ButtonState.fail:
        //   stateTextWithIconFollow = ButtonState.loading; 
        // Future.delayed(Duration(seconds: 1), () {
        //   SocialCubit.get(context).checkFollowing(widget.uIdMine, widget.getuserModelFriend!, DateFormat.jm().format(DateTime.now()),);
        //   print('kiem tra check folloew huy theo doi');
        //   print(SocialCubit.get(context).checkfollow);
        //   if(SocialCubit.get(context).checkfollow == true)
        //   {
        //     SocialCubit.get(context).Addfollower(userModelFriend: widget.getuserModelFriend!, dateTime: DateFormat.jm().format(DateTime.now()),);
        //   }
        //   else
        //   {
        //         SocialCubit.get(context).unFollowing(widget.getuserModelFriend!.uId, SocialCubit.get(context).getIDFollow.toString());
        //   }
        //   setState(() {
        //     if(SocialCubit.get(context).checkfollow == true) {
        //       // SocialCubit.get(context).unFollowing(widget.getuserModelFriend!.uId, SocialCubit.get(context).getIDFollow.toString());
        //       stateTextWithIconFollow = ButtonState.fail;
        //     }
        //     if(SocialCubit.get(context).checkfollow == false) {
        //       // SocialCubit.get(context).Addfollower(userModelFriend: widget.getuserModelFriend!, dateTime: DateFormat.jm().format(DateTime.now()),);
        //       stateTextWithIconFollow = ButtonState.idle;
        //     }

        //     // stateTextWithIconFollow = ButtonState.idle;
        //     // SocialCubit.get(context).Addfollower(uId: widget.getuserModel!.uId.toString(), userModel: widget.getuserModel!, dateTime: DateFormat.jm().format(DateTime.now()),);
        //     // stateTextWithIcon = Random.secure().nextBool()
        //     //     ? ButtonState.success
        //     //     : 
        //     //     ButtonState.fail;
        //   }
        //   );
        // });
        break;
      case ButtonState.loading:
        // TODO: Handle this case.
        break;
      case ButtonState.success:
        // TODO: Handle this case.
        break;
    }
    // setState(() {
    //   if(SocialCubit.get(context).checkfollow == true) {
    //   stateTextWithIconFollowing = stateTextWithIconFollow;
    //   }
    //   else{
    //     stateTextWithIconFollow = stateTextWithIconFollowing;
    //   }
    // });
  }

}
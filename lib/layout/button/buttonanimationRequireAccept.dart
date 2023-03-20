import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:socialapp/layout/socialapp/cubit/cubit.dart';
import 'package:socialapp/models/social_model/social_user_model.dart';
import 'package:easy_localization/easy_localization.dart';


class buttonanimationRequireAccept extends StatefulWidget {
  String? uIdMine;
   SocialUserModel? getuserModelFriend;
  
  buttonanimationRequireAccept({Key? key, this.uIdMine, this.getuserModelFriend}) : super(key: key);
 


  @override
  _buttonanimationRequireAcceptState createState() => _buttonanimationRequireAcceptState();
}

class _buttonanimationRequireAcceptState extends State<buttonanimationRequireAccept> {
  ButtonState stateOnlyText = ButtonState.idle;
  ButtonState stateOnlyCustomIndicatorText = ButtonState.idle;
  ButtonState stateTextWithIconFollow = ButtonState.idle;
  ButtonState stateTextWithIconFollowing = ButtonState.fail;
  ButtonState stateTextWithIconMinWidthState = ButtonState.idle;

  


  Widget buildTextWithIcon() {
    return ProgressButton.icon(
      iconedButtons: {


      ButtonState.idle: IconedButton(
          text: 'Accept',
          icon: Icon(Icons.add, color: Colors.white),
          color:  Color.fromARGB(255, 177, 204, 25) ,
           ),


      ButtonState.loading:
          IconedButton(text: "Loading", color: Colors.deepPurple.shade700),

          
      ButtonState.fail: IconedButton(
          text: SocialCubit.get(context).checkfriend == true ? "Flollow1" : "Following1",
          
          icon: Icon(Icons.follow_the_signs_outlined, color: Colors.white),
          color: SocialCubit.get(context).checkfriend == true ? Colors.deepPurple.shade500 : Colors.green.shade500,
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
          // stateTextWithIconFollow = ButtonState.loading;
          SocialCubit.get(context).acceptFRIEND(widget.getuserModelFriend!.uId);
       
        });

        break;
      case ButtonState.fail:
        //   stateTextWithIconFollow = ButtonState.loading; 
        // Future.delayed(Duration(seconds: 1), () {
        //   SocialCubit.get(context).checkfriending(widget.uIdMine, widget.getuserModelFriend!, DateFormat.jm().format(DateTime.now()),);
        //   print('kiem tra check folloew huy theo doi');
        //   print(SocialCubit.get(context).checkfriend);
        //   if(SocialCubit.get(context).checkfriend == true)
        //   {
        //     SocialCubit.get(context).Addfollower(userModelFriend: widget.getuserModelFriend!, dateTime: DateFormat.jm().format(DateTime.now()),);
        //   }
        //   else
        //   {
        //         SocialCubit.get(context).unFollowing(widget.getuserModelFriend!.uId, SocialCubit.get(context).getIDFollow.toString());
        //   }
        //   setState(() {
        //     if(SocialCubit.get(context).checkfriend == true) {
        //       // SocialCubit.get(context).unFollowing(widget.getuserModelFriend!.uId, SocialCubit.get(context).getIDFollow.toString());
        //       stateTextWithIconFollow = ButtonState.fail;
        //     }
        //     if(SocialCubit.get(context).checkfriend == false) {
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
    SocialCubit.get(context).sendPushMessageFriendRequire(widget.getuserModelFriend!.token.toString(), 'title1','body', SocialCubit.get(context).socialUserModel!.uId) ;
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
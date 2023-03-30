import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:socialapp/layout/socialapp/cubit/cubit.dart';
import 'package:socialapp/models/social_model/social_user_model.dart';
import 'package:easy_localization/easy_localization.dart';


class buttonanimationCancelRequire extends StatefulWidget {
  String? uIdMine;
   SocialUserModel? getuserModelFriend;
  
  buttonanimationCancelRequire({Key? key, this.uIdMine, this.getuserModelFriend}) : super(key: key);
 


  @override
  _buttonanimationCancelRequireState createState() => _buttonanimationCancelRequireState();
}

class _buttonanimationCancelRequireState extends State<buttonanimationCancelRequire> {
  ButtonState stateOnlyText = ButtonState.idle;
  ButtonState stateOnlyCustomIndicatorText = ButtonState.idle;
  ButtonState stateTextWithIconFollow = ButtonState.idle;
  ButtonState stateTextWithIconFollowing = ButtonState.fail;
  ButtonState stateTextWithIconMinWidthState = ButtonState.idle;

  


  Widget buildTextWithIcon() {
    return ProgressButton.icon(
      iconedButtons: {

// showbuttonAddFriend
      ButtonState.idle: IconedButton(
          text: 
          'Cancel require'
          ,
          icon: Icon(Icons.add, color: Colors.white),
          color: 
          Colors.orange.shade500
           ),


      ButtonState.loading:
          IconedButton(text: "Loading", color: Colors.deepPurple.shade700),

          
      ButtonState.fail: IconedButton(
          text: "Following1",
          
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
            SocialCubit.get(context).unFRIEND(widget.getuserModelFriend!.uId);
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
  }

}



import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../layout/socialapp/cubit/cubit.dart';
import '../../../layout/socialapp/cubit/state.dart';
import '../../../models/social_model/social_user_model.dart';
import '../../../shared/components/components.dart';
import '../chat_details/chat_details.dart';
import '../settings/Profile_screen_friend.dart';

class Friends extends StatelessWidget {
  const Friends({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (context ,state){},
      builder: (context,state){
        SocialCubit.get(context).getAllUsersToken();
        return ConditionalBuilder(
         condition:SocialCubit.get(context).users.isNotEmpty ,
          builder: (context)=>ListView.separated(
              physics: BouncingScrollPhysics(),
              itemBuilder: (context,index)=> buildProfileItem(SocialCubit.get(context).users[index],context),
              separatorBuilder: (context,state) => myDivider(),
              itemCount: SocialCubit.get(context).users.length),
          fallback: (context)=> 
          SocialCubit.get(context).users.length == 0 ?
          Center(child:Text('Chưa có người bạn nào')) :
          Center(child: CircularProgressIndicator()),
        );
      },

    );
  }

  Widget buildProfileItem(SocialUserModel modelUserFriend ,context) => InkWell(
        onTap: (){
          navigateTo(context, ProfileScreenFriend(  
            getuserModelFriend: modelUserFriend, userId: SocialCubit.get(context).socialUserModel!.uId
          ));
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(
                    '${modelUserFriend.image}'),
              ),
              SizedBox(width: 15,),
              Text(
                '${modelUserFriend.name}',
                style: TextStyle(height: 1.4),
              ),
            ],
          ),
        ),
      );
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/models/social_model/post_model_sub.dart';
import 'package:socialapp/modules/settings/Profile_screen_friend.dart';

import '../../../layout/socialapp/cubit/cubit.dart';
import '../../../layout/socialapp/cubit/state.dart';
import '../../../layout/socialapp/sociallayout.dart';
import '../../../models/social_model/post_model.dart';
import '../../../models/social_model/social_user_model.dart';
import '../../../shared/components/components.dart';
import '../../../shared/styles/iconbroken.dart';
import '../CommentsScreen.dart';
import '../new_post/new_post.dart';
import 'package:multi_image_layout/multi_image_layout.dart';
import 'dart:io';
import 'package:socialapp/modules/addMedias/addMedias.dart';
import 'package:socialapp/layout/gallery/gallery_view.dart';
import 'package:socialapp/modules/feeds/feedDetail.dart';
import 'package:socialapp/models/social_model/LikeModel.dart';
import 'package:flutter/cupertino.dart';



class UserLikeSub extends StatelessWidget {
  String? idPost;
  String? idPostSub;
  UserLikeSub(this.idPost, this.idPostSub);

  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    bool loadingne = false;
    return Builder(
      builder: (context) {
        SocialCubit.get(context).getDetailUserLikePostSub(idPost!, idPostSub!);
        SocialCubit.get(context).getMyData();
    

        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {
          },
          builder: (context, state) {
            SocialUserModel? userModel = SocialCubit.get(context).socialUserModel;
            double setWidth = MediaQuery.of(context).size.width;
            double setheight = MediaQuery.of(context).size.height;

            return ConditionalBuilder(
              condition: SocialCubit.get(context).getpostsUserLike!.isNotEmpty &&
                  SocialCubit.get(context).getpostsUserLike != null,
              builder: (context) => SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => buildlikePost(SocialCubit.get(context).getpostsUserLike![index], context, scaffoldKey ),
                      separatorBuilder: (context, index) => SizedBox(
                        height: 8,
                      ),
                      itemCount: (SocialCubit.get(context).getpostsUserLike!.length),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              fallback: (context) => Center(child:Text('Not liker yet')),
            );
          },
        );
      }
    );
  }

  Widget buildlikePost(LikesModel model, context,GlobalKey<ScaffoldState> scaffoldKey, ) => 
   InkWell(
        onTap: (){
          navigateTo(context, ProfileScreenFriend (  
           userId: SocialCubit.get(context).socialUserModel!.uId
          ));
        },
     child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                              radius: 25, backgroundImage: NetworkImage(
                                                // '${comment.image}'
                                                model.image.toString()
                                                )),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(model.name!),
                          ],
                        ),
   );
}


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/layout/socialapp/sociallayout.dart';
import 'package:socialapp/modules/feeds/feedDetail.dart';
import 'package:socialapp/modules/new_post/new_post_album.dart';

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

class LoadAlbums extends StatefulWidget {

  
  LoadAlbums({ Key? key}) : super(key: key);

  @override
  State<LoadAlbums> createState() => _LoadAlbumsState();
}

class _LoadAlbumsState extends State<LoadAlbums> {
  int? switcherIndex = 0;

  @override
  Widget build(BuildContext context) {
    bool loadingne = false;
     var scaffoldKey = GlobalKey<ScaffoldState>();
    return Builder(
      builder: (context) {
        // SocialCubit.get(context).getUserDataFriend(widget.getuId!);

        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context,state){
    //           if (state is SocialCreatePostSuccessState){
    // showToast(text: "Đã thêm bài viết thành công", state: ToastStates.SUCCESS);
    //             loadingne = true;
    //             }
    //             if (state is SocialCreatePostErrorState){
    // showToast(text: "Thêm bài viết thất bại", state: ToastStates.ERROR);
    //             }
          },
          builder: (context,state)
            {                 
              // SocialUserModel? userModel = SocialCubit.get(context).socialUserModel;
              double setWidth = MediaQuery.of(context).size.width;
              double setheight = MediaQuery.of(context).size.height;
              var socialUserModel = SocialCubit.get(context).socialUserModel;
              var profileImage = SocialCubit.get(context).profileImage;
              var coverImage = SocialCubit.get(context).coverImage;
              return ConditionalBuilder(
                 condition: 
                 SocialCubit.get(context).posts3.isNotEmpty 
                 &&
                  SocialCubit.get(context).getsocialUserModelFriend != null,
              builder: (context) =>
               SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: 
                 Container(
                   child: Column(
                        children: [
                        Center(
                         child: SlideSwitcher(
                           children: [
                             Text(
                               'Albums',
                               style: TextStyle(
                    fontSize: 15,
                    color: switcherIndex == 0
                        ? Colors.white.withOpacity(0.9)
                        : Colors.grey),
                             ),
                             Text(
                               'Videos',
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
                           containerBorder: Border.all(color: Color.fromARGB(255, 3, 119, 165)),
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
                           indents: 3,
                           containerHeight: 50,
                           containerWight: 315,
                         ),
                       ),
                        SizedBox(height: 20,),
                        SingleChildScrollView(
                         child:  switcherIndex == 0 ?
                         Container(
                           height: setheight*0.8,
                           child: Grid_Group(),
                         )
                         :
                         Column(
                           children: [
                             Container(
                               height: setheight*0.8,
                               width: setWidth*0.8,
                               child: Grid_Group_Video(),
                             ),
                           ],
                         )
                        ),
                        ]
                    ),
                 ),
                  ),
                ),
               fallback: (context) => SingleChildScrollView(
                 child: 
              Padding(
                    padding: const EdgeInsets.all(8),
                    child: 
                 Column(
                      children: [
                        Text('No have album')
                      ]
                  ),
                  ),),
              );
            }


        );
      }
    );
  }

   
}

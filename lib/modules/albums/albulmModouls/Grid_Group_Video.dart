import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nine_grid_view/nine_grid_view.dart';
import 'package:socialapp/layout/socialapp/cubit/cubit.dart';
import 'package:socialapp/layout/socialapp/cubit/state.dart';
import 'package:socialapp/layout/socialapp/sociallayout.dart';
import 'package:socialapp/models/social_model/post_model.dart';
import 'package:socialapp/models/social_model/post_model_sub.dart';
import 'package:socialapp/models/social_model/social_user_model.dart';
import 'package:socialapp/modules/albums/albulmModouls/drag_sort_page.dart';
import 'package:socialapp/modules/albums/albulmModouls/models.dart';
import 'package:socialapp/modules/albums/albulmModouls/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:socialapp/modules/feeds/feedDetailPostAlbum.dart';
import 'package:socialapp/shared/components/components.dart';
import 'package:socialapp/layout/gallery/gallery_view.dart';
import 'package:socialapp/shared/network/UrlTypeHelper';
import 'package:socialapp/layout/video/video_player.dart';
import 'package:socialapp/modules/feeds/feedDetailPostVideo.dart';
import 'package:socialapp/modules/feeds/feedDetailPost.dart';



class Grid_Group_Video extends StatefulWidget {
  @override
  _Grid_Group_VideoState createState() => _Grid_Group_VideoState();
}

class _Grid_Group_VideoState extends State<Grid_Group_Video> 
  with TickerProviderStateMixin {


  @override
  Widget build(BuildContext context) {
    return
          Builder(
            builder: (context) {
              // SocialCubit.get(context).getAllVideos();
              return BlocConsumer<SocialCubit, SocialStates>(
                  listener: (context, state) {
                    // if(state is LoadAlbumLevel1SuccessState){
                    //   showToast(text: 'Load Abum thành công', state: ToastStates.SUCCESS);
                    // }
                  },
          builder: (context, state) {
            SocialUserModel? userModel =
                SocialCubit.get(context).socialUserModel;
            double setWidth = MediaQuery.of(context).size.width;
            double setheight = MediaQuery.of(context).size.height;

            return ConditionalBuilder(
              condition: SocialCubit.get(context).subpostVideos.isNotEmpty &&
                  SocialCubit.get(context).socialUserModel != null,
              builder: (context) =>  
              SingleChildScrollView(
                child: ListView.builder(
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 1,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) =>
                Column(
                  children: [
                    GridView.count(
  shrinkWrap: true,
  crossAxisCount: 2,
  children:  List.generate(
                                      
                                        SocialCubit.get(context).newListVideo.length,
                                        (index) =>    
                                        Column(
                                          children: [
                                            GestureDetector(
                                               onTap: () {
                                SocialCubit.get(context).newListVideo[index].type == 'posts' ?
                                               navigateTo(context, viewDetailPost(SocialCubit.get(context).newListVideo[index].postId, SocialCubit.get(context).newListVideo[index].postIdSub))
                                               :
                                               navigateTo(context, viewDetailPostAlbum(SocialCubit.get(context).newListVideo[index].postId, SocialCubit.get(context).newListVideo[index].postIdSub));
                          },
                                              child: Text(SocialCubit.get(context).newListVideo[index].type.toString())),
                                            Container(
                                              margin: EdgeInsets.all(5),
                                              child: PhysicalModel(
                                                
                                              color: Color.fromARGB(255, 233, 233, 233),
                                              elevation: 8,
                                              shadowColor: Color.fromARGB(255, 143, 139, 139),
                                              borderRadius: BorderRadius.circular(20),
                                              child: 
                                                ClipRRect(
                                                borderRadius: BorderRadius.circular(20.0),
                                                child: VideoThumbnail(SocialCubit.get(context).newListVideo[index].postImage!)),
                                            ),
                                            ),
                                          ],
                                        ),
                                        //  ClipRRect(
                                        //   borderRadius: BorderRadius.circular(20.0),
                                        //   child: VideoThumbnail(SocialCubit.get(context).subpostVideos[index].postImage!)),
                                      ),
),
                
                  SizedBox(height: 10,),
                  ],
                ),
                              ),

              ),
                  
                  fallback: (context) => Column(
                    children: [
                      Column(
                        children: const <Widget>[
                          // Center(child: CircularProgressIndicator()),
                          Center(child: Text('Not video yet')),
                        ],
                      ),
                    ],
                  ),
              );
            }
          );
  }
          );
}


}


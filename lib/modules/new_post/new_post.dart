import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/modules/addMedias/addMedias.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../layout/socialapp/cubit/cubit.dart';
import '../../layout/socialapp/cubit/state.dart';
import '../../layout/socialapp/sociallayout.dart';
import '../../models/social_model/post_model.dart';
import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import '../../shared/styles/iconbroken.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';


import 'package:flutter/services.dart';
import 'package:image_pickers/image_pickers.dart';
import 'dart:ui' as ui;
import 'package:socialapp/shared/styles/sizingElements.dart';


import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'package:socialapp/models/social_model/post_model_sub.dart';
import 'package:socialapp/shared/network/UrlTypeHelper';
import 'package:socialapp/layout/video/video_player.dart';
import 'package:socialapp/shared/tags/material_tag_editor.dart';
import 'edit_post_sub_when_create.dart';


class NewPostScreen extends StatelessWidget {
  var textController = TextEditingController();
  String? postId;
  PostModel? postModel;

  NewPostScreen({Key? key, this.postId, this.postModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if (state is SocialCreatePostSuccessState) {
          navigateTo(context, SocialLayout(0));
          SocialCubit.get(context).currentIndex = 0;
          // SocialCubit.get(context).postImage = null;
          SocialCubit.get(context).editsubpostTempWhenCreatePost = [];
          SocialCubit.get(context).editsubpostDetailwhenCreate = null;
          
        }
      },
      builder: (context, state) {
        var socialUserModel = SocialCubit.get(context).socialUserModel;
        double setWidth = MediaQuery.of(context).size.width;
        double setheight = MediaQuery.of(context).size.height;
        SocialCubit.get(context).editsubpostTempWhenCreatePost ??= [];

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          
          child: Scaffold(
            resizeToAvoidBottomInset : false,
            appBar: defaultAppBar(
              context: context,
              title: 'Create Post',
              actions: [
                defaultTextButton(
                  text: 'post',
                  function: () {
                    if (SocialCubit.get(context).editsubpostTempWhenCreatePost != null) {
        
                      SocialCubit.get(context).createPost(
                        name: socialUserModel!.name,
                        image: socialUserModel.image,
                        postText: textController.text,
                        date: getDate(),                        // postImage1: SocialCubit.get(context).postImage!.path,
                        time: DateFormat.jm().format(DateTime.now()),
                        // listMedia: [],
                        // subPost: hinhs,
                        tag:  SocialCubit.get(context).valueTags,
                        like: '0',
                        getuId: socialUserModel.uId,
                      );
                    }
                  },
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Container(
                height: setheight,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      if (state is SocialCreatePostLoadingState)
                        LinearProgressIndicator(),
                      if (state is SocialCreatePostLoadingState)
                        SizedBox(
                          height: 10,
                        ),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundImage:
                                NetworkImage('${socialUserModel!.image}'),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: Text(
                              '${socialUserModel.name}',
                              style: TextStyle(height: 1.4),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: textController,
                          decoration: InputDecoration(
                            hintText: 'What is on your mind ...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 200,
                        child: Material_tag_editor()),
                       SizedBox(
                        height: 10,
                      ),
                      // // Hiển thị filePicker
                      if (SocialCubit.get(context).editsubpostTempWhenCreatePost!.length != 0)
                         Column(
                           children: [

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                 OutlinedButton(
                                
                                child: Row(
                                  children: const <Widget>[
                                    Icon(
                                      IconBroken.Close_Square,
                                      color: Colors.red,
                                    ),
                                    SizedBox(width: 10,),
                                    Text('Gỡ tất cả hình ảnh/video',style: TextStyle(color: Colors.blue),),
                                  ],
                                ),
                                 onPressed: (){                        
                                  SocialCubit.get(context).resetState();
                                 },
                                style:OutlinedButton.styleFrom(primary: Colors.blue)  
                              ),
                              ],
                            ),
                            SizedBox(height: 10,),
                             Container(
                                      height: 200,
                                      color: Colors.amber,
                              child: SingleChildScrollView(
                                child: 
                                GridView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount:
                                        SocialCubit.get(context).editsubpostTempWhenCreatePost!.length,
                                    shrinkWrap: true,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            mainAxisSpacing: 20.0,
                                            crossAxisSpacing: 10.0,
                                            childAspectRatio: 0.5),
                                    itemBuilder: (BuildContext context, int index) {
                                     
                                      
                                      return 
                                     Column(
                                         children: <Widget>[
                                           Container(
                                             width: 100,
                                             height: 100,
                                             color: Colors.green,
                                             child: 
                                            //  UrlTypeHelper.getType(SocialCubit.get(context)
                                            //          .paths![index].path!) == UrlType.IMAGE ?
                                             (
                                              (SocialCubit.get(context)
                                                     .editsubpostTempWhenCreatePost![index].postImage!.split('.').last == 'JPG') ||
                                                     (SocialCubit.get(context)
                                                     .editsubpostTempWhenCreatePost![index].postImage!.split('.').last == 'PNG') ||
                                              (SocialCubit.get(context)
                                                     .editsubpostTempWhenCreatePost![index].postImage!.split('.').last == 'jpg') || 
                                              (SocialCubit.get(context)
                                                     .editsubpostTempWhenCreatePost![index].postImage!.split('.').last == 'jpeg') || 
                                              (SocialCubit.get(context)
                                                     .editsubpostTempWhenCreatePost![index].postImage!.split('.').last == 'png')) ?
                                             Image.file(
                                               File(
                                                 SocialCubit.get(context)
                                                     .editsubpostTempWhenCreatePost![index].postImage.toString()
                                                ),
                                               fit: BoxFit.cover,
                                             )
                                            //  VideoItem(File('/data/user/0/com.ngoc.login/cache/file_picker/0efa49599e1ab4c454ff60ed23095c4b.mp4')),
                                             :
                                            //  UrlTypeHelper.getType(SocialCubit.get(context)
                                            //          .paths![index].path!.split('.').last) == UrlType.VIDEO ?
                                             (SocialCubit.get(context)
                                                     .editsubpostTempWhenCreatePost![index].postImage!.split('.').last == 'mp4') ?
                                             Stack(
                                              children: <Widget>[
                                                VideoItem(File(SocialCubit.get(context)
                                                     .editsubpostTempWhenCreatePost![index].postImage!)),
                                                // VideoThumbnail(SocialCubit.get(context)
                                                //      .editsubpostTempWhenCreatePost![index].postImage!),
                                                     Positioned.fill(
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Align(
                                                          alignment: Alignment.bottomLeft,
                                                          child: Container(
                                                            padding: EdgeInsets.all(3.0),
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(30),
                                                              color: Color.fromARGB(66, 255, 255, 255),
                                                              boxShadow: [
                                                                BoxShadow(color: Color.fromARGB(157, 255, 255, 255), spreadRadius: 3),
                                                              ],
                                                            ),
                                                            child: Icon(Icons.video_call_outlined, size:20)     ,
                                                          )           
                                                        ),
                                                      ),
                                                    ),
                                              ],
                                             )
                                                     :
                                                     Text('Chỉ hỗ trợ hiển thị jpg, png và mp4')
                                           ),
                                           Padding(
                                             padding:
                                                 EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                                             child: Row(
                                               mainAxisAlignment:
                                                   MainAxisAlignment.spaceBetween,
                                               children: <Widget>[
                                                 GestureDetector(
                                                  onTap: () {    
                                                                SocialCubit.get(context)
                                                        .geteditDetailPostDetailwhenCreate(
                                                            index);
                                                    SocialCubit.get(context)
                                                        .getTagsSubPosttoEditwhenCreate(
                                                        index);
                                                    Future.delayed(
                                                        Duration(seconds: 3), () {
                                                      showDialog(
                                                        context: context,
                                                        barrierColor: Color.fromARGB(
                                                            97, 184, 181, 181),
                                                        builder:
                                                            (BuildContext context) {
                                                          return AlertDialog(
                                                            // title: Text("Liked post"),
                                                            titleTextStyle: TextStyle(
                                                                fontWeight:
                                                                    FontWeight.bold,
                                                                color: Colors.black,
                                                                fontSize: 20),
                                                            // backgroundColor: Colors.greenAccent,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius.all(
                                                                        Radius
                                                                            .circular(
                                                                                20))),
                                                            //  content: UserLike(postId!),
                                                            content: Container(
                                                              height: setheight * 0.9,
                                                              width: setWidth * 0.9,
                                                              child:
                                                                  SingleChildScrollView(
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Container(
                                                                      height:
                                                                          setheight *
                                                                              0.8,
                                                                      width:
                                                                          setWidth *
                                                                              0.9,
                                                                      child: EditSubPostScreenWhenCreate(
                                                                          id: index,),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    });
                                                            
                                                              },
                                                   child: Icon(
                                                     Icons.edit,
                                                     color: Colors.green[400],
                                                     size: 25,
                                                   ),
                                                 ),
                                                 GestureDetector(
                                                     onTap: () {
                                                       SocialCubit.get(context)
                                                           .deleteItempickFiles(index);
                                                     },
                                                     child: Icon(
                                                       Icons.close,
                                                       color: Colors.red[400],
                                                       size: 25,
                                                     )),
                                               ],
                                             ),
                                           ),
                                         ],
                                       ); 
                                    }),
                              ),
                        ),
                        
                           ],
                         ),
                     
                      // // Kết thúc hiển thị filePicker
                      if (SocialCubit.get(context).postImage != null)
                        Stack(
                          alignment: AlignmentDirectional.topEnd,
                          children: [
                            Container(
                              height: 140,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4.0),
                                  image: DecorationImage(
                                      image: FileImage(
                                          SocialCubit.get(context).postImage!),
                                      fit: BoxFit.cover)),
                            ),
                            IconButton(
                              icon: CircleAvatar(
                                  radius: 20,
                                  child: Icon(
                                    Icons.close,
                                    size: 16,
                                  )),
                              onPressed: () {
                                SocialCubit.get(context).removePostImage();
                              },
                            ),
                          ],
                        ),
                       
                       if (SocialCubit.get(context).editsubpostTempWhenCreatePost == null)
                       Container(),
                     
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              // onPressed: () {
                              //   // SocialCubit.get(context).getPostImage();
                              //   SocialCubit.get(context).selectImages();
                              // },
                          onPressed: () {
                            SocialCubit.get(context).pickFiles();
                            // SocialCubit.get(context).getPostImage();
                          },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(IconBroken.Image),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text('add photo / video'),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                          // SocialCubit.get(context).pickFiles();
                          // MaterialPageRoute(builder: (context) => const GenThumbnailImage(thumbnailRequest: {},));
                              },
                    
                              child: Text('# tags'),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/modules/addMedias/addMedias.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialapp/modules/feeds/feeds.dart';
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
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'edit_post_sub.dart';
import 'package:socialapp/shared/tags/edit_material_tag_editor.dart';

class EditPostScreen extends StatefulWidget {
  String? postId;
  

  EditPostScreen({
    Key? key,
    this.postId,
  }) : super(key: key);

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  var textControllerDes = TextEditingController();
   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if (state is SocialSaveEditSubPostSuccessState) {
          showToast(text: 'Saved', state: ToastStates.SUCCESS);
          Navigator.pop(context);
          Navigator.pop(context);
        }
        if (state is ResetPostSuccessState) { }
      },
      builder: (context, state) {
        var socialUserModel = SocialCubit.get(context).socialUserModel;
        var postModel = SocialCubit.get(context).editpost;
        var postmodelSub = SocialCubit.get(context).editsubpostTemp;
        var postmodelSubTemp = SocialCubit.get(context).editsubpostTemp;
        Future.delayed(Duration(seconds: 1), () {
            if(postModel != null){
        postModel!.text! == '' ?
        textControllerDes.text = '' :
        textControllerDes.text = postModel!.text!;
            }
            else{
              SocialCubit.get(context).textDesReset = '';
            }
        });

        double setWidth = MediaQuery.of(context).size.width;
        double setheight = MediaQuery.of(context).size.height;
        
        return Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset : false,
          appBar: AppBar(
            title: Text('Update post'),
            actions: [
                TextButton(onPressed: () {
                           SocialCubit.get(context)
                      .saveEditPostandSubPost(postModel!.postId, textControllerDes.text);
                },
                child: Text('UPDATE'))
            ],
            leading: IconButton(
    onPressed: ()
    {
      // Navigator.pop(context);
        showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
    title: Text('Leave'),
    titlePadding: EdgeInsetsDirectional.only(start:13,top: 15 ),
    content: Text("Leaving won't save, are you sure?"),
    elevation: 8,
    contentPadding: EdgeInsets.all(15),
    actions: [
      OutlinedButton(
          onPressed: (){
            SocialCubit.get(context).ResetPostandSubPost(postModel!.postId, context);
            // Navigator.pop(context);
            // Navigator.pop(context);
            // Navigator.pop(context);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => SocialLayout(0)));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Icon(Icons.done_all_outlined),
              SizedBox(width:10),
              Text('Đồng ý'),
            ],
          ),
      ),
       ElevatedButton(
          style:ButtonStyle(backgroundColor:MaterialStateProperty.all(Colors.blueAccent)) ,
          onPressed: (){
            // Navigator.of(context, rootNavigator: true).pop(true);
            Navigator.pop(context, true);
          },
          child:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
           Text('Hủy bỏ',style: TextStyle(color: Colors.white))
            ],
          ),
        ),
    ]
                        );
                      });
      
    }, icon:  Icon(
    IconBroken.Arrow___Left_2,
  ),
  ),
          ),
          body: SingleChildScrollView(
            child: Container(
              height: setheight,
              child: ConditionalBuilder(
                  condition: 
                  // SocialCubit.get(context).editsubpostTemp != null &&
                      SocialCubit.get(context).socialUserModel != null,
                  builder: (context) => Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            if (state is SocialSaveEditSubPostLoadingState)
                              LinearProgressIndicator(),
                            if (state is SocialSaveEditSubPostLoadingState)
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
                              child: TextFormField (
                                
                                // controller: textController,
                                onChanged: (value) {
                                  textControllerDes.text = value;
                                  SocialCubit.get(context).textDesPost = value;
                                },
                                controller:
                                    TextEditingController(text: SocialCubit.get(context).textDesPost),  
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
                      child: Edit_Material_tag_editor(idPost: widget.postId)),
                       SizedBox(
                      height: 10,
                    ),
                      
                            // // Hiển thị filePicker
                           
                            if (postmodelSub != null)
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
                                              SizedBox(
                                                width: 10,
                                              ),
                                               Text(
                                                'Gỡ tất cả hình ảnh/video',
                                                style:
                                                    TextStyle(color: Colors.blue),
                                              ),
                                            ],
                                          ),
                                          onPressed: () {
                                            SocialCubit.get(context).resetStateEdit(textControllerDes.text);
                                          },
                                          style: OutlinedButton.styleFrom(
                                              primary: Colors.blue)),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    height: 200,
                                    color: Colors.amber,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          GridView.builder(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount: postmodelSub!.length,
                                              shrinkWrap: true,
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 3,
                                                      mainAxisSpacing: 20.0,
                                                      crossAxisSpacing: 10.0,
                                                      childAspectRatio: 0.5),
                                              itemBuilder: (BuildContext context,
                                                  int index) {
                                                return Column(
                                                  children: <Widget>[
                                                    Container(
                                                      width: 100,
                                                      height: 100,
                                                      color: Colors.green,
                                                      child: (
                     (
                                            (postmodelSub![index].postImage!.split('.').last == 'JPG') ||
                                            (postmodelSub![index].postImage!.split('.').last == 'PNG') ||
                                            (postmodelSub![index].postImage!.split('.').last == 'jpg') || 
                                            (postmodelSub![index].postImage!.split('.').last == 'jpeg') || 
                                            (postmodelSub![index].postImage!.split('.').last == 'png')) ?
                                           Image.file(
                                             File(
                                               postmodelSub![index].postImage!.toString()
                                              ),
                                             fit: BoxFit.cover,
                                           )
                                           :
                                                        UrlTypeHelper.getType(
                                                                  postmodelSub![
                                                                          index]
                                                                      .postImage) ==
                                                              UrlType.IMAGE
                                                          ? Image.network(
                                                              postmodelSub![index]
                                                                  .postImage
                                                                  .toString(),
                                                              fit: BoxFit.cover,
                                                            )
                                                          //  VideoItem(File('/data/user/0/com.ngoc.login/cache/file_picker/0efa49599e1ab4c454ff60ed23095c4b.mp4')),
                                                          : 
                                                          (postmodelSub![index].postImage!.split('.').last == 'mp4') ?
                                                          VideoItem(File(postmodelSub![index].postImage!))
                                                   :                                            
                                                          (UrlTypeHelper.getType(
                                                                      postmodelSub![
                                                                              index]
                                                                          .postImage) ==
                                                                  UrlType.VIDEO)
                                                              ? Stack(
                                                                  children: <
                                                                      Widget>[
                                                                    VideoItem(File(
                                                                        SocialCubit.get(
                                                                                context)
                                                                            .paths![
                                                                                index]
                                                                            .path!)),
                                                                    Positioned.fill(
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(
                                                                                8.0),
                                                                        child: Align(
                                                                            alignment: Alignment.bottomLeft,
                                                                            child: Container(
                                                                              padding:
                                                                                  EdgeInsets.all(3.0),
                                                                              decoration:
                                                                                  BoxDecoration(
                                                                                borderRadius:
                                                                                    BorderRadius.circular(30),
                                                                                color: Color.fromARGB(
                                                                                    66,
                                                                                    255,
                                                                                    255,
                                                                                    255),
                                                                                boxShadow: [
                                                                                  BoxShadow(color: Color.fromARGB(157, 255, 255, 255), spreadRadius: 3),
                                                                                ],
                                                                              ),
                                                                              child: Icon(
                                                                                  Icons.video_call_outlined,
                                                                                  size: 20),
                                                                            )),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              : Text(
                                                                  'Chỉ hỗ trợ hiển thị jpg, png và mp4')),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.fromLTRB(
                                                          8.0, 8.0, 8.0, 0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          GestureDetector(
                                                            onTap: () {
                                                             
                                                              
                                                              SocialCubit.get(
                                                                      context)
                                                                  .geteditDetailPostDetail(
                                                                      index);
                                                      //  SocialCubit.get(
                                                      //                 context)
                                                      //             .getTagsSubPosttoEdit(postmodelSub![
                                                      //                         index]
                                                      //                     .postId, postmodelSub![
                                                      //                         index]
                                                      //                     .postIdSub);             
                       Future.delayed(Duration(seconds: 3), () {
                                                              showDialog(
                                                                context: context,
                                                                barrierColor:
                                                                    Color.fromARGB(
                                                                        97,
                                                                        184,
                                                                        181,
                                                                        181),
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    // title: Text("Liked post"),
                                                                    titleTextStyle: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            20),
                                                                    // backgroundColor: Colors.greenAccent,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.all(
                                                                                Radius.circular(20))),
                                                                    //  content: UserLike(postId!),
                                                                    content:
                                                                        Container(
                                                                      height:
                                                                          setheight *
                                                                              0.9,
                                                                      width:
                                                                          setWidth *
                                                                              0.9,
                                                                      child:
                                                                          SingleChildScrollView(
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize
                                                                                  .min,
                                                                          children: [
                                                                            Container(
                                                                              height:
                                                                                  setheight * 0.8,
                                                                              width:
                                                                                  setWidth * 0.9,
                                                                              child: EditSubPostScreen(
                                                                                  id: index,
                                                                                  uId: postmodelSub[index].uId,
                                                                                  postId: postmodelSub[index].postId,
                                                                                  subpostId: postmodelSub[index].postIdSub,
                                                                                  gettags: postmodelSub[index].tagsTemp
                                                                                  ),
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
                                                              color:
                                                                  Colors.green[400],
                                                              size: 25,
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                              onTap: () {
                                                                // print(postmodelSubtemp1!.length);
                                                                //  postmodelSubtemp.removeAt(index);
                                                                // setState(() {
                                                                //  postmodelSubtemp1 =  postmodelSubtemp;
                                                                // });
                      
                                                                // print('da click xoa');
                                                                // print(postmodelSubtemp.length);
                                                                // print(postmodelSubtemp1!.length);
                                                                SocialCubit.get(
                                                                        context)
                                                                    .getlistDeleteTemp(
                                                                        postmodelSub[
                                                                                index]
                                                                            .postIdSub);
                      
                                                                SocialCubit.get(
                                                                        context)
                                                                    .deleteItemeditSubpost(
                                                                        index, textControllerDes.text);
                                                              },
                                                              child: Icon(
                                                                Icons.close,
                                                                color:
                                                                    Colors.red[400],
                                                                size: 25,
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      
                            // // Kết thúc hiển thị filePicker
                      
                      
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
                                      SocialCubit.get(context).pickFilesEdit(
                                          // widget.postId,
                                          // socialUserModel.name,
                                          // socialUserModel.image,
                                          // socialUserModel.uId
                                          );
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
                  fallback: (context) =>
                      Center(child: CircularProgressIndicator())),
            ),
          ),
        );
      },
    );
  }
}

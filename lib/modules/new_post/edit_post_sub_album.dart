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
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:socialapp/shared/network/UrlTypeHelper';
import 'package:socialapp/layout/video/video_player.dart';
import 'package:socialapp/shared/tags/edit_sub__material_tag_editor.dart';


class EditSubPostScreenAlbum extends StatefulWidget {
  String? uId;
  String? postId;
  String? subpostId;
  int? id;
  List? gettags;

  EditSubPostScreenAlbum({
    Key? key,
    this.id,
    this.uId,
    this.postId,
    this.subpostId,
    this.gettags,
  }) : super(key: key);

  @override
  State<EditSubPostScreenAlbum> createState() => _EditSubPostScreenAlbumState();
}

class _EditSubPostScreenAlbumState extends State<EditSubPostScreenAlbum> {
  var textControllerDes = TextEditingController();

  @override
  Widget build(BuildContext context) {
      // Future.delayed(Duration(seconds: 5), () {
      //     SocialCubit.get(context).geteditDetailPost(widget.postId!);
      //   });
    
    print('check--------------------------------->>>>>>>');
    print(widget.gettags);
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        // if (state is SocialCreatePostSuccessState) {
        //   navigateTo(context, SocialLayout(0));
        //   SocialCubit.get(context).currentIndex = 0;
        //   SocialCubit.get(context).postImage = null;
        // }
      },
      builder: (context, state) {
        var editsubpostDetail = SocialCubit.get(context).editsubpostDetail;
        double setWidth = MediaQuery.of(context).size.width;
        double setheight = MediaQuery.of(context).size.height;
        // Future.delayed(Duration(seconds: 3), () {
        //   print(editsubpostDetail!.text!);
        // });
        if(editsubpostDetail!.textTemp == null){
            editsubpostDetail.textTemp = '';
        }
        editsubpostDetail.text ??= '';
        widget.subpostId ??= '';
        widget.postId ??= '';
        widget.gettags ??= [];
        (editsubpostDetail.text! == null || (editsubpostDetail!.text! == '')) ?
        textControllerDes.text = editsubpostDetail!.textTemp!.toString() :
        textControllerDes.text = editsubpostDetail!.text!.toString();
        
        return 
        Scaffold(
          resizeToAvoidBottomInset : false,
          body: 
SingleChildScrollView(
  child:   Container(
    height: setheight,
    child: ConditionalBuilder(
    
                       condition: 
    
                       SocialCubit.get(context).editsubpostDetail != null
    
                       &&
    
                        SocialCubit.get(context).socialUserModel != null,
    
                    builder: (context) =>
    
              Padding(
    
                padding: const EdgeInsets.all(20),
    
                child: Column(
    
                  children: [
    
                    Row(
    
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    
                          mainAxisSize: MainAxisSize.max,
    
                          crossAxisAlignment: CrossAxisAlignment.start,
    
                          children: [
    
                            Container(
    
                            width: 50,
    
                            child: textModel(text: 'Des: ',fontSize: 20.0)),
    
                            SizedBox(width:10),
    
                      
    
                        Expanded(
    
                          child: TextField(
    
                            controller: TextEditingController(text: 
    
                            editsubpostDetail!.textTemp == '' ?
    
                            editsubpostDetail!.text
    
                            :
    
                            editsubpostDetail!.textTemp
    
                            ),
    
                            onChanged: (value) {
    
                                  textControllerDes.text = value;
    
                                },
    
                            // controller: textController,
    
                            decoration: InputDecoration(
    
                              // hintText: 'What is on your mind ...',
    
                              // border: InputBorder.none,
    
                            ),
    
                          ),
    
                        ),
    
                      ],
    
                    ),
    
                    SizedBox(
    
                      height: 10,
    
                    ),

                    Text( widget.gettags!.toString()),
    
                    SingleChildScrollView(
    
                      child: SizedBox(
    
                        height: 200,
    
                        child: Edit_Sub_Material_tag_editor(gettags: widget.gettags!)),
    
                    ),
    
                    SizedBox(
    
                      height: 10,
    
                    ),
    
                    Container(
    
                      height: 300,
    
                      child:  
                      (
                                            (editsubpostDetail.postImage!.split('.').last == 'JPG') ||
                                            (editsubpostDetail.postImage!.split('.').last == 'PNG') ||
                                            (editsubpostDetail.postImage!.split('.').last == 'jpg') || 
                                            (editsubpostDetail.postImage!.split('.').last == 'jpeg') || 
                                            (editsubpostDetail.postImage!.split('.').last == 'png')) ?
                                           Image.file(
                                             File(
                                               editsubpostDetail.postImage.toString()
                                              ),
                                             fit: BoxFit.cover,
                                           )
                                           :
                      UrlTypeHelper.getType(editsubpostDetail.postImage) == UrlType.IMAGE ?
    
                  Image.network(
    
                    editsubpostDetail.postImage.toString(),
    
                    fit: BoxFit.cover,
    
                  )
    
                  : 
                    (editsubpostDetail.postImage!.split('.').last == 'mp4') ?
                    VideoItem(File(editsubpostDetail.postImage!)) 
                    :
                  UrlTypeHelper.getType(editsubpostDetail.postImage) == UrlType.VIDEO ?
                  Stack(
    
                                            children: <Widget>[
    
                                              VideoThumbnail(editsubpostDetail.postImage.toString()),
    
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
    
                  Container(),
    
                    ),
    
                   
    
                   SizedBox(height: 10,),
    
                   Row(
    
                    mainAxisAlignment: MainAxisAlignment.end,
    
                    children: [
                    TextButton(onPressed: () {
    
                      SocialCubit.get(context).editItemeditSubpostAlbum(widget.id, textControllerDes.text, widget.postId!, widget.subpostId!);
    
                      Navigator.pop(context);
    
                    }, child: Text('OK'))
    
                   ],)
    
                   
    
                 ],
    
                ),
    
              ),
    
            fallback: (context) => 
    
                     Center(child: CircularProgressIndicator())
    
            ),
  ),
),
        );
      },
    );
  }
}

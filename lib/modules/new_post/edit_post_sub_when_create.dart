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
import 'package:socialapp/shared/tags/edit_material_tag_editor_when_create.dart';


class EditSubPostScreenWhenCreate extends StatefulWidget {
  
  int? id;

  EditSubPostScreenWhenCreate({
    Key? key,
    this.id,
    
  }) : super(key: key);

  @override
  State<EditSubPostScreenWhenCreate> createState() => _EditSubPostScreenWhenCreateState();
}

class _EditSubPostScreenWhenCreateState extends State<EditSubPostScreenWhenCreate> {
  var textControllerDes = TextEditingController();

  @override
  Widget build(BuildContext context) {
    
   
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        // if (state is SocialCreatePostSuccessState) {
        //   navigateTo(context, SocialLayout(0));
        //   SocialCubit.get(context).currentIndex = 0;
        //   SocialCubit.get(context).postImage = null;
        // }
      },
      builder: (context, state) {
        var editsubpostDetailwhenCreate = SocialCubit.get(context).editsubpostDetailwhenCreate;
        double setWidth = MediaQuery.of(context).size.width;
        double setheight = MediaQuery.of(context).size.height;
        print(editsubpostDetailwhenCreate!.postId);
        // Future.delayed(Duration(seconds: 3), () {
        //   print(editsubpostDetail!.text!);
        // });
         editsubpostDetailwhenCreate!.text! == null ?
        textControllerDes.text = '' :
        textControllerDes.text = editsubpostDetailwhenCreate!.text!.toString();
        return 
        Scaffold(
          resizeToAvoidBottomInset : false,
          body: 
SingleChildScrollView(
  child:   Container(
    height: setheight,
    child: ConditionalBuilder(
    
                       condition: 
    
                       SocialCubit.get(context).editsubpostDetailwhenCreate != null
    
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
    
                            controller: TextEditingController(text: editsubpostDetailwhenCreate!.text),
    
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
    
                    SingleChildScrollView(
    
                      child: SizedBox(
    
                        height: 200,
    
                        child: Edit_Material_tag_editor_when_create()),
    
                    ),
    
                    SizedBox(
    
                      height: 10,
    
                    ),
    
                    Container(
    
                      height: 300,
    
                      child:  
    
                      editsubpostDetailwhenCreate.postImage!.split('.').last == 'JPG' ||
    
                      editsubpostDetailwhenCreate.postImage!.split('.').last == 'PNG' ||
    
                      editsubpostDetailwhenCreate.postImage!.split('.').last == 'jpg' || 
    
                      editsubpostDetailwhenCreate.postImage!.split('.').last == 'jpeg' || 
    
                      editsubpostDetailwhenCreate.postImage!.split('.').last == 'png' ?
    
                      Image.file(
    
                       File(
    
                        editsubpostDetailwhenCreate.postImage.toString()
    
                          ),
    
                         fit: BoxFit.cover,
    
                         )
    
                  :
    
                  editsubpostDetailwhenCreate.postImage!.split('.').last == 'mp4' ?
    
                  Stack(
    
                                            children: <Widget>[
    
                                              VideoItem(File(editsubpostDetailwhenCreate.postImage!)),
    
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
    
                   
    
                   SizedBox(height: 10,),
    
                   Row(
    
                    mainAxisAlignment: MainAxisAlignment.end,
    
                    children: [
    
                    TextButton(onPressed: () {
    
                      SocialCubit.get(context).editItemeditSubpostWhenCreate(widget.id, textControllerDes.text, SocialCubit.get(context).valueTagsSubwhenCreate);
    
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

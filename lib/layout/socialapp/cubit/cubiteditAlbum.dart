import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:intl/intl.dart';
import 'package:socialapp/layout/socialapp/cubit/state.dart';

// import cho file picker
import 'package:file_picker/file_picker.dart';
import 'package:socialapp/models/social_model/post_model_sub.dart';
// kết thúc import cho file picker

import '../../../shared/components/components.dart';
import '../../../shared/components/constants.dart';

import 'dart:async';
import 'package:socialapp/models/social_model/post_model.dart';




class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());
List<PlatformFile>? paths = null;
  

  static SocialCubit get(context) => BlocProvider.of(context);
void addsubPost({
    String? idDoc,
    String? name,
    String? image,
    String? postText,
    String? date,
    String? postImage1,
    String? postIDSub,
    String? uId,
    String? display,
  }){

paths!.forEach((i) {
        firebase_storage.FirebaseStorage.instance
                    .ref()
                    .child('users/' + uId! + '/albumImage/${Uri
                    .file(i.path.toString())
                    .pathSegments
                    .last}')
                    .putFile(File(i.path.toString()))
                    .then((value) {
                  value.ref.getDownloadURL().then((value) {
                  
                  
                   PostModelSub modelSub = PostModelSub(
                                name:name,
                                uId: uId,
                                image:image,
                                text: '',
                                postImage: value.toString(),
                                likes: 0,
                                comments: 0,
                                date: getDate(),
                                time: DateFormat.jm().format(DateTime.now()),
                                dateTime: FieldValue.serverTimestamp(),
                                tags: [],
                                type: 'posts',
                                display: display
                                // postIdSub: postIDSub,
                              );
                                     FirebaseFirestore.instance
                                    .collection('posts')
                                    .doc(idDoc)
                                    .collection('posts')
                                    .add(modelSub.toMap())
                                    .then((value) async{
             
                                      print('THÊM SUBPOST THÀNH CÔNG');
                                 emit(SocialAddSubPostSuccessState());
                                    }).catchError((error) {

                                  if (kDebugMode) {
                                    print(error.toString());
                                  }
                                  emit(SocialAddSubPostErrorState());
                                });

                                
                
                    // uploadPost(name: name, postText: postText, image: image, date: date, time: time, dateTime: dateTime, listMedia: listMedia, postImage1: value, tag: tag, like: like);

                  }).catchError((error) {
                    emit(SocialCreateFilePostErrorState());
                  });
                }).catchError((error) {
                  emit(SocialCreateFilePostErrorState());
                });
    });
  }

///////////////////////////////////////////////////////////////////////////// 
  /////////// edit post
    PostModel? editpost;
    List<PostModelSub>? editsubpost;
    List<PostModelSub>? editsubpostwhenchangeDes;
    List<PostModelSub>? editsubpostTemp;
    List<PostModelSub>? editsubpostTemp1;
    String? textDesPost;
    String? textDesReset;
    
  void geteditDetailPost(String idPost) {
    textDesPost = '';
      FirebaseFirestore.instance
        .collection('posts').doc(idPost)
        .snapshots()
        .listen((event) async {
      editpost=null;
      editpost = (PostModel.fromJson(event.data()));
      textDesPost = editpost!.text;
      // emit(SocialGetEditPostSuccessState());
    });

    //// get sub post
    FirebaseFirestore.instance
        .collection('posts').doc(idPost).collection('posts')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((event) async {
      editsubpost=[];
      event.docs.forEach((element) async {
        editsubpost!.add(PostModelSub.fromJson(element.data()));
        
        print('------------------------------------------->>>>>>>>>>');
      print(editsubpost!.length);
      for(int i = 0; i< editsubpost!.length; i++){
        print('JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ');
        print(editsubpost![i].postIdSub );
        listDeleteTemp!.forEach((element) {
          if(editsubpost![i].postIdSub == element){
              editsubpost!.removeAt(i);
              
              print(editsubpost![i].uId);
              print(element);
            }
        }); 
      }

        editsubpostwhenchangeDes = editsubpost;

      
      // print(element);
      });
      emit(SocialGetEditSubPostSuccessState());
    });
  }

  //  PostModelSub? editsubpostDetail;
  // void geteditDetailPostDetail(String idPost, String idSubPost ) {
  //     FirebaseFirestore.instance
  //       .collection('posts').doc(idPost).collection('posts').doc(idSubPost)
  //       .snapshots()
  //       .listen((event) async {
  //     editsubpostDetail=null;
  //     editsubpostDetail = (PostModelSub.fromJson(event.data()));
  //     // emit(SocialGetEditPostSuccessState());
  //   });
  // }

  PostModelSub? editsubpostDetail;
  void geteditDetailPostDetail(int? id) {
     for(int i = 0; i< editsubpostwhenchangeDes!.length; i++){
       if(i == id){
        editsubpostDetail = editsubpostwhenchangeDes![id!];
       }
       
    }
    emit(GetEditItemTempSuccessState());
    
  }
  
  void deleteItemeditSubpost(int? id, String? gettextDes) {
    // editsubpost!.removeAt(id!);
    editsubpostwhenchangeDes!.removeAt(id!);
    textDesPost = gettextDes;
    emit(DeleteIndexMultiPicSuccessState());
  }

  void editItemeditSubpost(int? id, String? text, String? idPost, String? idSubPost) async{
    for(int i = 0; i< editsubpostwhenchangeDes!.length; i++){
       if(i == id){
            editsubpostwhenchangeDes![id!].text = text;
            await FirebaseFirestore.instance.collection('posts').doc(idPost).collection('posts').doc(idSubPost)
            .update(({
          'textTemp': text,
        }));
       }
      
    }
    emit(EditItemTempSuccessState());
  }


  List<String>? listDeleteTemp = [];
void getlistDeleteTemp(String? idTemp) {

    listDeleteTemp = [idTemp!, ...listDeleteTemp!];
    print('HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH');
    print(listDeleteTemp);
   
}


Future<void> pickFilesEdit(
    String? idDoc,
    String? name,
    String? image,
    String? uId,
) async {
    // resetState();
      final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result == null) return;
    else{
    paths = result.files;
    emit(UploadMultiPicSuccessState());
    showToast(text: "Đã thêm ảnh", state: ToastStates.SUCCESS);

    // paths!.forEach((element) {
    //   PostModelSub model = PostModelSub(
    //                               name:name,
    //                               uId: socialUserModel!.uId,
    //                               image:image,
    //                               likes: 0,
    //                               comments: 0,
    //                               date: getDate(),
    //                               time: DateFormat.jm().format(DateTime.now()),
    //                               dateTime: FieldValue.serverTimestamp(),
    //                               tags: null,
    //                               type: 'post',
    //                               display: 'no'
    //                               // subPost: toList1(),
    //                             );
    //   var map = Map<String, dynamic>.from(model as Map<dynamic, dynamic>);
    //   editsubpostTemp1!.add(PostModelSub.fromJson(map));
     
      
    //   followingModel!.add(FollowerModel.fromJson(map));
      
    // });

    print('///////////////////////////////////////////////////////////////////////');
    print('paths sau khi them là: ' + paths!.length.toString());
   addsubPost(
      idDoc: idDoc,
      name: name,
      image: image,
      uId: uId,
      display: 'no'
   );
   Future.delayed(Duration(seconds: 3), () {
          FirebaseFirestore.instance
        .collection('posts').doc(idDoc).collection('posts')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((event) async {
      editsubpost=[];
      event.docs.forEach((element) async {
        editsubpost!.add(PostModelSub.fromJson(element.data()));
        await FirebaseFirestore.instance.collection('posts').doc(idDoc).collection('posts').doc(element.id)
            .update(({
          'postId': idDoc,
          'postIdSub': element.id,
        }));
      });
      
      });       
      
      emit(SocialGetSubPostTempSuccessState());
        });
  
    }
  }

   void deleteSubPost(String? postId, String? subpostId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId).collection('posts')
        .doc(subpostId)
        .delete()
        .then((value) {
      emit(DeleteSubPostSuccessState());
    });
  }

   void saveEditPostandSubPost(String? postId, String? text) async{
    
    await FirebaseFirestore.instance.collection('posts').doc(postId)
            .update(({
          'text': text,
        }));
   

     listDeleteTemp!.forEach((element) {
      deleteSubPost(postId, element);
    });

    for(int i = 0; i< editsubpostwhenchangeDes!.length; i++){
       await FirebaseFirestore.instance.collection('posts').doc(postId).collection('posts').doc(editsubpostwhenchangeDes![i].postIdSub.toString())
            .update(({
          'text': editsubpostwhenchangeDes![i].textTemp,
          'display': 'yes',
        }));
    }
      emit(SocialSaveEditSubPostSuccessState());
  }

  void ResetPostandSubPost(String? postId, context) async{
    if (editsubpostwhenchangeDes != null){
     print('99999999999999999999999999');
    print(postId);
    print(editsubpostwhenchangeDes!.length);
    
    await FirebaseFirestore.instance.collection('posts').doc(postId)
            .update(({
          'text': textDesReset,
        }));
    for(int i = 0; i< editsubpostwhenchangeDes!.length; i++){
      if((editsubpostwhenchangeDes![i].display == 'no')){
       
        print(i.toString() + ' 99999999999999999999999999999');
        await FirebaseFirestore.instance.collection('posts').doc(postId).collection('posts').doc(editsubpostwhenchangeDes![i].postIdSub.toString()).delete()
        .then((value) {
          Navigator.pop(context);
      // showToast(text: "Post Deleted", state: ToastStates.ERROR);
      // emit(DeletePostSuccessState());
    });
      }
    }
      emit(ResetPostSuccessState());
      }
      else{
        await FirebaseFirestore.instance.collection('posts').doc(postId)
            .update(({
          'text': textDesReset,
        }));
      }
  }

  /////////// ket thuc edit post
 ///////////////////////////////////////////////////////////////////////////// 
 ///
}
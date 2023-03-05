import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:intl/intl.dart';
import 'package:socialapp/layout/socialapp/cubit/state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// import cho file picker
import 'package:file_picker/file_picker.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:socialapp/models/social_model/post_model_sub.dart';
// kết thúc import cho file picker

import 'dart:math';



import '../../../models/social_model/LikeModel.dart';
import '../../../models/social_model/comment_model.dart';
import '../../../models/social_model/message_model.dart';
import '../../../models/social_model/post_model.dart';
import '../../../models/social_model/social_user_model.dart';
import '../../../modules/chats/chats.dart';
import '../../../modules/feeds/feeds.dart';
import '../../../modules/new_post/new_post.dart';

import '../../../modules/settings/Profile_screen.dart';
import '../../../modules/social_login/social_login_screen.dart';
import '../../../modules/users/users.dart';
import '../../../shared/components/components.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/network/local/cache_helper.dart';

import 'dart:async';
import 'package:flutter/services.dart';
import 'package:image_pickers/image_pickers.dart';

import 'package:flutter/rendering.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:image_pickers/image_pickers.dart';
import 'dart:ui' as ui;



class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  

  static SocialCubit get(context) => BlocProvider.of(context);
  SocialUserModel? socialUserModel;
  int currentIndex = 0;
  List<Widget> screens = [
    Feeds(),
    Chats(),
    NewPostScreen(),
    Friends(),
    ProfileScreen(),
  ];
  List<String> titles = ['Home', 'Chats', 'Post', 'Friends', 'Settings'];
  void changeBottomNav(int index) {
    if (index == 1) {
      getAllUsers();
    }
    if (index == 4) {
      getUserData(uId);
    }
    if (index == 3) {
      getAllUsers();
    }
    if (index == 2) {
      emit(SocialNewPostState());
    } else {
      currentIndex = index;
      emit(SocialChangeBottomNav());
    }
  }

  

  //USER DATA

  File? profileImage;
  File? coverImage;
  List<SocialUserModel> users = [];
  // var picker = ImagePicker();
  final ImagePicker picker = ImagePicker();
  void getUserData(String? uId) {
    emit(SocialGetUserLoadingState());
    uId = CacheHelper.getData(key: 'uId');
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      socialUserModel = SocialUserModel.fromJson(value.data());
      if (kDebugMode) {
        print(socialUserModel.toString());
      }

      emit(SocialGetUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialGetUserErrorState(error.toString()));
    });
  }
  void getAllUsers() {
    emit(SocialGetAllUserLoadingState());
    users = [];
    {
      FirebaseFirestore.instance.collection('users').get().then((value) {
        for (var element in value.docs) {
          if (element.data()['uId'] != socialUserModel!.uId)
          {
            users.add(SocialUserModel.fromJson(element.data()));
            print(users.toString());
          }
        }
        emit(SocialGetAllUserSuccessState());
        print(users.toString());
      }).catchError((error) {
        emit(SocialGetAllUserErrorState(error.toString()));
      });
    }
  }
  Future<void> getCoverImage() async {
  
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(SocialCoverSuccessState());
    } else {
      emit(SocialCoverErrorState());
      // showToast(text: "Chưa chọn ảnh cover mà thoát ra rồi", state: ToastStates.ERROR);
    }
      if(state is SocialCoverErrorState){
      showToast(text: "Chưa chọn ảnh cover mà thoát ra rồi", state: ToastStates.ERROR);}
      
      if(state is SocialCoverSuccessState){
      showToast(text: "Đã chọn ảnh cover thành công", state: ToastStates.SUCCESS);}
    
  }
  Future<void> getProfileImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(SocialProfileImageSuccessState());
    } else {
      print('No image selected');
      emit(SocialProfileImageErrorState());
    }
    if(state is SocialProfileImageErrorState){
      showToast(text: "Chưa chọn ảnh profile mà thoát ra rồi", state: ToastStates.ERROR);}
      if(state is SocialProfileImageSuccessState){
      showToast(text: "Đã chọn ảnh profile thành công", state: ToastStates.SUCCESS);}
  }
  void uploadProfileImage(
    {
    required String name,
    required String phone,
    required String bio,
  }
  ) {
    emit(SocialUploadProfileImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/profile/${Uri
        .file(profileImage!.path)
        .pathSegments
        .last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        emit(SocialUploadProfileImageSuccessState());
        print(value);
        updateUser(name: name, phone: phone, bio: bio, image: value);

      }).catchError((error) {
        emit(SocialUploadProfileImageErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadProfileImageErrorState());
    });
  }
  
  void uploadCoverImage(
    {
    required String name,
    required String phone,
    required String bio,
  }
  ) {
    emit(SocialUploadCoverImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/cover/${Uri
        .file(coverImage!.path)
        .pathSegments
        .last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        //emit(SocialUploadCoverSuccessState());
        print(value);
        updateUser(name: name, phone: phone, bio: bio, cover: value);
      }).catchError((error) {
        emit(SocialUploadCoverErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadCoverErrorState());
    });
  }
  void updateUser({
    required String name,
    required String phone,
    required String bio,
    String? cover,
    String? image,
  }) {
    // uploadProfileImage(name: name, phone:phone, bio:bio);
    // uploadCoverImage(name: name, phone:phone, bio:bio);

      // emit(SocialUploadCoverImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/cover/${Uri
        .file(coverImage!.path)
        .pathSegments
        .last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        emit(SocialUploadCoverSuccessState());
        print(value);

        //////////  thêm ảnh cover vào databaseStore
        emit(SocialUserUpdateLoadingState());
    SocialUserModel model = SocialUserModel(
      name: name,
      phone: phone,
      bio: bio,
      email: socialUserModel!.email,
      uId: socialUserModel!.uId,
      cover: value,
      image: image ?? socialUserModel!.image,

    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(socialUserModel!.uId)
        .update(model.toMap())
        .then((value) {
      getUserData(uId);
    }).catchError((error) {
      emit(SocialUserUpdateErrorState());
    });
    //////////////

      }).catchError((error) {
        emit(SocialUploadCoverErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadCoverErrorState());
    });
    
    
  // emit(SocialUploadProfileImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/profile/${Uri
        .file(profileImage!.path)
        .pathSegments
        .last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        emit(SocialUploadProfileImageSuccessState());
        print(value);
        //////////  thêm ảnh profile vào databaseStore
        emit(SocialUserUpdateLoadingState());
    SocialUserModel model = SocialUserModel(
      name: name,
      phone: phone,
      bio: bio,
      email: socialUserModel!.email,
      uId: socialUserModel!.uId,
      cover: cover ?? socialUserModel!.cover,
      image: value,

    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(socialUserModel!.uId)
        .update(model.toMap())
        .then((value) {
      getUserData(uId);
    }).catchError((error) {
      emit(SocialUserUpdateErrorState());
    });
    //////////////

      }).catchError((error) {
        emit(SocialUploadProfileImageErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadProfileImageErrorState());
    });

    
  }






//POST DATA
  List<PostModel> posts1 = [];
  List<PostModelSub> posts2 = [];

  // PostModel? postModel;
  // PostModel? postModel;
  PostModelSub? postModelSub;
  Random random = new Random();


  void uploadPost({
      String? name,
      String? postText,
      String? image,
      String? date,
      String? time,
      String? dateTime,
      String? postImage1,
      List<PlatformFile>? listMedia,
      List? subPost,
      List? tag,
      String? like,
  }) {
    emit(SocialCreatePostLoadingState());
    print('uuuuuuuuuuuuuuuuuuuuupppppppppp0000000000000000000000');
    for (var img in paths!) {
    firebase_storage.FirebaseStorage.instance
          .ref()
        .child('users/post/${Uri
        .file(img.path!)
        .pathSegments
        .last}')
        .putFile(File(img.path!))
        .then((value) {
          print(value);
      value.ref.getDownloadURL().then((value) {
        if (kDebugMode) {
          print(value);
        }
        // createPost(
        //  name:name,
        //  image:image,
        //  postText: postText,
        //  time: time,
        //  date: date,
        //  postImage1: postImage1,
        //  tag: tag,
        // //  listMedia: listMedia,
        // );
        // emit(SocialCreatePostSuccessState());
      }).catchError((error) { 
        emit(SocialCreatePostErrorState());
      });
    }).catchError((error) {
      emit(SocialCreatePostErrorState());
    });
    }
  }


  // Tạo post
  void createPost({
    String? name,
    String? image,
    String? postText,
    String? date,
    // String? postImage1,
    String? time,
    // List<PlatformFile>? listMedia,
    List<PostModelSub>? subPost,
    List? tag,
    String? like,
  }) {
    emit(SocialCreatePostLoadingState());
    print('paths la: -----------> : ' + paths.toString());



  


 
   PostModel model = PostModel(
                                  name:name,
                                  uId: socialUserModel!.uId,
                                  image:image,
                                  text: postText,
                                  // postImage: value,
                                  likes: 0,
                                  comments: 0,
                                  date: date,
                                  time: time,
                                  dateTime: FieldValue.serverTimestamp(),
                                  tags: tag,
                                  // subPost: toList1(),
                                );
                                // print('model cua subPost laf ------------>  ' + model.subPost.toString());
                            FirebaseFirestore.instance
                                  .collection('posts')
                                  .add(model.toMap())
                                  .then((value) async{          
                                print('000000000000000');
                                print(value);
                                addsubPost(
                                  idDoc: value.id.toString(),
                                );
                                getAllImageofSubCollention(value.id.toString());
                                
                                print('đã lưu vào firestore');
                                paths = null;
                                print('55555555555555555555555555 gia tri cua postImage sau khi dat bang null la : --------------->' + value.id.toString());
                                emit(SocialCreatePostSuccessState());

                              }).catchError((error) {
                                emit(SocialCreatePostErrorState());
                              });
   

   
  }

  void addsubPost({
    String? idDoc,
    String? name,
    String? image,
    String? postText,
    String? date,
    String? postImage1,
    String? time,
    List? tag,
    String? like,
    String? postIDSub,
  }){

paths!.forEach((i) {
        firebase_storage.FirebaseStorage.instance
                    .ref()
                    .child('users/post/${Uri
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
                                time: time,
                                dateTime: FieldValue.serverTimestamp(),
                                tags: [],
                                // postIdSub: postIDSub,
                              );
                                     FirebaseFirestore.instance
                                    .collection('posts')
                                    .doc(idDoc)
                                    .collection('subPost')
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
  


  List<PostModelSub>? getpostsImage=[];
  void getAllImageofSubCollention(String idPost) {
      FirebaseFirestore.instance
        .collection('posts').doc(idPost).collection('subPost')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((event) async {
      posts2=[];
      event.docs.forEach((element) async {
        posts2.add(PostModelSub.fromJson(element.data()));
        var likes = await element.reference.collection('likes').get();
        var comments = await element.reference.collection('comments').get();
        await FirebaseFirestore.instance.doc(idPost).collection('subPost').doc(element.id)
            .update(({
          'likes':likes.docs.length,
          'comments':comments.docs.length,
          'postIdSub': element.id,
        }));
      });
      emit(SocialGetSubPostSuccessState());

    });
  }






  void deletePost(String? postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .delete()
        .then((value) {
      showToast(text: "Post Deleted", state: ToastStates.ERROR);
      emit(DeletePostSuccessState());
    });
  }
  void removePostImage() {
    postImage = null;
    emit(SocialRemovePostState());
  }
  void getPosts() {
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((event) async {
      posts1=[];
      event.docs.forEach((element) async {
        posts1.add(PostModel.fromJson(element.data()));
        var likes = await element.reference.collection('likes').get();
        var comments = await element.reference.collection('comments').get();
        await FirebaseFirestore.instance.collection('posts').doc(element.id)
            .update(({
          'likes':likes.docs.length,
          'comments':comments.docs.length,
          'postId': element.id,
        }));
        // getAllImageofSubCollention(element.id.toString());
      });
      emit(SocialGetPostsSuccessState());
    });

  }
  Future<bool> likedByMe(
      {context,
        String? postId,
        PostModel? postModel,
        SocialUserModel? postUser}) async {
    emit(SocialLikePostsLoadingState());
    bool isLikedByMe = false;
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .get()
        .then((event) async {
      var likes = await event.reference.collection('likes').get();
      likes.docs.forEach((element) {
        if (element.id == socialUserModel!.uId) {
          isLikedByMe = true;
          //disLikePost(postId);
        }
      });
      if (isLikedByMe == false) {
        likePost(
            postId: postId,
            context: context,
            postModel: postModel,
            postUser: postUser);
      }
      print(isLikedByMe);
      emit(SocialLikePostsSuccessState());
    });
    return isLikedByMe;
  }
  Future<void> getPostImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(SocialPostSuccessState());
      showToast(text: "Đã thêm ảnh", state: ToastStates.SUCCESS);
      print('66666666666666666666666');
      print(postImage);
    } else {
      if (kDebugMode) {
        print('No image selected');
      }
      emit(SocialPostErrorState());
    }
  }

  


// Fife Picker

final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  String? fileName;
  List<PlatformFile>? paths = null;
  String? _extension;
  

  Future<void> pickFiles() async {
    // resetState();
      final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result == null) return;
    else{
    paths = result.files;
    emit(UploadMultiPicSuccessState());
    print('---------------------------------');
    print(paths.toString());
    showToast(text: "Đã thêm ảnh", state: ToastStates.SUCCESS);
    }
  }
    void deleteItempickFiles(int? id) {
    paths!.removeAt(id!);
    emit(DeleteIndexMultiPicSuccessState());
    // FirebaseFirestore.instance
    //     .collection('posts')
    //     .doc(postId)
    //     .delete()
    //     .then((value) {
    //   showToast(text: "Post Deleted", state: ToastStates.ERROR);
    //   emit(DeletePostSuccessState());
    // });
  }




  // Future<void> clearCachedFiles() async {
  //   await resetState();
  //   try {
  //     // bool? result = await FilePicker.platform.clearTemporaryFiles();
  //     // ScaffoldMessenger.of(context).showSnackBar(
  //     //   SnackBar(
  //     //     backgroundColor: result! ? Colors.green : Colors.red,
  //     //     content: Text((result
  //     //         ? 'Temporary files removed with success.'
  //     //         : 'Failed to clean temporary files')),
  //     //   ),
  //     // );
  //   } on PlatformException catch (e) {
  //     _logException('Unsupported operation' + e.toString());
  //   } catch (e) {
  //     _logException(e.toString());
  //   } finally {
  //     // setState(() => _isLoading = false);
  //   }
  // emit(DeleteAllFilePickerSuccessState());
  // }

  

  

  Future<void> _logException(String message)async {
    print(message);
    _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

 Future <void> resetState() async{
      fileName = null;
      paths = null;
    emit( await DeleteAllFilePickerSuccessState());
    // showToast(text: "Đã xóa thành công2", state: ToastStates.SUCCESS);
  }

// Kết thúc File Picker


  void likePost({context, String? postId, PostModel? postModel, SocialUserModel? postUser,String?dateTime}) {
    LikesModel likesModel = LikesModel(
      uId: socialUserModel!.uId,
      name: socialUserModel!.name,
      image: socialUserModel!.image,
        dateTime: FieldValue.serverTimestamp());
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(socialUserModel!.uId)
        .set(likesModel.toMap())
        .then((value) {
      getPosts();

      emit(SocialLikePostsSuccessState());
    }).catchError((error) {
      emit(SocialLikePostsErrorState(error.toString()));
    });
  }




//comment data
  List<CommentModel> comments = [];
  CommentModel ? commentModel;
  File? postImage;

  void commentPost({
    required String? postId,
     String ? comment,
    Map<String, dynamic>? commentImage,
    required String? time,
    required String? date,
  }) {
    CommentModel commentModel = CommentModel(
      name: socialUserModel!.name,
      image: socialUserModel!.image,
      commentText: comment,
      commentImage: commentImage,
      time: time, date: date,
      dateTime: FieldValue.serverTimestamp());
    emit(SocialCommentLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add(commentModel.toMap())
        .then((value) {
      getPosts();
      emit(SocialCommentSuccessState());
        }).catchError((error) {

      if (kDebugMode) {
        print(error.toString());
      }
      emit(SocialCommentErrorState(error.toString()));
    });
  }
  bool isCommentImageLoading = false;
  String? commentImageURL;
  File? commentImage;
  void uploadCommentPic({
    required String? postId,
    String? commentText,
    required String? time,
    required String? date,
  }) {
    isCommentImageLoading = true;
    emit(UploadCommentPicLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(Uri.file(commentImage!.path).pathSegments.last)
        .putFile(commentImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        commentImageURL = value;
        commentPost(
          postId: postId,
          comment: commentText,
          commentImage: {
            'width' : 150,
            'image' : value,
            'height': 200
          },
          time: time,
          date: date,);
        emit(UploadCommentPicSuccessState());
        isCommentImageLoading = false;
      }).catchError((error) {
        if (kDebugMode) {
          print('Error While getDownload CommentImageURL ' + error);
        }
        emit(UploadCommentPicErrorState());
      });
    }).catchError((error) {
      if (kDebugMode) {
        print('Error While putting the File ' + error);
      }
      emit(UploadCommentPicErrorState());
    });
  }

  
  void getComments(postId) {
    emit(GetCommentLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection("comments")
        .orderBy('dateTime')
        .snapshots()
    .listen((event) {
      comments.clear();
      event.docs.forEach((element) {
       comments.add(CommentModel.fromJson(element.data()));
       emit(GetCommentSuccessState());
      });
    });
  }
  Future getCommentImage() async {
    emit(UpdatePostLoadingState());
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    print('Selecting Image...');
    if (pickedFile != null) {
      commentImage = File(pickedFile.path);
      print('Image Selected');
      emit(GetCommentPicSuccessState());
    } else {
      print('No Image Selected');
      emit(GetCommentPicErrorState());
    }
  }
  void popCommentImage() {
    commentImage = null;
    emit(DeleteCommentPicState());
  }


//message data
  String? imageURL;
  bool isMessageImageLoading = false;
  List<MessageUserModel> message = [];
  File? messageImage;

  void sendMessage({
    required String? receiverId,
    String? text,
    Map<String, dynamic>? messageImage,
    required String? time,
    required String? date,
  }) {
    MessageUserModel messageModel = MessageUserModel(
      senderId: socialUserModel!.uId,
      receiverId: receiverId,
      messageImage:messageImage ,
      text: text,
        time: time,
        date: date,
        dateTime: FieldValue.serverTimestamp()
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(socialUserModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('message')
        .add(messageModel.toMap())
        .then((value) async {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialSendMessageErrorState());
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(socialUserModel!.uId)
        .collection('message')
        .add(messageModel.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialSendMessageErrorState());
    });
  }

  void uploadMessagePic({
    String ? senderId,
    required String? receiverId,
    String? text,
    required String? time,
    required String? date,
  }) {
    isMessageImageLoading = true;
    emit(UploadMessagePicLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(Uri.file(messageImage!.path)
        .pathSegments
        .last)
        .putFile(messageImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        imageURL = value;
        sendMessage(
          receiverId: receiverId,
          text: text,
          messageImage: {
            'width': 150,
            'image': value,
            'height': 200
          },
          time: time,
          date: date,);
        emit(UploadMessagePicSuccessState());
        isMessageImageLoading = false;
      }).catchError((error) {
        print('Error While getDownloadURL ' + error);
        emit(UploadMessagePicErrorState());
      });
    }).catchError((error) {
      print('Error While putting the File ' + error);
      emit(UploadMessagePicErrorState());
    });
  }

  void getMessage( {required String receiverId})
  {
    FirebaseFirestore.instance.collection('users')
        .doc(socialUserModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('message')
        .orderBy('dateTime')
        .snapshots()
        .listen((event)
    {
     message = [];
      for (var element in event.docs) {
        message.add(MessageUserModel.fromJson(element.data()));
      }
      emit(SocialGetMessageSuccessState());


    });
  }
  Future getMessageImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      messageImage = File(pickedFile.path);
      emit(GetMessagePicSuccessState());
    } else {
      print('No Image Selected');
      emit(GetMessagePicErrorState());
    }
  }

  void popMessageImage() {
    messageImage = null;
    emit(DeleteMessagePicState());
  }





 final googleSignIn=GoogleSignIn();


  dynamic signOut(context) async {
    
    await CacheHelper.removeData(
      key: 'uId',
    ).then((value) {
      if (value) {
        navigateAndFinish(context, SocialLoginScreen());
        SocialCubit.get(context).currentIndex = 0;
      }
    });
    await googleSignIn.disconnect();
     FirebaseAuth.instance.signOut();
  }

  void setUserToken() async{
    String? token = await FirebaseMessaging.instance.getToken();
    await FirebaseFirestore.instance.collection('users').doc(socialUserModel!.uId)
        .update({'token': token})
        .then((value) => {});
        print('----------------------------==================------------');
        print(token);
        print('----------------------------==================------------');
  }

  Future getMyData() async {

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId!)
        .snapshots()
        .listen((value) async {
      socialUserModel = SocialUserModel.fromJson(value.data());
      setUserToken();

    });
  }

}

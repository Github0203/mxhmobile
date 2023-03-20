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
import 'dart:convert';



import '../../../models/social_model/LikeModel.dart';
import '../../../models/social_model/AddfriendModel.dart';
import '../../../models/social_model/FollowerModel.dart';
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
import 'package:socialapp/modules/albums/albulmModouls/models.dart';
import 'package:socialapp/shared/network/UrlTypeHelper';
import 'package:http/http.dart' as http;



class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  

  static SocialCubit get(context) => BlocProvider.of(context);

  SocialUserModel? socialUserModel = null;
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

  SocialUserModel? socialUserModelFriend = null;
  void getUserDataFriend(String? uId) {
    emit(SocialGetUserFriendLoadingState());
    uId = CacheHelper.getData(key: 'uId');
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      socialUserModelFriend = SocialUserModel.fromJson(value.data());
      if (kDebugMode) {
        print(socialUserModelFriend.toString());
      }

      emit(SocialGetUserFriendSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialGetUserFriendErrorState(error.toString()));
    });
  }

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
        updateUser(name: name, queryable: name.toLowerCase(), phone: phone, bio: bio, image: value);

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
        updateUser(name: name, queryable: name.toLowerCase(), phone: phone, bio: bio, cover: value);
      }).catchError((error) {
        emit(SocialUploadCoverErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadCoverErrorState());
    });
  }


  void updateUser({
    required String? name,
    required String? queryable,
    required String? phone,
    required String? bio,

    String? cover,
    String? image,
    List<String>? friends,
    List<FollowerModel>? followers,
  }) {
    // uploadProfileImage(name: name, phone:phone, bio:bio);
    // uploadCoverImage(name: name, phone:phone, bio:bio);

   
      // emit(SocialUploadCoverImageLoadingState());
      ((coverImage == null)) ?
     FirebaseFirestore.instance.collection('users').doc(socialUserModel!.uId)
            .update(({
          'name':name,
          'queryable':queryable,
          'phone': phone,
          'bio': bio,
          'cover': socialUserModel!.cover ?? 'https://upload.wikimedia.org/wikipedia/commons/7/75/No_image_available.png',
          'image': socialUserModel!.image ?? 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/2048px-No_image_available.svg.png',
        }))
    
    :
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
      queryable: name!.toLowerCase(),
      phone: phone,
      bio: bio,
      email: socialUserModel!.email,
      uId: socialUserModel!.uId,
      cover: value,
      image: socialUserModel!.image,

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
      profileImage == null ?
   FirebaseFirestore.instance.collection('users').doc(socialUserModel!.uId)
            .update(({
          'name':name,
          'queryable':queryable,
          'phone': phone,
          'bio': bio,
          'cover': socialUserModel!.cover ?? 'https://upload.wikimedia.org/wikipedia/commons/7/75/No_image_available.png',
          'image': socialUserModel!.image ?? 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/2048px-No_image_available.svg.png',
        }))
  :
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
      queryable: name!.toLowerCase(),
      phone: phone,
      bio: bio,
      email: socialUserModel!.email,
      uId: socialUserModel!.uId,
      cover: socialUserModel!.cover,
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

emit(SocialUserUpdateLoadingState());
 emit(SocialUserUpdateSuccessState());
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
    String? getuId,
  
  }) {
    emit(SocialCreatePostLoadingState());
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
                                print(value);
                                addsubPost(
                                  idDoc: value.id.toString(), 
                                  name:name,
                                  image:image,
                                  date: date,
                                  uId: getuId
                                );
                                
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
    String? postIDSub,
    String? uId,
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
                                type: 'posts'
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
  


    PostModelSub? getdetailpostview;
  void viewDetailPost(String idPost, String idPostSub) {
      FirebaseFirestore.instance
        .collection('posts').doc(idPost).collection('posts').doc(idPostSub)
        .snapshots()
        .listen((event) async {
      getdetailpostview=null;
      getdetailpostview = (PostModelSub.fromJson(event.data()));
      
      emit(SocialGetSubPostSuccessState());

    });

  }
    PostModelSub? getdetailpostviewImage;
  void viewDetailPostAlbum(String idPost, String idPostSub) {
      FirebaseFirestore.instance
        .collection('albumImages').doc(idPost).collection('albumImages').doc(idPostSub)
        .snapshots()
        .listen((event) async {
      getDetailSubPostAlbum(idPost);
      getdetailpostviewImage=null;
      getdetailpostviewImage = (PostModelSub.fromJson(event.data()));
      emit(SocialGetSubPostSuccessState());

    });

  }

    PostModelSub? getdetailpostviewposts;
  void viewDetailPostposts(String idPost, String idPostSub) {
      FirebaseFirestore.instance
        .collection('posts').doc(idPost).collection('posts').doc(idPostSub)
        .snapshots()
        .listen((event) async {
      getDetailSubPostAlbum(idPost);
      getdetailpostviewImage=null;
      getdetailpostviewImage = (PostModelSub.fromJson(event.data()));
      emit(SocialGetSubPostSuccessState());

    });

  }



  void getDetailSubPost(String idPost) {
      FirebaseFirestore.instance
        .collection('posts').doc(idPost).collection('posts')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((event) async {
      posts2=[];
      event.docs.forEach((element) async {
        posts2.add(PostModelSub.fromJson(element.data()));
        var likes = await element.reference.collection('likes').get();
        var comments = await element.reference.collection('comments').get();
        await FirebaseFirestore.instance.collection('posts').doc(idPost).collection('posts').doc(element.id)
            .update(({
          'likes':likes.docs.length,
          'comments':comments.docs.length,
          'postId': idPost,
          'postIdSub': element.id,
        }));
      });
      emit(SocialGetSubPostSuccessState());

    });

  }
  void getDetailSubPostAlbum(String idPost) {
      FirebaseFirestore.instance
        .collection('albumImages').doc(idPost).collection('albumImages')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((event) async {
      posts4=[];
      event.docs.forEach((element) async {
        posts4.add(PostModelSub.fromJson(element.data()));
        var likes = await element.reference.collection('likes').get();
        var comments = await element.reference.collection('comments').get();
        await FirebaseFirestore.instance.collection('albumImages').doc(idPost).collection('albumImages').doc(element.id)
            .update(({
          'likes':likes.docs.length,
          'comments':comments.docs.length,
          'postId': idPost,
          'postIdSub': element.id,
        }));
      });
      emit(SocialGetSubPostSuccessState());

    });

  }

  void getDetailPostAlbum(String idPost) {
      FirebaseFirestore.instance
        .collection('albumImages').doc(idPost).collection('albumImages')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((event) async {
      posts4=[];
      event.docs.forEach((element) async {
        posts4.add(PostModelSub.fromJson(element.data()));
        var likes = await element.reference.collection('likes').get();
        var comments = await element.reference.collection('comments').get();
        await FirebaseFirestore.instance.collection('albumImages').doc(idPost).collection('albumImages').doc(element.id)
            .update(({
          'likes':likes.docs.length,
          'comments':comments.docs.length,
          'postId': idPost,
          'postIdSub': element.id,
        }));
      });
      emit(SocialGetSubPostSuccessState());

    });

  }

  
List<LikesModel>? getpostsUserLike=[];
  void getDetailUserLikePost(String idPost) {
      FirebaseFirestore.instance
        .collection('posts').doc(idPost).collection('likes')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((event) async {
      getpostsUserLike=[];
      event.docs.forEach((element) async {
        getpostsUserLike!.add(LikesModel.fromJson(element.data()));
      print(element);
      });
      emit(SocialUserLikePostsSubSuccessState());

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
      });
      emit(SocialGetPostsSuccessState());
    });

  }

  void getPostsAlbum() {
    FirebaseFirestore.instance
        .collection('albumImages')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((event) async {
      posts3=[];
      event.docs.forEach((element) async {
        posts3.add(PostModel.fromJson(element.data()));
        var likes = await element.reference.collection('likes').get();
        var comments = await element.reference.collection('comments').get();
        await FirebaseFirestore.instance.collection('albumImages').doc(element.id)
            .update(({
          'likes':likes.docs.length,
          'comments':comments.docs.length,
          'postId': element.id,
        }));
      });
      emit(SocialGetPostsSuccessState());
    });

  }

    void addFriendCubitVoid({context, String? postId, PostModel? postModel, SocialUserModel? postUser,String?dateTime}) {
    FriendsModel addfriendModel = FriendsModel(
      uId: socialUserModel!.uId,
      name: socialUserModel!.name,
      image: socialUserModel!.image,
        dateTime: FieldValue.serverTimestamp());
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(socialUserModel!.uId)
        .set(addfriendModel.toMap())
        .then((value) {
      getPosts();

      emit(SocialLikePostsSuccessState());
    }).catchError((error) {
      emit(SocialLikePostsErrorState(error.toString()));
    });
  }

  void getPostsFriend(String? uId) {
    FirebaseFirestore.instance
        .collection('posts').where('uId', isEqualTo: uId)
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
      });
      emit(SocialGetPostsSuccessState());
    });

  }

  String likedpost = ' liked';
  String colorlikedpost = ' like';
  String likedsubpost = ' like';
  String colorlikedsubpost = ' like';

  Future<bool> likedByMe(
      {context,
        bool? liked,
        String? postId,
        PostModel? postModel,
        SocialUserModel? postUser}) async {
    emit(SocialLikePostsLoadingState());
    bool isLikedByMe = false;
    likedpost = '';
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .get()
        .then((event) async {

            var likes = await event.reference.collection('likes').where('uId', isEqualTo: socialUserModel!.uId).get();
      final List <DocumentSnapshot> documentLikes = likes.docs;
      if(documentLikes.length > 0){
        isLikedByMe = !isLikedByMe;
      documentLikes.forEach((element) {
      disLikePost(postId, element.id);      
      });
      }
      if (isLikedByMe == false) {
        likedpost = ' liked';
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

  Future<bool> likedByMeAlbum(
      {context,
        bool? liked,
        String? postId,
        PostModel? postModel,
        SocialUserModel? postUser}) async {
    emit(SocialLikePostsLoadingState());
    bool isLikedByMe = false;
    likedpost = '';
    FirebaseFirestore.instance
        .collection('albumImages')
        .doc(postId)
        .get()
        .then((event) async {

            var likes = await event.reference.collection('likes').where('uId', isEqualTo: socialUserModel!.uId).get();
      final List <DocumentSnapshot> documentLikes = likes.docs;
      if(documentLikes.length > 0){
        isLikedByMe = !isLikedByMe;
      documentLikes.forEach((element) {
      disLikePostAlbum(postId, element.id);      
      });
      }
      if (isLikedByMe == false) {
        likedpost = ' liked';
        likePostAlbum(
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

  Future<bool> likedByMeSub(
      {context,
        String? postId,
        String? postIdSub,
        SocialUserModel? postUser}) async {
    emit(SocialLikePostsLoadingState());
    bool isLikedByMe = false;
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId).collection('posts').doc(postIdSub)
        .get()
        .then((event) async {
      var likes = await event.reference.collection('likes').where('uId', isEqualTo: socialUserModel!.uId).get();
      print(socialUserModel!.uId.toString());
      final List <DocumentSnapshot> documentLikes = likes.docs;
      print(documentLikes.length);
      if(documentLikes.length > 0){
        isLikedByMe = !isLikedByMe;
      documentLikes.forEach((element) {
      disLikeSubPost(postId, postIdSub, element.id);
      });
      } 
      if (isLikedByMe == false) {
        likePostSub(
            postId: postId,
            postIdSub: postIdSub,
            context: context,
            postUser: postUser);
      }
      print(isLikedByMe);
      emit(SocialLikePostsSubSuccessState());
    });
    return isLikedByMe;
  }

  Future<bool> likedByMeSubAlbum(
      {context,
        String? postId,
        String? postIdSub,
        SocialUserModel? postUser}) async {
    emit(SocialLikePostsLoadingState());
    bool isLikedByMe = false;
    FirebaseFirestore.instance
        .collection('albumImages')
        .doc(postId).collection('albumImages').doc(postIdSub)
        .get()
        .then((event) async {
      var likes = await event.reference.collection('likes').where('uId', isEqualTo: socialUserModel!.uId).get();
      final List <DocumentSnapshot> documentLikes = likes.docs;
      if(documentLikes.length > 0){
        isLikedByMe = !isLikedByMe;
      documentLikes.forEach((element) {
      disLikeSubPostAlbum(postId, postIdSub, (element.id));      print('LLLLLLLLLLLLLLLLLL');
      });
      } 
      if (isLikedByMe == false) {
        likePostSubAlbum(
            postId: postId,
            postIdSub: postIdSub,
            context: context,
            postUser: postUser);
      }
      print(isLikedByMe);
      emit(SocialLikePostsSubSuccessState());
    });
    return isLikedByMe;
  }


 void disLikePost(String? postId, String? potIdLike) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId).collection('likes').doc(potIdLike)
        .delete()
        .then((value) {
        getPosts();
      // showToast(text: "Post Deleted", state: ToastStates.ERROR);
      emit(SocialLikePostsSubSuccessState());
    });
  }
 void disLikeSubPost(String? postId, String? postIdSub, String? potIdSubLike) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId).collection('posts').doc(postIdSub).collection('likes').doc(potIdSubLike)
        .delete()
        .then((value) {
        getDetailSubPost(postId!);
      // showToast(text: "Post Deleted", state: ToastStates.ERROR);
      emit(SocialDisLikePostsSubSuccessState());
    });
  }

void disLikePostAlbum(String? postId, String? potIdLike) {
    FirebaseFirestore.instance
        .collection('albumImages')
        .doc(postId).collection('likes').doc(potIdLike)
        .delete()
        .then((value) {
        getPostsAlbum();
      // showToast(text: "Post Deleted", state: ToastStates.ERROR);
      emit(SocialLikePostsSubSuccessState());
    });
  }

 void disLikeSubPostAlbum(String? postId, String? postIdSub, String? potIdSubLike) {
    FirebaseFirestore.instance
        .collection('albumImages')
        .doc(postId).collection('albumImages').doc(postIdSub).collection('likes').doc(potIdSubLike)
        .delete()
        .then((value) {
        getDetailPostAlbum(postId!);
      // showToast(text: "Post Deleted", state: ToastStates.ERROR);
      emit(SocialDisLikePostsSubSuccessState());
    });
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

void likePostSub({context, String? postId,String? postIdSub, SocialUserModel? postUser,String?dateTime}) {
    LikesModel likesModel = LikesModel(
      uId: socialUserModel!.uId,
      name: socialUserModel!.name,
      image: socialUserModel!.image,
        dateTime: FieldValue.serverTimestamp());
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId).collection('posts').doc(postIdSub)
        .collection('likes')
        .doc(socialUserModel!.uId)
        .set(likesModel.toMap())
        .then((value) {
      getDetailSubPost(postId!);

      emit(SocialLikePostsSubSuccessState());
    }).catchError((error) {
      emit(SocialLikePostsSubErrorState(error.toString()));
    });
  }


void likePostAlbum({context, String? postId, PostModel? postModel, SocialUserModel? postUser,String?dateTime}) {
    LikesModel likesModel = LikesModel(
      uId: socialUserModel!.uId,
      name: socialUserModel!.name,
      image: socialUserModel!.image,
        dateTime: FieldValue.serverTimestamp());
    FirebaseFirestore.instance
        .collection('albumImages')
        .doc(postId)
        .collection('likes')
        .doc(socialUserModel!.uId)
        .set(likesModel.toMap())
        .then((value) {
      getPostsAlbum();

      emit(SocialLikePostsSuccessState());
    }).catchError((error) {
      emit(SocialLikePostsErrorState(error.toString()));
    });
  }

void likePostSubAlbum({context, String? postId,String? postIdSub, SocialUserModel? postUser,String?dateTime}) {
    LikesModel likesModel = LikesModel(
      uId: socialUserModel!.uId,
      name: socialUserModel!.name,
      image: socialUserModel!.image,
        dateTime: FieldValue.serverTimestamp());
    FirebaseFirestore.instance
        .collection('albumImages')
        .doc(postId).collection('albumImages').doc(postIdSub)
        .collection('likes')
        .doc(socialUserModel!.uId)
        .set(likesModel.toMap())
        .then((value) {
      getDetailPostAlbum(postId!);

      emit(SocialLikePostsSubSuccessState());
    }).catchError((error) {
      emit(SocialLikePostsSubErrorState(error.toString()));
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

  void commentPostAlbum({
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
        .collection('albumImages')
        .doc(postId)
        .collection('comments')
        .add(commentModel.toMap())
        .then((value) {
      getPostsAlbum();
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

  void uploadCommentPicAlbum({
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
        commentPostAlbum(
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

  // uploadCommentPic sub
  void uploadCommentPicSub({
    required String? postId,
    required String? postIdSub,
    String? commentText,
    required String? time,
    required String? date,
  }) {
    isCommentImageLoading = true;
    emit(UploadCommentPicLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/post/postIdSub${Uri.file(commentImage!.path).pathSegments.last}') 
        .putFile(commentImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        commentImageURL = value;
        commentPostSub(
          postId: postId,
          postIdSub: postIdSub,
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

  void uploadCommentPicSubAlbum({
    required String? postId,
    required String? postIdSub,
    String? commentText,
    required String? time,
    required String? date,
  }) {
    isCommentImageLoading = true;
    emit(UploadCommentPicLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/album/postIdSub${Uri.file(commentImage!.path).pathSegments.last}') 
        .putFile(commentImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        commentImageURL = value;
        commentPostSubAlbum(
          postId: postId,
          postIdSub: postIdSub,
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

   void getCommentsAlbum(postId) {
    emit(GetCommentLoadingState());
    FirebaseFirestore.instance
        .collection('albumImages')
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


// commentSub data

  void commentPostSub({
    required String? postId,
    required String? postIdSub,
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
        .doc(postId).collection('posts').doc(postIdSub)
        .collection('comments')
        .add(commentModel.toMap())
        .then((value) {
      getDetailSubPost(postId!);
      emit(SocialCommentSuccessState());
        }).catchError((error) {

      if (kDebugMode) {
        print(error.toString());
      }
      emit(SocialCommentErrorState(error.toString()));
    });
  }
  

  
  void getCommentsSub(postId, postIdSub) {
    emit(GetCommentSubLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId).collection('posts').doc(postIdSub)
        .collection("comments")
        .orderBy('dateTime')
        .snapshots()
    .listen((event) {
      comments.clear();
      event.docs.forEach((element) {
       comments.add(CommentModel.fromJson(element.data()));
       emit(GetCommentSubSuccessState());
      });
    });
  }
  Future getCommentImageSub() async {
    emit(UpdatePostLoadingState());
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    print('Selecting Image...');
    if (pickedFile != null) {
      commentImage = File(pickedFile.path);
      print('Image Selected');
      emit(GetCommentPicSubSuccessState());
    } else {
      print('No Image Selected');
      emit(GetCommentPicSubErrorState());
    }
  }


  // commentSubAlbum data

  void commentPostSubAlbum({
    required String? postId,
    required String? postIdSub,
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
        .collection('albumImages')
        .doc(postId).collection('albumImages').doc(postIdSub)
        .collection('comments')
        .add(commentModel.toMap())
        .then((value) {
      getDetailSubPostAlbum(postId!);
      emit(SocialCommentSuccessState());
        }).catchError((error) {

      if (kDebugMode) {
        print(error.toString());
      }
      emit(SocialCommentErrorState(error.toString()));
    });
  }
  

  
  void getCommentsSubAlbum(postId, postIdSub) {
    emit(GetCommentSubLoadingState());
    FirebaseFirestore.instance
        .collection('albumImages')
        .doc(postId).collection('albumImages').doc(postIdSub)
        .collection("comments")
        .orderBy('dateTime')
        .snapshots()
    .listen((event) {
      comments.clear();
      event.docs.forEach((element) {
       comments.add(CommentModel.fromJson(element.data()));
       emit(GetCommentSubSuccessState());
      });
    });
  }
  Future getCommentImageSubAlbum() async {
    emit(UpdatePostLoadingState());
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    print('Selecting Image...');
    if (pickedFile != null) {
      commentImage = File(pickedFile.path);
      print('Image Selected');
      emit(GetCommentPicSubSuccessState());
    } else {
      print('No Image Selected');
      emit(GetCommentPicSubErrorState());
    }
  }


  // void popCommentImageSub() {
  //   commentImage = null;
  //   emit(DeleteCommentPicState());
  // }

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
        .doc(socialUserModel!.uId)
        .snapshots()
        .listen((value) async {
      socialUserModel = SocialUserModel.fromJson(value.data());
      setUserToken(); 

    });
  }

  void createPostAlbumImage({
    String? name,
    String? nameAlbum,
    String? image,
    String? postText,
    String? date,
    // String? postImage1,
    String? time,
    // List<PlatformFile>? listMedia,
    List<PostModelSub>? subPost,
    List? tag,
    String? like,
    String? des,
  }) {
    emit(SocialCreateAlbumLoadingState());
   PostModel model = PostModel(
                                  name:name,
                                  uId: socialUserModel!.uId,
                                  image:image,
                                  nameAlbum: nameAlbum,
                                  likes: 0,
                                  comments: 0,
                                  date: date,
                                  time: time,
                                  dateTime: FieldValue.serverTimestamp(),
                                  tags: tag,
                                  des: des,
                                  // subPost: toList1(),
                                );
                                // print('model cua subPost laf ------------>  ' + model.uId.toString());
                            FirebaseFirestore.instance
                                  .collection('albumImages')
                                  .add(model.toMap())
                                  .then((value) async{      
                                print(value);
                                addsubPostAlbumImage(
                                  idDoc: value.id.toString(),
                                  name:name,
                                  image:image,
                                  date: date,
                                  uId: socialUserModel!.uId!,
                                );
                                
                                print('đã lưu vào firestore');
                                // paths = null;
                                print('55555555555555555555555555 gia tri cua postImage sau khi dat bang null la : --------------->' + value.id.toString());
                                emit(SocialCreateAlbumSuccessState());

                              }).catchError((error) {
                                emit(SocialCreateAlbumErrorState());
                              });
  }

  void addsubPostAlbumImage({
    String? idDoc,
    String? name,
    String? image,
    String? postText,
    String? date,
    String? postImage1,
    String? postIDSub,
    String? uId,
  }){

paths!.forEach((i) {
        firebase_storage.FirebaseStorage.instance
                    .ref()
                    .child('users/'+ uId! + '/albumImage/${Uri
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
                                type: 'albumImages'
                                // postIdSub: postIDSub,
                              );
                                     FirebaseFirestore.instance
                                    .collection('albumImages')
                                    .doc(idDoc)
                                    .collection('albumImages')
                                    .add(modelSub.toMap())
                                    .then((value) async{
             
                                      print('THÊM SUBPOST THÀNH CÔNG');
                                 emit(SocialAddSubAlbumSuccessState());
                                    }).catchError((error) {

                                  if (kDebugMode) {
                                    print(error.toString());
                                  }
                                  emit(SocialAddSubAlbumErrorState());
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


void getAllAlbumImage() {
   

  }

   List<ImageBean> imageList = [];
   List<String> urlList = [];
    List<PostModel> posts3 = [];
  List<PostModelSub> posts4 = [];
    int solist = 0;
  List<ImageBean> getImageDataCubut() {
// print('TTTTTTTTTTTTTT');

     FirebaseFirestore.instance
        .collection('albumImages')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((event) async {
         
      posts3=[];
      event.docs.forEach((element) async {
        posts3.add(PostModel.fromJson(element.data()));

        var likes = await element.reference.collection('likes').get();
        var comments = await element.reference.collection('comments').get();
        await FirebaseFirestore.instance.collection('albumImages').doc(element.id)
            .update(({
          'likes':likes.docs.length,
          'comments':comments.docs.length,
          'postId': element.id,
        }));
      // print(element.id);





    

        // add post 2
         FirebaseFirestore.instance
        .collection('albumImages').doc(element.id.toString()).collection('albumImages')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((event1) async {
      posts4=[];
      event1.docs.forEach((element1) async {
        posts4.add(PostModelSub.fromJson(element1.data()));
        var likes = await element1.reference.collection('likes').get();
        var comments = await element1.reference.collection('comments').get();
        await FirebaseFirestore.instance.collection('albumImages').doc(element.id.toString()).collection('albumImages').doc(element1.id)
            .update(({
          'likes':likes.docs.length,
          'comments':comments.docs.length,
          'postId': element.id,
          'postIdSub': element1.id,
        }));

        // await FirebaseFirestore.instance.collection('albumImages').doc(element.id.toString()).collection('subPost').doc(element1.id).get();
        // final List <DocumentSnapshot> documentsubPost = resultFriend.docs;
        final QuerySnapshot resulsubPost =
    await FirebaseFirestore.instance.collection('albumImages').where('uId', isEqualTo: socialUserModel!.uId).get();

    final List <DocumentSnapshot> resulsubPostDOCS = resulsubPost.docs;

    solist = resulsubPostDOCS.length;
           

       
      emit(LoadAlbumLevel1SuccessState());


        
      
      urlList = [];
      posts4.forEach((i) {
        urlList.add(i.postImage.toString());
      });

      print(urlList);

    imageList = [];
    for (int i = 0; i < urlList.length; i++) {
      String url = urlList[i];
      imageList.add(ImageBean(
        originPath: url,
        middlePath: url,
        thumbPath: url,
        originalWidth: i == 0 ? 264 : null,
        originalHeight: i == 0 ? 258 : null,
      ));
    }
    emit(GetThumbnailPathAlbumSuccessState());
      // print(imageList);
      //    print('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');
      //   print(element1.id.toString());
      });
    });
    // ket thuc add post2
      });
    });

    emit(LoadAlbumLevel2SuccessState());
    print('TTTTTTTTTTTTTT1111111');
    return imageList;
  }

  void getDetailAlbumImages(String? idAlbum) {
      FirebaseFirestore.instance
        .collection('albumImages').doc(idAlbum).collection('albumImages')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((event) async {
      posts4=[];
      event.docs.forEach((element) async {
        posts4.add(PostModelSub.fromJson(element.data()));
        var likes = await element.reference.collection('likes').get();
        var comments = await element.reference.collection('comments').get();
        await FirebaseFirestore.instance.collection('albumImages').doc(idAlbum).collection('albumImages').doc(element.id)
            .update(({
          'likes':likes.docs.length,
          'comments':comments.docs.length,
          'postIdSub': element.id,
        }));
      });
      emit(SocialAllPhotosSuccessState());

    });

  }


   

////////////// FOLLOWING
    bool checkfollow = false;
    void checkFollowing(
      String? getuIdfriend, 
      // String? uIdFriend, 
      SocialUserModel? userModelMine, 
      String? dateTime) async{
    
    // checkfollow = false;
    final QuerySnapshot resultFollows =
    await FirebaseFirestore.instance.collection('users').doc(getuIdfriend).collection('followers').where('uId', isEqualTo: 
    userModelMine!.uId).get();
    print('aaaaaaaaaaaaaaa follow');
    print(getuIdfriend);
    print('bbbbbbbbbbbbbbb follow');
    print(userModelMine.uId);
    final List <DocumentSnapshot> documentFollows = resultFollows.docs;
    if (documentFollows.length > 0 ) { 
        print('da follow checkfollow la');
        checkfollow = false;
        getFollowings(getuIdfriend);
        print(checkfollow);
        emit(UnFriendsSuccessState());
      } else {  
      print('chua follow checkfollow la');
        checkfollow = true;
        print(checkfollow);
        getFollowings(getuIdfriend);
        emit(AddFriendsLoadingState());
      }
emit(CheckFollowerSuccessState());
  }

List<FollowerModel>? followModel = [];
String? getIDFollow;
Future<void> Addfollower({SocialUserModel? userModelFriend,String? dateTime}) async{
    checkfollow = false;
    // getIDFollow = '';
    FollowerModel followModel = FollowerModel(
      uId: socialUserModel!.uId,
      name: socialUserModel!.name,
      image: socialUserModel!.image,
      dateTime: FieldValue.serverTimestamp());
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModelFriend!.uId)
        .collection('followers')
        .add(followModel.toMap())
        .then((value) {
        emit(AddFollowerSuccessState());
        getFollowings(userModelFriend.uId.toString());
        }).catchError((error) {
          
      if (kDebugMode) {
        print(error.toString());
      }
    
    });
  }

    void unFollowing(String? idFriend, String? idFlower) {
      checkfollow = true;
    FirebaseFirestore.instance
        .collection('users')
        .doc(idFriend).collection('followers').doc(idFlower)
        .delete()
        .then((value) {
      // showToast(text: "Post Deleted", state: ToastStates.ERROR);
      print('da unfollow');
      emit(UnFollowerSuccessState());
    });
  }

  void getFollowings(String? uIdFriend, ) {
    // checkfollow = ! checkfollow;
    FirebaseFirestore.instance
        .collection('users').doc(uIdFriend).collection('followers')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((event) async {
      followModel=[];
      event.docs.forEach((element) async {
        followModel!.add(FollowerModel.fromJson(element.data()));
        getIDFollow = '';
        getIDFollow = element.id;
        // var likes = await element.reference.collection('likes').get();
        // var comments = await element.reference.collection('comments').get();
        await FirebaseFirestore.instance.collection('users').doc(uIdFriend).collection('followers').doc(element.id)
            .update(({
          'idFollwer': element.id,
        }));
      });
      emit(GetFollowerSuccessState());
    });

  }



 ////////////// ADD FRIEND FROM FRIEND
    bool checkfriend = false;
    bool checkme = false;
    String? accept;
    bool showbuttonAddFriend = false;
    String?  checkRequirer;
    void checkREQUIREDFRIEND(
      String? getuIdfriend,  
      // String? uIdFriend, 
      SocialUserModel? userModelMine, 
      String? dateTime) async{
      showbuttonAddFriend = false;
      // checkme = false;
      // checkfriend = false;
      accept = '';
      checkRequirer = '';
      

    
    // check friend = false
       //// check da gui loi moi ket ban chua
    await FirebaseFirestore.instance.collection('users')
      .doc(socialUserModel!.uId).collection('friends')
      .get()
      .then((QuerySnapshot snapshot) {
    final docs = snapshot.docs;
    for (var data in docs) {  
       if(data['uId'] == getuIdfriend){
            print('minh da ket ban roi nhe hihihihihihih');
            showbuttonAddFriend = true;
            print('PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPaccepted');
      print(data['accepted']);
     if(data['accepted'] == null)
     {
      accept = 'Waiting';
      checkRequirer = data['requirer'];

     }
     else
     {
      accept = data['accepted'];
     }
       }
       if(data['uId'] != getuIdfriend){
        checkme = true;
      checkfriend = true;
        print('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');
        print('minh chua ket ban dau');
        print('check friend la      :' + checkfriend.toString());
        print('check me la      :' + checkme.toString());
       }
      
   
    }
    emit(CheckAcceptSuccessState());
  });
   
        print('FEEEEEEEEEEEEEEEEEEEEEEEEEEEEE');
        print(checkRequirer);

    /// check da la ban hay chua phia toi
    final QuerySnapshot resultFriendPhiaMinh =
    await FirebaseFirestore.instance.collection('users').doc(userModelMine!.uId).collection('friends').where('uId', isEqualTo: 
    getuIdfriend).get();
    final List <DocumentSnapshot> documentFriendsme = resultFriendPhiaMinh.docs;
    print('88888888888888888888888888888888888888888888888888888888888888');
    print(accept);
    print(documentFriendsme.length);
     if (documentFriendsme.length <= 0){  
      print('toi chua add friend la');
        checkme = true;
        print(checkme);
        print(accept);
        getFRIEND(getuIdfriend);
        emit(GetFriendsSuccessState());
        // emit(AddFriendsLoadingState());
      }
    if ((documentFriendsme.length > 0) && (accept == 'Waiting') ) { 
        print('cho chap nhan ket ban, set check friend la');
        checkme = false;
        getFRIEND(getuIdfriend);
        // acceptFRIEND(getuIdfriend);
        print(checkme);
        emit(GetFriendsSuccessState());
        // emit(UnFriendsSuccessState());
      } 
      if ((documentFriendsme.length > 0) && (accept == 'yes') ) { 
        print('ca 2 da la ban');
        checkme = false;
        showbuttonAddFriend = true;
        // getFRIEND(getuIdfriend);
        // acceptFRIEND(getuIdfriend);
        print(checkme);
        print(showbuttonAddFriend);
        emit(GetFriendsSuccessState());
        // emit(UnFriendsSuccessState());
      }
      


      /////// check da la ban hay chua phia friend
    final QuerySnapshot resultFriend =
    await FirebaseFirestore.instance.collection('users').doc(getuIdfriend).collection('friends').where('uId', isEqualTo: 
    getuIdfriend).get();
    final List <DocumentSnapshot> documentFriends = resultFriendPhiaMinh.docs;
    if (documentFriends.length <= 0){ 
      print('ban toi chua add friend la');
        checkfriend = true;
        print(checkfriend);
        print(accept);
        getFRIEND(getuIdfriend);
        emit(GetFriendsSuccessState());
        // emit(AddFriendsLoadingState());
      }
    if ((documentFriends.length > 0) && (accept == 'Waiting') ) { 
        print('cho chap nhan ket ban tu phia friend, set check friend la');
        checkfriend = false;
        getFRIEND(getuIdfriend);
        // acceptFRIEND(getuIdfriend);
        print(checkfriend);
        emit(GetFriendsSuccessState());
        // emit(UnFriendsSuccessState());
      } 
      if ((documentFriends.length > 0) && (accept == 'yes') ) { 
        print('cho chap nhan ket ban, set check friend la');
        checkfriend = false;
        getFRIEND(getuIdfriend);
        // acceptFRIEND(getuIdfriend);
        // print(bothFriend);
        emit(GetFriendsSuccessState());
        // emit(UnFriendsSuccessState());
      }
      

      // if(checkfriend && checkme){
      //   bothFriend = true;
      // }
      //   {
      //     bothFriend = false;
      //   }
  }

List<FriendsModel>? friendModel = [];
String? getIDFriend;
Future<void> AddFRIEND({SocialUserModel? userModelFriend,String? dateTime}) async{
    checkfriend = false;
    checkme = false;
    showbuttonAddFriend = true;
    checkRequirer = 'yes';
    // getIDFollow = '';

    /// them friend tu phia ban
    FriendsModel friendModel = FriendsModel(
      uId: socialUserModel!.uId,
      name: socialUserModel!.name,
      image: socialUserModel!.image,
      dateTime: FieldValue.serverTimestamp());
      print(userModelFriend!.uId);
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModelFriend.uId)
        .collection('friends')
        .add(friendModel.toMap())
        .then((value) {
        emit(AddFriendsSuccessState());
        getFRIEND(userModelFriend.uId.toString());
        }).catchError((error) {
          
      if (kDebugMode) {
        print(error.toString());
      }
    });

    /// them friend tu phia toi
    FriendsModel friendModelMe = FriendsModel(
      uId: userModelFriend.uId,
      name: socialUserModel!.name,
      image: socialUserModel!.image,
      requirer: 'yes',
      dateTime: FieldValue.serverTimestamp());
      print(socialUserModel!.uId);
    FirebaseFirestore.instance
        .collection('users')
        .doc(socialUserModel!.uId)
        .collection('friends')
        .add(friendModelMe.toMap())
        .then((value) {
        emit(AddFriendsSuccessState());
        getFRIENDfromme();
        }).catchError((error) {
          
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }

  

    String? getidCollectionFriend;
    void unFRIEND(String? idUserFriend,) async{
      checkfriend = true;
      checkme = true;
      showbuttonAddFriend = false;
      getidCollectionFriend = '';

      ////// get idFriendCollention phia ban
      String? getfieldidFriendtuphiaban;
    await FirebaseFirestore.instance.collection('users')
      .doc(idUserFriend).collection('friends').where('uId', isEqualTo: socialUserModel!.uId)
      .get()
      .then((QuerySnapshot snapshot) {
    final docs = snapshot.docs;
    for (var data in docs) {  
      
      print('PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP-----------------');
      print(data['idFriend']);
     if(data['idFriend'] == null)
     {
      getfieldidFriendtuphiaban = '';
     }
     else
     {
      getfieldidFriendtuphiaban = data['idFriend'];
     }
    }
      });

    ////// get idFriendCollention phia toi
    String? getfieldidFriendtuphiatoi;
    await FirebaseFirestore.instance.collection('users')
      .doc(socialUserModel!.uId).collection('friends').where('uId', isEqualTo: idUserFriend)
      .get()
      .then((QuerySnapshot snapshot) {
    final docs = snapshot.docs;
    for (var data in docs) {  
      
      print('PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP-----------------');
      print(data['idFriend']);
     if(data['idFriend'] == null)
     {
      getfieldidFriendtuphiatoi = '';
     }
     else
     {
      getfieldidFriendtuphiatoi = data['idFriend'];
     }
    }
      });

      print('getfieldidFriendtuphiatoi');
      print(getfieldidFriendtuphiatoi);
      FirebaseFirestore.instance
        .collection('users')
        .doc(socialUserModel!.uId).collection('friends').doc(getfieldidFriendtuphiatoi)
        .delete()
        .then((value) {
      // showToast(text: "Post Deleted", state: ToastStates.ERROR);
      print('da unfollow tu phia toi');
      emit(UnFriendsSuccessState());
    });

    print('getfieldidFriendtuphiaban');
      print(getfieldidFriendtuphiaban);
    FirebaseFirestore.instance
        .collection('users')
        .doc(idUserFriend).collection('friends').doc(getfieldidFriendtuphiaban)
        .delete()
        .then((value) {
      // showToast(text: "Post Deleted", state: ToastStates.ERROR);
      print('da unfollow tu phia ban be');
      emit(UnFriendsSuccessState());
    });
  
  }

    

    

  void getFRIEND(String? uIdFriend, ) {
    // checkfriend = ! checkfriend;
    FirebaseFirestore.instance
        .collection('users').doc(uIdFriend).collection('friends')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((event) async {
      friendModel=[];
      event.docs.forEach((element) async {
        friendModel!.add(FriendsModel.fromJson(element.data()));
        getIDFriend = '';
        getIDFriend = element.id;
        // var likes = await element.reference.collection('likes').get();
        // var comments = await element.reference.collection('comments').get();
        await FirebaseFirestore.instance.collection('users').doc(uIdFriend).collection('friends').doc(element.id)
            .update(({
          'idFriend': element.id,
        }));
      });
      emit(GetFriendsSuccessState());
    });

  }

  void getFRIENDfromme() {
    // checkfriend = ! checkfriend;
    FirebaseFirestore.instance
        .collection('users').doc(socialUserModel!.uId).collection('friends')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((event) async {
      friendModel=[];
      event.docs.forEach((element) async {
        friendModel!.add(FriendsModel.fromJson(element.data()));
        getIDFriend = '';
        getIDFriend = element.id;
        // var likes = await element.reference.collection('likes').get();
        // var comments = await element.reference.collection('comments').get();
        await FirebaseFirestore.instance.collection('users').doc(socialUserModel!.uId).collection('friends').doc(element.id)
            .update(({
          'idFriend': element.id,
        }));
      });
      emit(GetFriendsSuccessState());
    });

  }

 
  void acceptFRIEND(String? uIdFriend, ) async{
    // checkfriend = ! checkfriend;
    ///// accept tu phia toi
    ///
    checkRequirer = '';
    accept = 'yes';
    await FirebaseFirestore.instance.collection('users')
      .doc(socialUserModel!.uId).collection('friends')
      .get()
      .then((QuerySnapshot snapshot) async{
    final docs = snapshot.docs;
    for (var data in docs) {  
   
       if(data['uId'] == uIdFriend){
        await FirebaseFirestore.instance.collection('users').doc(socialUserModel!.uId).collection('friends').doc(data['idFriend'])
            .update(({
          'accepted': 'yes',
        }));
       }
       print('đã ACCEPTED');
      showbuttonAddFriend = true;
       print('check nut them nếu true thì ẩn, nếu false thì hiện         :' + showbuttonAddFriend.toString());

    }
    emit(GetFriendsSuccessState());
  });


   

    ///// accept tu phia ban minh
     await FirebaseFirestore.instance.collection('users')
      .doc(uIdFriend).collection('friends')
      .get()
      .then((QuerySnapshot snapshot) async{
    final docs = snapshot.docs;
    for (var data in docs) {  
       if(data['uId'] == socialUserModel!.uId){
        await FirebaseFirestore.instance.collection('users').doc(uIdFriend).collection('friends').doc(data['idFriend'])
            .update(({
          'accepted': 'yes',
        }));
       }
   
    }
    emit(GetFriendsSuccessState());
  });

  }
  void updateFRIEND(String? uIdFriend, ) {
    // checkfriend = ! checkfriend;
    FirebaseFirestore.instance
        .collection('users').doc(uIdFriend).collection('friends')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((event) async {
      friendModel=[];
      event.docs.forEach((element) async {
        friendModel!.add(FriendsModel.fromJson(element.data()));
        getIDFriend = '';
        getIDFriend = element.id;
        // var likes = await element.reference.collection('likes').get();
        // var comments = await element.reference.collection('comments').get();
        await FirebaseFirestore.instance.collection('users').doc(uIdFriend).collection('friends').doc(element.id)
            .update(({
          'accepred': 'yes',
        }));
      });
      emit(GetFriendsSuccessState());
    });

  }


  //// get all 
  
    List<SocialUserModel>? userToken;
    void getAllUsersToken() async{
    userToken = [];
    {
    //   await FirebaseFirestore.instance.collection('users').where('uId', isEqualTo: 
    // userModelMine!.uId).get();
    // print('aaaaaaaaaaaaaaa');
    // print(getuIdfriend);
    // print('bbbbbbbbbbbbbbb');
    // print(userModelMine.uId);
    // final List <DocumentSnapshot> documentFriends = resultFriend.docs;

      FirebaseFirestore.instance.collection('users').where('token').get().then((value) {
        for (var element in value.docs) {
          // if (element.data()['uId'] != socialUserModel!.uId)
          userToken!.add(SocialUserModel.fromJson(element.data()));
        }
        print('INNNNNNNNNNNNNNNNNN TOKENS');
        userToken!.forEach((e){
        print(e.token.toString());
          
        });
      }).catchError((error) {
        emit(SocialGetAllUserTokenErrorState(error.toString()));
      });
    }
  }

  void getAllUsersTokenAPersonal(String? uIdFriend) async{
    userToken = [];
    {
    //   await FirebaseFirestore.instance.collection('users').where('uId', isEqualTo: 
    // userModelMine!.uId).get();
    // print('aaaaaaaaaaaaaaa');
    // print(getuIdfriend);
    // print('bbbbbbbbbbbbbbb');
    // print(userModelMine.uId);
    // final List <DocumentSnapshot> documentFriends = resultFriend.docs;

      FirebaseFirestore.instance.collection('users').where('token', isEqualTo: uIdFriend).get().then((value) {
        for (var element in value.docs) {
          // if (element.data()['uId'] != socialUserModel!.uId)
          userToken!.add(SocialUserModel.fromJson(element.data()));
        }
        print('INNNNNNNNNNNNNNNNNN TOKENS');
        userToken!.forEach((e){
        print(e.token.toString());
          
        });
      }).catchError((error) {
        emit(SocialGetAllUserTokenErrorState(error.toString()));
      });
    }
  }



  //////////// Video
  List<PostModelSub> subpostVideos = [];
  List<PostModelSub> subpostVideosPost = [];
  List<PostModelSub> newListVideo = [];
  Future<void> getAllVideos() 
async {
  subpostVideos = [];
   await FirebaseFirestore.instance
      .collectionGroup('albumImages')
      .get()
      .then((QuerySnapshot snapshot) {
    final docs = snapshot.docs;
    for (var data in docs) {  
      
      print('PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP');
      print(data['postImage']);
      // print(data.data());
      // print(data.reference);
      // FirebaseFirestore.instance.collectionGroup('name_of_subcollection').snapshots();
      // subpostVideos.add(PostModelSub.fromJson(data.data()));
      if( UrlTypeHelper.getType(data['postImage']) == UrlType.VIDEO){
      var map = Map<String, dynamic>.from(data.data() as Map<dynamic, dynamic>);
      print(map);
      // subpostVideos = [];
      
      subpostVideos.add(PostModelSub.fromJson(map));
      }
    }
    emit(SocialGetAllVideoSuccessState());
  });

  subpostVideosPost = [];
   await FirebaseFirestore.instance
      .collectionGroup('posts')
      .get()
      .then((QuerySnapshot snapshot) {
    final docs = snapshot.docs;
    for (var data in docs) {  
      
      print('PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP');
      print(data['postImage']);
      // print(data.data());
      // print(data.reference);
      // FirebaseFirestore.instance.collectionGroup('name_of_subcollection').snapshots();
      // subpostVideos.add(PostModelSub.fromJson(data.data()));
      if( UrlTypeHelper.getType(data['postImage']) == UrlType.VIDEO){
      var map = Map<String, dynamic>.from(data.data() as Map<dynamic, dynamic>);
      print(map);
      // subpostVideos = [];
      
      subpostVideosPost.add(PostModelSub.fromJson(map));
      }
    }
    emit(SocialGetAllVideoSuccessState());
  });

  newListVideo = [...subpostVideos, ...subpostVideosPost];
}


//////////// send thong bao
void sendPushMessageFriendRequire(String tokenFriend, String title, String body, String? getiduserModel, ) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String> {
          'Content-Type' : 'application/json',
          'Authorization' : 'key=AAAA_6ThQEw:APA91bF3k5gIqjFI_mglwHuTpuf4Hc6qQcpTwVDp7SnKW-462zCuGQ0aZcnSgmLWODombfk2dVLmL6TamIsMPzUPjA27SbQBUKRQVQYS5oce9TLHYN2FsKE-_K3TZf0a-Xhv8vwMZ7c7',
        },
        body: jsonEncode(
          <String, dynamic> {
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'body': body,
              'title': title,
              'idUserFriend': getiduserModel,
            },
          
            "notification": <String, dynamic> {
              "title": title,
              "body": getiduserModel,
              "android_channel_id": "dbfood",
              'idUserFriend': getiduserModel            },
            "to": tokenFriend,
            
          }
        )
      );
    } catch (e) {
      print("push notification error $e");
    }
    emit(SendNotifiSuccessState());
  }


}
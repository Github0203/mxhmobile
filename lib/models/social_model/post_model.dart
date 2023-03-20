


import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:socialapp/models/social_model/post_model_sub.dart';
import 'media_model.dart';

class PostModel {
  String? name;
  String? text;
  List? tags;
  List<PostModelSub>? albumImages;
  List<PostModelSub>? posts;
  String? postImage;
  String? uId;
  String? image;
  int? likes;
  int? comments;
  String? postId;
  String? date;
  String? time;
  String? nameAlbum;
  String? des;
  FieldValue? dateTime;


  PostModel({
    this.name,
    this.nameAlbum,
    this.des,
    this.text,
    this.likes,
    this.image,
    this.comments,
    this.uId,
    this.postImage,
    this.postId,
    this.time,
    this.date,
    this.dateTime,
    this.tags,
    this.albumImages,
    this.posts,
   
  });

  PostModel.fromJson(Map<String, dynamic>? json) {
    name = json!['name'];
    nameAlbum = json['nameAlbum'];
    des = json['des'];
    text = json['text'];
    likes = json['likes'];
    comments = json['comments'];
    postId = json['postId'];
    uId = json['uId'];
    image = json['image'];
    postImage = json['postImage'];
    time = json['time'];
    date = json['date'];
    tags = json['tags'];
    albumImages = json['albumImages'];
    albumImages = json['posts'];
   


  }





  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'nameAlbum': nameAlbum,
      'des': des,
      'text': text,
      'comments': comments,
      'likes': likes,
      'postId': postId,
      'uId': uId,
      'image': image,
      'postImage': postImage,
      'time':time,
      'date': date,
      'dateTime': dateTime,
      'tags': tags,
      'albumImages': albumImages,
    
    };
  }
}

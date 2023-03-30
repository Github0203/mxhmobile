


import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:socialapp/models/social_model/post_model_sub.dart';
import 'media_model.dart';

class PostModel {
  String? name;
  String? text;
  String? textTemp;
  List? tags;
  List? tagsTemp;
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
  String? nameAlbumTemp;
  String? des;
  String? desTemp;
  FieldValue? dateTime;
  FieldValue? unfollowing;


  PostModel({
    this.name,
    this.nameAlbum,
    this.nameAlbumTemp,
    this.des,
    this.desTemp,
    this.text,
    this.textTemp,
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
    this.tagsTemp,
    this.albumImages,
    this.posts,
   
  });

  PostModel.fromJson(Map<String, dynamic>? json) {
    name = json!['name'];
    nameAlbum = json['nameAlbum'];
    nameAlbumTemp = json['nameAlbumTemp'];
    des = json['des'];
    desTemp = json['desTemp'];
    text = json['text'];
    textTemp = json['textTemp'];
    likes = json['likes'];
    comments = json['comments'];
    postId = json['postId'];
    uId = json['uId'];
    image = json['image'];
    postImage = json['postImage'];
    time = json['time'];
    date = json['date'];
    tags = json['tags'];
    tagsTemp = json['tagsTemp'];
    albumImages = json['albumImages'];
    albumImages = json['posts'];
   


  }





  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'nameAlbum': nameAlbum,
      'nameAlbumTemp': nameAlbumTemp,
      'des': des,
      'desTemp': desTemp,
      'text': text,
      'textTemp': textTemp,
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
      'tagsTemp': tagsTemp,
      'albumImages': albumImages,
    
    };
  }
}

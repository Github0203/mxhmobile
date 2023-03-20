


import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'media_model.dart';

class PostModelSub {
  String? name;
  String? text;
  List? tags;
  String? postImage;
  String? uId;
  String? image;
  int? likes;
  int? comments;
  String? postId;
  String? postIdSub;
  String? date;
  String? time;
  FieldValue? dateTime;
  String? type;


  PostModelSub({
    this.name,
    this.text,
    this.likes,
    this.image,
    this.comments,
    this.uId,
    this.postImage,
    this.postId,
    this.postIdSub,
    this.time,
    this.date,
    this.dateTime,
    this.tags,
    this.type,
  });

  PostModelSub.fromJson(Map<String, dynamic>? json) {
    name = json!['name'];
    text = json['text'];
    likes = json['likes'];
    comments = json['comments'];
    postId = json['postId'];
    postIdSub = json['postIdSub'];
    uId = json['uId'];
    image = json['image'];
    postImage = json['postImage'];
    time = json['time'];
    date = json['date'];
    tags = json['tags'];
    type = json['type'];


  }





  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'text': text,
      'comments': comments,
      'likes': likes,
      'postId': postId,
      'postIdSub': postIdSub,
      'uId': uId,
      'image': image,
      'postImage': postImage,
      'time':time,
      'date': date,
      'dateTime': dateTime,
      'tags': tags,
      'type': type,
    };
  }
}

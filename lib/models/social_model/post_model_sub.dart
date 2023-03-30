


import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'media_model.dart';

class PostModelSub {
  String? name;
  String? text;
  String? textTemp;
  List? tags;
  List? tagsTemp;
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
  String? display;


  PostModelSub({
    this.name,
    this.text,
    this.textTemp,
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
    this.tagsTemp,
    this.type,
    this.display,
  });

  PostModelSub.fromJson(Map<String, dynamic>? json) {
    name = json!['name'];
    likes = json['likes'];
    text = json['text'];
    textTemp = json['textTemp'];
    comments = json['comments'];
    postId = json['postId'];
    postIdSub = json['postIdSub'];
    uId = json['uId'];
    image = json['image'];
    postImage = json['postImage'];
    time = json['time'];
    date = json['date'];
    tags = json['tags'];
    tagsTemp = json['tagsTemp'];
    type = json['type'];
    type = json['display'];


  }





  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'text': text,
      'textTemp': textTemp,
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
      'tagsTemp': tagsTemp,
      'type': type,
      'display': display,
    };
  }
}

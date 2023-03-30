
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendsModel
{
  String?uId;
  String? name;
  String? image;
  String? idFriend;
  FieldValue? dateTime;
  String? date;
  String? time;
  String? accepted;
  String? requirer;


  FriendsModel({
    this.uId,
    this.name,
    this.image,
    this.idFriend,
    this.dateTime,
    this.date,
    this.time,
    this.accepted,
    this.requirer,
  });

  FriendsModel.fromJson(Map<String, dynamic>? json){
    uId = json!['uId'];
    name = json['name'];
    idFriend = json['idFriend'];
    date = json['date'];
    time = json['time'];
    image = json['image'];
    accepted = json['accepted'];
    requirer = json['requirer'];
  }

  Map<String, dynamic> toMap (){
    return {
      'uId' : uId,
      'name':name,
      'image':image,
      'idFriend':idFriend,
      'dateTime':dateTime,
      'date':date,
      'time':time,
      'accepted':accepted,
      'requirer':requirer,

    };
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class FollowerModel
{
  String?uId;
  String? name;
  String? image;
  FieldValue? dateTime;
  String? idFollwer;


  FollowerModel({
    this.uId,
    this.name,
    this.image,
    this.dateTime,
    this.idFollwer,
  });

  FollowerModel.fromJson(Map<String, dynamic>? json){
    uId = json!['uId'];
    name = json['name'];
    image = json['image'];
    idFollwer = json['idFollwer'];
  }

  Map<String, dynamic> toMap (){
    return {
      'uId' : uId,
      'name':name,
      'image':image,
      'dateTime':dateTime,
      'idFollwer':idFollwer,

    };
  }
}
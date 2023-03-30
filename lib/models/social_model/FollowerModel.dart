
import 'package:cloud_firestore/cloud_firestore.dart';

class FollowerModel
{
  String?uId;
  String? name;
  String? image;
  FieldValue? dateTime;
  String? date;
  String? time;
  String? idFollwer;


  FollowerModel({
    this.uId,
    this.name,
    this.image,
    this.dateTime,
    this.idFollwer,
    this.date,
    this.time,
  });

  FollowerModel.fromJson(Map<String, dynamic>? json){
    uId = json!['uId'];
    name = json['name'];
    image = json['image'];
    idFollwer = json['idFollwer'];
    date = json['date'];
    time = json['time'];
  }

  Map<String, dynamic> toMap (){
    return {
      'uId' : uId,
      'name':name,
      'image':image,
      'dateTime':dateTime,
      'idFollwer':idFollwer,
      'date':date,
      'time':time,

    };
  }
}
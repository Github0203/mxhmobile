
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel
{
  String? uIdReciver; 
  String? uIdSender; 
  String? name;
  String? queryable;
  String? image;
  FieldValue? dateTime;
  String? pageto;
  String? data1;
  String? data2;
  String? data3;
  String? title;
  String? body;
  String? seen;
  String? type;
  String? display;
  String? date;
  String? time;
  String? iDNotification;


  NotificationModel({
    this.uIdReciver,
    this.uIdSender,
    this.name,
    this.queryable,
    this.image,
    this.dateTime,
    this.pageto,
    this.data1,
    this.data2,
    this.data3,
    this.title,
    this.body,
    this.seen,
    this.type,
    this.display,
    this.date,
    this.time,
    this.iDNotification,
  });

  NotificationModel.fromJson(Map<String, dynamic>? json){
    uIdReciver = json!['uIdReciver'];
    uIdSender = json['uIdSender'];
    name = json['name'];
    queryable = json['queryable'];
    image = json['image'];
    pageto = json['pageto'];
    data1 = json['data1'];
    data2 = json['data2'];
    data3 = json['data3'];
    title = json['title'];
    body = json['body'];
    seen = json['seen'];
    type = json['type'];
    display = json['display'];
    date = json['date'];
    time = json['time'];
    iDNotification = json['iDNotification'];
  }

  Map<String, dynamic> toMap (){
    return {
      'uIdReciver' : uIdReciver,
      'uIdSender' : uIdSender,
      'name':name,
      'image':image,
      'dateTime':dateTime,
      'pageto':pageto,
      'data1':data1,
      'data2':data2,
      'data3':data3,
      'title':title,
      'body':body,
      'seen':seen,
      'type':type,
      'display':display,
      'date':date,
      'time':time,
      'iDNotification':iDNotification,
      'queryable':queryable,

    };
  }
}
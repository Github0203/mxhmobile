import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  final String notificationInfo;
  const NotificationScreen({ Key? key, required this.notificationInfo }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firebase Messaging"),
      ),
      body: Center(
        child: Text(notificationInfo),
      ),
    );
  }
}
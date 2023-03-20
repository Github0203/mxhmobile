import 'package:flutter/material.dart';


class LoadingWaiting extends StatefulWidget {
  const LoadingWaiting({Key? key}) : super(key: key);

  @override
  State<LoadingWaiting> createState() => _LoadingWaitingState();
}

class _LoadingWaitingState extends State<LoadingWaiting> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Column(children: [
        Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Color.fromARGB(94, 255, 255, 255),
            ),
            Center(
              child: LinearProgressIndicator(),
            )
          ],
        )
      ]),
    );
  }
}
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(

        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
                child: Image(image: AssetImage('assests/images/social.jpg'))),
            SizedBox(height: 10,),
            RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: 'Mạng xã hội',style: TextStyle(color:Theme.of(context).textTheme.bodyText1!.color, fontSize: 30,fontWeight: FontWeight.bold)),
                    TextSpan(text: ' Ngọc Kute',style: TextStyle(color:Theme.of(context).textTheme.bodyText1!.color,fontSize: 30,fontWeight: FontWeight.bold)),
                  ]
                )
            ),
            Text('Phiên bản 1.1',style: TextStyle(fontSize: 10),),

          ],
        )

      ),

    );
  }
}

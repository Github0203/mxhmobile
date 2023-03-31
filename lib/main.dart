
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:socialapp/modules/settings/Profile_screen_friend.dart';
import 'package:socialapp/shared/cubit/cubit.dart';
import 'package:socialapp/shared/cubit/states.dart';
import 'package:socialapp/shared/styles/themes.dart';
import 'layout/socialapp/cubit/cubit.dart';
import 'layout/socialapp/sociallayout.dart';
import 'modules/social_login/social_login_screen.dart';
import 'modules/splashScreen/splashScreen.dart';
import 'shared/bloc_observer.dart';
import 'shared/components/constants.dart';
import 'shared/network/local/cache_helper.dart';
import 'shared/network/remote/dio_helper.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'firebase_options.dart';
import 'package:http/http.dart' as http;

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
print('Handling a background message ${message.messageId}');
  if (kDebugMode) {
    print('on background message ');
    print('----------------------------------------- ');
    print('----------------------------------------- ');
    print('----------------------------------------- ');
  }
  if (!kDebugMode) {
    print(message.data.toString());
    print('1-----------------------1------------------ 1');
    print('----------------------------------------- ');
    print('----------------------------------------- ');
  }


}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
String? UidFriend;
void main() async
{// be sure all methods finished  to run the app

  
  Bloc.observer = MyBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
  var token = await FirebaseMessaging.instance.getToken();
  if (kDebugMode) {
    print (token);
  }
  if (!kDebugMode) {
    print ('=========================');
    print (token);
  }

   



  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await DioHelper.init();
  await CacheHelper.init();

  bool ? isDarkMode = CacheHelper.getData(key: 'isDarkMode');

  Widget widget;

  uId = CacheHelper.getData(key: 'uId');

if(uId != null)
  {
    widget = SocialLayout(0);
  }
else{
  widget=SocialLoginScreen();
}
  if(kDebugMode) {
    await FirebaseCrashlytics.instance
        .setCrashlyticsCollectionEnabled(false);
  }

  
  runApp(MyApp(isDarkMode, widget ,uId ));
}

// ignore: must_be_immutable
class MyApp extends StatefulWidget {

    bool ? isDarkMode;
    late final Widget startWidget;

  MyApp(this.isDarkMode,this.startWidget, String? uId, {Key? key}) : super(key: key) ;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
    String? uId;
    String? dataZ;
    
  @override
  void initState() {
    super.initState();
    requestPermission();
    // // getToken();
    initInfo();
    // configOneSignel();
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }



  initInfo() {
     
    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSInitialize = const IOSInitializationSettings();
    var initializationSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
          UidFriend = '';
          UidFriend = payload;
          dataZ = payload;
          print('khong Loi ------------------------------------->>>>');
          print(dataZ.toString() + 'ahihii');
      try {
        if (payload != null && payload.isNotEmpty) {
          print('da click vao thong bao');
          // navigateTo(context, ProfileScreenFriend(userId: payload));
          print(UidFriend);
          navigatorKey.currentState?.pushNamed('/friendpage');
          // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
          //   return NotificationScreen(notificationInfo: payload.toString(),);
          // }));
         
        } else {
          print('Loi ------------------------------------->>>>');
        }
      } catch (e) {
        print('loi roi ban oi ' + e.toString());
      }

      return print(payload);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print(".......................onMessage..........................");
      // print(
      //     "onMessage: ${message.notification?.title}/${message.notification?.body}/${message.notification?.body.idUserFriend} ");

      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(),
        htmlFormatContentTitle: true,
      );

      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'dbfood', 'dbfood', importance: Importance.high,
        styleInformation: bigTextStyleInformation, priority: Priority.high,
        playSound: true,
        //sound: RawResourceAndroidNotificationSound('notification'),
      );

      NotificationDetails platformChannelSpecifics = NotificationDetails(
android: androidPlatformChannelSpecifics,
          iOS: const IOSNotificationDetails());
      await flutterLocalNotificationsPlugin.show(
          0, 
          message.notification?.title,
          message.notification?.body, platformChannelSpecifics,
          payload: message.data['idUserFriend'],
          );
    });
  }


  @override
  
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [

        BlocProvider( create: (BuildContext context)  => AppCubit()..changeAppMode(fromShared: widget.isDarkMode,),

        ),



        BlocProvider( create: (BuildContext context)  => SocialCubit()..getUserData(uId).. getPosts()..getAllUsers(),
        ),

    ], 
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state){},
        builder: (context ,state){
          return MaterialApp(
                navigatorKey: navigatorKey,
                debugShowCheckedModeBanner: false,
                themeMode:  AppCubit.get(context).isDarkMode ? ThemeMode.dark: ThemeMode.light,
            home: AnimatedSplashScreen(
              splash: SplashScreen(),
              nextScreen: widget.startWidget,
              splashIconSize: 700,

              animationDuration: const Duration(milliseconds: 1000),
              splashTransition: SplashTransition.fadeTransition,
            ),
            darkTheme: MyTheme.darkTheme ,
            theme: MyTheme.lightTheme,

                 builder: BotToastInit(),
                 navigatorObservers: [BotToastNavigatorObserver()],

            routes: {
    // When navigating to the "/" route, build the FirstScreen widget.
    // '/': (context) => const SocialLoginScreen(),
    // When navigating to the "/second" route, build the SecondScreen widget.
    '/friendpage': (context) => ProfileScreenFriend( userId: UidFriend),
  },
              );
            },




      ),
    );
  }
}

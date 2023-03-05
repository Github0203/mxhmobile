import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/shared/components/components.dart';
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
import 'firebase_options.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';


Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {

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


void main() async
{// be sure all methods finished  to run the app

  
  Bloc.observer = MyBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(
 name: "dev project",
 options: DefaultFirebaseOptions.currentPlatform);

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
   // Khi đang trong app sẽ hiện cái này
    FirebaseMessaging.onMessage.listen((event) {
    if (kDebugMode) {
      print('Thông báo từ firebase');
      print(event.data.toString());
      showToast(state: ToastStates.SUCCESS, text: 'Thông báo từ firebase');
    }
  });
    // khi mở thông báo sẽ hiện cái này
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    if (kDebugMode) {
      print('onMessageOpenedApp');
      print(event.data.toString());
      showToast(state: ToastStates.SUCCESS, text: event.data.toString() + 'Bạn vừa mở thông báo từ thông báo của thiết bị, mở thông báo App thành công');
    }
  });
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

    
  @override
  void initState() {
    super.initState();
    configOneSignel();
  }

  void configOneSignel()
  {
    OneSignal.shared.setAppId('ba7c4e9a-ed67-4abc-83a2-07332969b3da');
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


              );
            },




      ),
    );
  }
}

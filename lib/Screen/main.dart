import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_demo_ver/constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_demo_ver/Screen/table_list.dart';
import 'package:flutter_svg/flutter_svg.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel('high_importance_channel'
    , 'High Importance Notifications'
    , 'This channel is used for important notifications.',
  importance: Importance.high,
  playSound: true
);

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async{
  await Firebase.initializeApp();
  print("message show : ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
    .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
    ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true
  );

  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ko', 'KR'),
      ],
      debugShowCheckedModeBanner: false,
      title: 'Baby Names',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        textTheme: Theme.of(context).textTheme.apply(bodyColor: kTextColor)
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState(){
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if(notification != null && android != null){
        flutterLocalNotificationsPlugin.show(notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher'
              )
            ));
      }
    }
    );

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('event was publish');
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if(notification != null && android != null){
        showDialog(context: context, builder: (_){
          return AlertDialog(
            title: Text(notification.title),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notification.body)
                ],
              ),
            ),
          );
        }
        );
      }
    });
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    void showNotification(){
      flutterLocalNotificationsPlugin.show(0,
          "Test now",
          "hello",
          NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channel.description,
            importance: Importance.high,
            color: Colors.blue,
            playSound: true, icon: '@mipmap/ic_launcher'
          )
      ));
    }

    return Column(
        children: <Widget>[
          Container(
            height: size.height,
            width: size.width,
            decoration: BoxDecoration(color: kPrimaryColor,
                borderRadius: BorderRadius.all(Radius.circular(60)
                )
            ),
            child: Column(
                children: <Widget>[
                  Container(
                      child: Text(
                        '\n\n냉장고를 지켜라',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: size.height*0.04,
                            color: Colors.white
                        ),
                        textAlign: TextAlign.center,
                      )
                  ),
                  Container(
                      child: Text(
                        '\n방치되는 재료가 없도록',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: size.height*0.055,
                            color: Colors.white
                        ),
                        textAlign: TextAlign.center,
                      )
                  ),
                  Container(
                    child: SvgPicture.asset("assets/images/nangjang1.svg", height: size.height*0.5,),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: size.height*0.05),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          onPrimary: Colors.white

                      ),
                      onPressed: (){
                        showNotification();
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => Tabless()));
                      },
                      child: Text("  다음  ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: size.height*0.04,
                            color: Colors.white
                        ),
                      ),
                    ),
                  )
                ]
            ),
          ),
        ]
    );
  }
}

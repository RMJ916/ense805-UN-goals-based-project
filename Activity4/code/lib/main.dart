import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mhcare/providers/BordcastProvider.dart';
import 'package:mhcare/providers/EventProvider.dart';
import 'package:provider/provider.dart';
import 'package:mhcare/pages/Splash.dart';
import 'package:mhcare/providers/UserProvider.dart';
import 'package:mhcare/theme/colors.dart';
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  print(message.data);
  flutterLocalNotificationsPlugin.show(
      message.data.hashCode,
      message.data['title'],
      message.data['body'],
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channel.description,
        ),
      ));
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    // systemNavigationBarColor: Colors.transparent
  ));

  await Firebase.initializeApp();

   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);


  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => BroadcastProvider(),
        ),
          ChangeNotifierProvider(
          create: (context) => EventProvider  (),
        ),
      ],
      child: MaterialApp(
        title: 'Trackex',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: MaterialColor(0xFF29D9D5, {
              50: Color(0xFF29D9D5),
              100: Color(0xFF29D9D5),
              200: Color(0xFF29D9D5),
              300: Color(0xFF29D9D5),
              400: Color(0xFF29D9D5),
              500: Color(0xFF29D9D5),
              600: Color(0xFF29D9D5),
              700: Color(0xFF29D9D5),
              800: Color(0xFF29D9D5),
              900: Color(0xFF29D9D5)
            }),
            appBarTheme: AppBarTheme(
                brightness: Brightness.light,
                backgroundColor: white,
                elevation: 0),

            // This makes the visual density adapt to the platform that you run
            // the app on. For desktop platforms, the controls will be smaller and
            // closer together (more dense) than on mobile platforms.
            visualDensity: VisualDensity.adaptivePlatformDensity,
            backgroundColor: white),
        home: SplashScreen(),
      ),
    );
  }
}

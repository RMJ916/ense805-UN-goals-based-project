import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mhcare/main.dart';
import 'package:mhcare/pages/forum.dart';
import 'package:mhcare/pages/daily_page.dart';
import 'package:mhcare/pages/Profile.dart';
import 'package:mhcare/pages/events.dart';
import 'package:mhcare/providers/UserProvider.dart';
import 'package:mhcare/theme/colors.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int pageIndex = 0;
  List<Widget> pages = [
    DailyPage(),
    Events(),
    Forum(),
    ProfilePage(),
    // CreatBudgetPage()
  ];
  String token;
  CollectionReference _token = FirebaseFirestore.instance.collection('tokens');
  getToken() async {
    token = await FirebaseMessaging.instance.getToken();
    setState(() {
      token = token;
      print("token:" + token);
    });
    print(token);
    FirebaseFirestore.instance
        .collection('usertoken')
        .doc(token)
        .set({'token': token});
  }

  @override
  void initState() {
    // TODO: implement initState

    var initialzationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initialzationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon: android?.smallIcon,
              ),
            ));
      }
    });
    getToken();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, UserProvider, child) {
      return Scaffold(
        key: UserProvider.scaffoldKey,
        body: getBody(),
        bottomNavigationBar: getFooter(),
        
      );
    });
  }

  Widget getBody() {
    return IndexedStack(
      index: pageIndex,
      children: pages,
    );
  }

  Widget getFooter() {
    List<IconData> iconItems = [
      Ionicons.md_apps,
      Icons.event,
      Ionicons.md_help,
      Ionicons.ios_person,
    ];

    return AnimatedBottomNavigationBar(
      activeColor: primary,
      splashColor: secondary,
      inactiveColor: Colors.black.withOpacity(0.5),
      icons: iconItems,
      activeIndex: pageIndex,
      gapLocation: GapLocation.none,
      notchSmoothness: NotchSmoothness.smoothEdge,
      leftCornerRadius: 10,
      iconSize: 25,
      rightCornerRadius: 10,
      onTap: (index) {
        selectedTab(index);
      },
      //other params
    );
  }

  selectedTab(index) {
    setState(() {
      pageIndex = index;
    });
  }
}

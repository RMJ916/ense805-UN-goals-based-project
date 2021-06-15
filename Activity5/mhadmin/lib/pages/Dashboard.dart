import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart'; 
import 'package:mhadmin/models/broadcastRoom.dart';
import 'package:mhadmin/pages/forum.dart';
import 'package:mhadmin/pages/daily_page.dart'; 
import 'package:mhadmin/pages/events.dart';
import 'package:mhadmin/pages/stepOne.dart';
import 'package:mhadmin/providers/BordcastProvider.dart';
import 'package:mhadmin/providers/EventProvider.dart';
import 'package:mhadmin/providers/QueProvider.dart';
import 'package:mhadmin/providers/UserProvider.dart';
import 'package:mhadmin/theme/Style.dart';
import 'package:mhadmin/theme/colors.dart'; 
import 'package:mhadmin/widget/loading.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int pageIndex = 0;
  List<Widget> pages = [
    HomePage(),
    DailyPage(),
    Events(),
    Forum(),
    // ProfilePage(),
    // CreatBudgetPage()
  ];
  String token;
  CollectionReference _token = FirebaseFirestore.instance.collection('tokens');

  @override
  void initState() {
    // TODO: implement initState

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
        // floatingActionButton: FloatingActionButton(
        //     onPressed: () {
        //       selectedTab(4);
        //     },
        //     child: Icon(
        //       Icons.add,
        //       size: 25,
        //     ),
        //     backgroundColor: primary
        //     //params
        //     ),
        // floatingActionButtonLocation:
        //     FloatingActionButtonLocation.centerDocked
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
      Icons.dashboard_sharp,
      Ionicons.md_apps,
      Icons.event,
      Ionicons.md_help,
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

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int activeDay = 3;
  Map<String, BroadcastRoom> broom;
  List<String> names = [
    "Today\'s Excercise",
    "Today\'s Energizer",
    "Today\'s Quotes",
    "Technical Help"
  ];
  @override
  Widget build(BuildContext context) {
    return Consumer4<UserProvider, BroadcastProvider, EventProvider,
            QusProivder>(
        builder: (context, UserProvider, BroadcastProvider, EventProvider,
            QusProivder, child) {
      broom = BroadcastProvider.broom;

      return Scaffold(
        appBar: AppBar(
          backgroundColor: white,
          title: Text(
            "Dashboard",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: black),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: mainMargin),
              child: IconButton(
                icon: Icon(
                  FontAwesome.power_off,
                  color: dark,
                ),
                onPressed: () {
                  FirebaseAuth.instance.signOut().then((value) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => Stepone()),
                        (route) => false);
                  });
                },
              ),
            )
          ],
        ),
        backgroundColor: white,
        body: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: grey,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(mainMargin),
                        topRight: Radius.circular(mainMargin))),
                padding: EdgeInsets.all(mainMargin),
                child: RefreshIndicator(
                  onRefresh: () async {
                    await BroadcastProvider.loadbroadcastroom();
                  },
                  child: broom == null ||
                          BroadcastProvider.posts == null ||
                          EventProvider.events == null ||
                          QusProivder.qus == null
                      ? Loading(
                          title: "Wait data is loading!",
                        )
                      : ListView( 
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: grey.withOpacity(0.01),
                                      spreadRadius: 10,
                                      blurRadius: 3,
                                      // changes position of shadow
                                    ),
                                  ]),
                              child: ListTile(
                                contentPadding: EdgeInsets.all(7),
                                leading: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: primary.withOpacity(0.8),
                                      border:
                                          Border.all(width: 2, color: dark)),
                                          child: Icon(Icons.podcasts,color: white,),
                                ),
                                title: Text(
                                  "Broadcast Rooms:",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: black),
                                ),
                                trailing: Padding(
                                  padding: EdgeInsets.only(right: mainMargin),
                                  child: Text(BroadcastProvider.broom.length
                                      .toString()),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: mainMargin,
                            ),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: grey.withOpacity(0.01),
                                      spreadRadius: 10,
                                      blurRadius: 3,
                                      // changes position of shadow
                                    ),
                                  ]),
                              child: ListTile(
                                 contentPadding: EdgeInsets.all(7),
                                leading: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                         color: primary.withOpacity(0.8),
                                      border:
                                          Border.all(width: 2, color: dark)),
                                          child: Icon(Icons.post_add,color: white,),
                                ),
                                title: Text(
                                  "Total Posts:",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: black),
                                ),
                                trailing: Padding(
                                  padding: EdgeInsets.only(right: mainMargin),
                                  child: Text(BroadcastProvider.getTotalPost()
                                      .toString()),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: mainMargin,
                            ),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: grey.withOpacity(0.01),
                                      spreadRadius: 10,
                                      blurRadius: 3,
                                      // changes position of shadow
                                    ),
                                  ]),
                              child: ListTile( contentPadding: EdgeInsets.all(7),
                                leading: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                         color: primary.withOpacity(0.8),
                                      border:
                                          Border.all(width: 2, color: dark)),
                                          child: Icon(Icons.event,color: white,),
                                ),
                                title: Text(
                                  "Total Events:",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: black),
                                ),
                                trailing: Padding(
                                  padding: EdgeInsets.only(right: mainMargin),
                                  child: Text(
                                      EventProvider.events.length.toString()),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: mainMargin,
                            ),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: grey.withOpacity(0.01),
                                      spreadRadius: 10,
                                      blurRadius: 3,
                                      // changes position of shadow
                                    ),
                                  ]),
                              child: ListTile(
                                 contentPadding: EdgeInsets.all(7),
                                leading: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                          color: primary.withOpacity(0.8),
                                      border:
                                          Border.all(width: 2, color: dark)),
                                          child: Icon(Icons.question_answer,color: white,),
                                ),
                                title: Text(
                                  "Total Questions:",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: black),
                                ),
                                trailing: Padding(
                                  padding: EdgeInsets.only(right: mainMargin),
                                  child:
                                      Text(QusProivder.qus.length.toString()),
                                ),
                              ),
                            ),  SizedBox(
                              height: mainMargin,
                            ),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: grey.withOpacity(0.01),
                                      spreadRadius: 10,
                                      blurRadius: 3,
                                      // changes position of shadow
                                    ),
                                  ]),
                              child: ListTile(
                                 contentPadding: EdgeInsets.all(7),
                                leading: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                          color: primary.withOpacity(0.8),
                                      border:
                                          Border.all(width: 2, color: dark)),
                                          child: Icon(Icons.query_stats,color: white,),
                                ),
                                title: Text(
                                  "Unanswered Questions:",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: black),
                                ),
                                trailing: Padding(
                                  padding: EdgeInsets.only(right: mainMargin),
                                  child:
                                      Text(QusProivder.qus.values.toList().where((element) => !element.answered).toList().length.toString()),
                                ),
                              ),
                            )  ,SizedBox(
                              height: mainMargin,
                            ),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: grey.withOpacity(0.01),
                                      spreadRadius: 10,
                                      blurRadius: 3,
                                      // changes position of shadow
                                    ),
                                  ]),
                              child: ListTile(
                                 contentPadding: EdgeInsets.all(7),
                                leading: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                          color: primary.withOpacity(0.8),
                                      border:
                                          Border.all(width: 2, color: dark)),
                                          child: Icon(Icons.check,color: white,),
                                ),
                                title: Text(
                                  "Answered Questions:",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: black),
                                ),
                                trailing: Padding(
                                  padding: EdgeInsets.only(right: mainMargin),
                                  child:
                                      Text(QusProivder.qus.values.toList().where((element) => element.answered).toList().length.toString()),
                                ),
                              ),
                            )
                          ],
                        ),
                ),
              ),
            ),
            // broom == null
            //     ? LinearProgressIndicator(
            //         backgroundColor: white,
            //       )
            //     : SizedBox.shrink()
          ],
        ),
      );
    });
  }
}

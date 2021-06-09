import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mhcare/models/appuser.dart';
import 'package:mhcare/models/event.dart';
import 'package:mhcare/providers/UserProvider.dart';
import 'package:mhcare/theme/Style.dart';
import 'package:mhcare/theme/colors.dart';
import 'package:mhcare/widget/eventstile.dart';
import 'package:mhcare/widget/hideoverglow.dart';
import 'package:mhcare/widget/loading.dart';
import 'package:provider/provider.dart';

class PastEvent extends StatefulWidget {
  const PastEvent({Key key}) : super(key: key);

  @override
  _PastEventState createState() => _PastEventState();
}

class _PastEventState extends State<PastEvent> {
  Appuser user;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Map<String, Event> pastevents;

  DocumentSnapshot lastdocid;
  @override
  void initState() {
    // TODO: implement initState
    loadfirst10();
    super.initState();
  }

  loadfirst10() async {
    FirebaseFirestore.instance
        .collection('events')
        .where('event_date', isGreaterThan: Timestamp.now())
        .orderBy('event_date')
        .limit(10)
        .get()
        .then((value) {
      pastevents = {};
      value.docs.forEach((element) {
        setState(() {
          pastevents.putIfAbsent(
              element.id, () => Event.fromJson(element.data()));
        });
      });
      lastdocid = value.docs.last;
    });
  }

  loadMore10() async {
    if (lastdocid != null) {
      print('loading more 10');
      FirebaseFirestore.instance
          .collection('events')
          .where('event_date', isGreaterThan: Timestamp.now())
          .orderBy('event_date')
          .startAfterDocument(lastdocid)
          .limit(10)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          setState(() {
            pastevents.putIfAbsent(
                element.id, () => Event.fromJson(element.data()));
          });
        });

        if (value.docs.length > 0) {
               lastdocid = value.docs.last;
        } else {
          print("upto date");
        }
   
      });
    } else {
      print("already loaded");
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<UserProvider>(builder: (context, UserProvider, child) {
      user = UserProvider.user;

      return Scaffold(
        key: scaffoldKey,
        backgroundColor: grey,
        appBar: AppBar(
          title: AppTitle(title: "Past Event"),
          
        ),
        body: Container(
          decoration: BoxDecoration(
              color: grey,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(mainMargin),
                  topRight: Radius.circular(mainMargin))),
          padding: EdgeInsets.all(subMargin),
          child: pastevents == null
              ? Loading(
                  title: "Wait Past events loading",
                )
              : pastevents.length == 0
                  ? NoData(
                      title: "No past events!",
                    )
                  : HideOverGlow(
                      child: NotificationListener<OverscrollNotification>(
                        onNotification: (value) {
                          if (value.overscroll > 0) {
                            print("load more");
                            loadMore10();
                          } else {
                            print("already loaded");
                          }
                          return true;
                        },
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: pastevents.length,
                          itemBuilder: (context, index) {
                            return EventTile(
                              id: pastevents.keys.toList()[index],
                              date: pastevents.values
                                  .toList()[index]
                                  .eventDate
                                  .toDate()
                                  .toString()
                                  .substring(0, 10),
                              dec: pastevents.values.toList()[index].dec,
                              image_url:
                                  pastevents.values.toList()[index].image,
                              lastmsg_time: "",
                              location:
                                  pastevents.values.toList()[index].location,
                              name: pastevents.values.toList()[index].title,
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: mainMargin,
                            );
                          },
                        ),
                      ),
                    ),
        ),
      );
    });
  }
}

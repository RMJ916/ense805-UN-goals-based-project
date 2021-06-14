import 'package:flutter/material.dart';
import 'package:mhcare/models/event.dart';
import 'package:mhcare/pages/PastEvent.dart';
import 'package:mhcare/providers/EventProvider.dart';
import 'package:mhcare/providers/UserProvider.dart';
import 'package:mhcare/theme/Style.dart';
import 'package:mhcare/theme/colors.dart';

import 'package:mhcare/widget/eventstile.dart';
import 'package:mhcare/widget/hideoverglow.dart';
import 'package:mhcare/widget/loading.dart';
import 'package:provider/provider.dart';

class Events extends StatefulWidget {
  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {
  int activeDay = 3;
  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider, EventProvider>(
        builder: (context, UserProvider, EventProvider, child) {
      Map<String, Event> events = EventProvider.events;

      List<Event> event;

      List<String> ids;
      if (events != null) {
        event = events.values.toList();
        ids = events.keys.toList();
      }

      return Scaffold(
        appBar: AppBar(
          backgroundColor: white,
          title: Text(
            "Events",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: black),
          ),
          // actions: [
          //   Padding(
          //     padding:   EdgeInsets.only(right: mainMargin),
          //     child: IconButton(
          //       icon: Icon(Icons.search),
          //       onPressed: () {},
          //       color: dark,
          //     ),
          //   )
          // ],
        ),
        backgroundColor: white,
        body: Container(
          decoration: BoxDecoration(
              color: grey,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(mainMargin),
                  topRight: Radius.circular(mainMargin))),
          padding: EdgeInsets.all(mainMargin),
          child: events == null
              ? Loading(
                  title: "Wait, Event is loading!",
                )
              : ListView(
                physics: AlwaysScrollableScrollPhysics(),
                  children: [
                
                    RefreshIndicator(
                        onRefresh: () async {},
                        child: events.length == 0
                            ? NoData(
                                title: "No Upcoming events!",
                              )
                            : NotificationListener<OverscrollNotification>(
                                onNotification: (value) {
                                  if (value.overscroll > 0) {
                                    print("load more");
                                  } else {
                                    print("dont load more");
                                  }

                                  return true;
                                },
                                child: ListView.separated(
                                  itemCount: event.length,
                                  shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return EventTile(
                                        image_url: event[index].image,
                                        name: event[index].title,
                                        dec: event[index].dec,
                                        lastmsg_time: "20/5/21",
                                        location: event[index].location,
                                        id: ids[index],
                                        date: event[index]
                                            .eventDate
                                            .toDate()
                                            .toLocal()
                                            .toString()
                                            .substring(0, 10));
                                  },
                                  separatorBuilder: (context, index) {
                                    return SizedBox(
                                      height: mainMargin,
                                    );
                                  },
                                ),
                              ),
                      ),
                  
                    Padding(
                      padding: EdgeInsets.only(top: mainMargin),
                      child: Container(
                        padding: EdgeInsets.all(subMargin),
                        decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(subMargin)),
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PastEvent()));
                            },
                            child: Center(
                                child: Text(
                              "View past Events",
                              style: blthsubtitleligh,
                            ))),
                      ),
                    )
                  ],
                ),
        ),
      );
    });
  }
}

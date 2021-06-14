import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mhadmin/models/event.dart';
import 'package:mhadmin/providers/EventProvider.dart';
import 'package:mhadmin/theme/Style.dart';
import 'package:mhadmin/theme/colors.dart'; 
import 'package:provider/provider.dart'; 

class EventDetails extends StatefulWidget {
  String id;

  EventDetails({this.id});
  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

 
  @override
  Widget build(BuildContext context) {
    return Consumer<EventProvider>(builder: (context, EventProvider, child) {
      Event event = EventProvider.events[widget.id];
      return Scaffold(
        key: scaffoldKey,
        backgroundColor: grey,
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: white,
          elevation: 0,
          // title: Text(
          //   "Create an Account",
          //   style: TextStyle(
          //       color: primary, fontWeight: FontWeight.bold, fontSize: 30),
          // ),
          title: AppTitle(title: event.title),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: black,
              size: mainMargin + 6,
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: mainMargin),
              child: IconButton(
                icon: Icon(Icons.share),
                onPressed: () {
                  },
                color: dark,
              ),
            )
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(mainMargin),
          decoration: BoxDecoration(
              color: grey,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(subMargin),
                  topRight: Radius.circular(subMargin))),
          child: SingleChildScrollView(
            
              child: Container(
                padding: EdgeInsets.all(subMargin),
                decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(subMargin),
                    boxShadow: [
                      BoxShadow(
                        color: grey.withOpacity(0.01),
                        spreadRadius: 10,
                        blurRadius: 3,
                        // changes position of shadow
                      ),
                    ]),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(subMargin),
                      child: CachedNetworkImage(
                        imageUrl: event.image,
                        width: double.infinity,
                        height: 160,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Container(
                          width: double.infinity,
                          height: 160,
                          color: grey,
                          child: Center(child: Icon(Icons.image)),
                        ),
                        placeholder: (context, value) {
                          // return Center(
                          //   child: Container(
                          //     width: 46,
                          //     height: 46,
                          //     child: CircularProgressIndicator(
                          //       valueColor: new AlwaysStoppedAnimation<Color>(dark),
                          //       backgroundColor: grey,
                          //     ),
                          //   ),
                          // );
                          return Container(
                            width: double.infinity,
                            height: 160,
                            color: grey,
                            child: Center(
                                child: Icon(
                              Icons.image,
                              size: 45,
                              color: dark.withOpacity(0.5),
                            )),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: subMargin,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(
                          Icons.person,
                          color: dark,
                          size: 24,
                        ),
                        SizedBox(
                          width: subMargin,
                        ),
                        Text(
                          event.person,
                        )
                      ],
                    ),
                    SizedBox(
                      height: subMargin,
                    ),
                    Text(event.dec),
                    SizedBox(
                      height: subMargin,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(
                          Icons.event,
                          color: dark,
                          size: 24,
                        ),
                        SizedBox(
                          width: subMargin,
                        ),
                        Text(
                          event.eventDate
                              .toDate()
                              .toLocal()
                              .toString()
                              .substring(0, 10),
                        )
                      ],
                    ),
                    SizedBox(
                      height: subMargin,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(
                          CupertinoIcons.clock,
                          color: dark,
                          size: 24,
                        ),
                        SizedBox(
                          width: subMargin,
                        ),
                        Text(
                          event.eventDate.toDate().hour.toString() +
                              ":" +
                              event.eventDate.toDate().minute.toString() +
                              " " +
                              event.eventDate.toDate().timeZoneName.toString(),
                        )
                      ],
                    ),
                    SizedBox(
                      height: subMargin,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_city,
                          color: dark,
                          size: 24,
                        ),
                        SizedBox(
                          width: subMargin,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width -
                              2 * mainMargin -
                              3 * subMargin -
                              25,
                          child: Text(
                            '100 centennial at,S4s6a7, Saskatchewan, Sk, CA ',
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
           
          ),
        ),
      );
    });
  }
}

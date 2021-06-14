import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mhcare/pages/eventDetails.dart';
import 'package:mhcare/theme/Style.dart';
import 'package:mhcare/theme/colors.dart';
import 'package:mhcare/util/uitility.dart';
import 'package:screenshot/screenshot.dart';

class EventTile extends StatefulWidget {
  String location;
  String image_url;
  String dec;
  String lastmsg_time;
  String id;
  String name;
  String date;

  EventTile(
      {this.image_url,
      this.dec,
      this.lastmsg_time,
      this.location,
      this.name,
      this.date,
      this.id});

  @override
  _EventTileState createState() => _EventTileState();
}

class _EventTileState extends State<EventTile> {
  ScreenshotController controller = ScreenshotController();

  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        Navigator.push(
            context, CupertinoPageRoute (builder: (context) => EventDetails(id:widget.id)));
      },
      child: Screenshot(
        controller: controller,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(subMargin),
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
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(subMargin),
                child: CachedNetworkImage(
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.fill,
                  imageUrl: widget.image_url,
                  errorWidget: (context, url, error) => Container(
                      width: 50,
                      height: 50,
                      color: grey,
                      child: Center(
                        child: Text(
                          widget.name[0].toUpperCase(),
                          style: TextStyle(color: dark),
                        ),
                      )),
                  placeholder: (context, value) {
                    return Container(
                      width: 46,
                      height: 46,
                      child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(dark),
                        backgroundColor: grey,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: subMargin,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Icon(Icons.event),
                  // SizedBox(
                  //   width: subMargin,
                  // ),
                  Flexible(
                    child: Text(
                      widget.name,
                      style: eventtitle,
                    ),
                  ),

                  SizedBox(
                    width: 120,
                    child: Row(
                      children: [
                        Icon(Icons.event),
                        SizedBox(
                          width: subMargin,
                        ),
                        SizedBox(child: Text(widget.date))
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: subMargin,
              ),
              Text(
                widget.dec,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(),
              ),
              SizedBox(
                height: subMargin,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.location_pin),
                  SizedBox(
                    width: subMargin,
                  ),
                  SizedBox(
                    width: size.width - 2 * mainMargin - 3 * subMargin - 2 * 32,
                    child: Text(
                      widget.location,
                      style: eventsubtitle,
                    ),
                  ),

                  // Icon(Icons.event),
                  SizedBox(
                    width: subMargin,
                  ),
                  InkWell(
                      onTap: () {
                        shareImage1(
                            controller: controller,
                            msg: "I will like to invite to attend " +
                                widget.name +
                                " on " +
                                widget.date.toString() +
                                " at " +
                                widget.location);
                      },
                      child: Icon(Icons.share)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

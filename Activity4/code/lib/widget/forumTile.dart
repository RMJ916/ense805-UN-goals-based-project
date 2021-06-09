import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mhcare/pages/qna.dart';
import 'package:mhcare/theme/Style.dart';
import 'package:mhcare/theme/colors.dart';
import 'package:mhcare/util/uitility.dart';
import 'package:screenshot/screenshot.dart';

class ForumTile extends StatelessWidget {
  String title;
  String image_url;
  int total_answer;
  String last_answer;
  bool answered;
  String question;
  ForumTile(
      {this.image_url,
      this.total_answer,
      this.last_answer,
      this.title,
      this.question,
      this.answered});
  ScreenshotController controller = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (contex) => QNA()));
      },
      child: Screenshot(
        controller: controller,
        child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: subMargin),
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
              title: Text(question),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: subMargin),
                    child: Text(
                      last_answer,
                      style: eventsubtitle,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: subMargin),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Wrap(
                          children: [
                            Container(
                              width: 70,
                              height: 25,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: answered
                                      ? primary.withOpacity(0.8)
                                      : dark),
                              child: Center(
                                child: Text(
                                  answered ? "Closed" : "Open",
                                  style: TextStyle(color: white),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: subMargin,
                            ),
                            Container(
                              width: 90,
                              height: 25,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: grey),
                              child: Center(
                                child: Text(
                                  total_answer.toString() + " Answers",
                                  style: TextStyle(color: dark),
                                ),
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                            onTap: () {
                              shareImage1(
                                  controller: controller,
                                  msg: "I have found intresting discussion on " +
                                      title +
                                      ", Download MHcare app to get more information!");
                            },
                            child: Icon(Icons.share))
                      ],
                    ),
                  )
                ],
              ),
              
            )),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mhcare/models/question.dart';
import 'package:mhcare/pages/qna.dart';
import 'package:mhcare/theme/Style.dart';
import 'package:mhcare/theme/colors.dart';
import 'package:mhcare/util/uitility.dart';
import 'package:screenshot/screenshot.dart';

class ForumTile extends StatelessWidget {
  String id; 
  Question question;
  ForumTile(
      {this.id,
      this.question });
  ScreenshotController controller = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (contex) => QNA(question:question,id:id)));
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
              // leading: Container(
              //   decoration: BoxDecoration(
              //       border: Border.all(width: 2, color: primary),
              //       borderRadius: BorderRadius.circular(30)),
              //   child: SizedBox(
              //     width: 50,
              //     height: 50,
              //     child: ClipRRect(
              //       borderRadius: BorderRadius.circular(25),
              //       child: CachedNetworkImage(
              //         imageUrl: image_url,
              //         errorWidget: (context, url, error) => Container(
              //             width: 50,
              //             height: 50,
              //             color: grey,
              //             child: Center(
              //               child: Text(
              //                 name[0].toUpperCase(),
              //                 style: TextStyle(color: dark),
              //               ),
              //             )),
              //         placeholder: (context, value) {
              //           return  Container(
              //           width: 46,
              //           height: 46,
              //           child: CircularProgressIndicator(
              //             valueColor: new AlwaysStoppedAnimation<Color>(
              //                 dark),
              //             backgroundColor: grey,
              //           ),
              //         );
              //         },
              //       ),
              //     ),
              //   ),
              // ),
              title: Text(question.qus),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   question.bestanswer==''?SizedBox.shrink():   Padding(
                    padding: EdgeInsets.only(top: subMargin),
                    child: Text(
                      question.bestanswer,
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
                                  color: question.answered
                                      ? primary.withOpacity(0.8)
                                      : dark),
                              child: Center(
                                child: Text(
                                  question.answered ? "Closed" : "Open",
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
                                  question.total_answer.toString() + " Answers",
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
                                      question.qus +
                                      ", Download MHcare app to get more information!");
                            },
                            child: Icon(Icons.share))
                      ],
                    ),
                  )
                ],
              ),
              //   trailing: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Icon(answered?Icons.check_circle_outline:Icons.arrow_right,size: answered?24:30,
              //       color:answered?primary: dark,
              //       // trailing: SizedBox(
              //       //   child: Container(
              //       //     width: unread.length == 1 ? 20 : (unread.length * 13.0),
              //       //     height: 20,
              //       //     decoration: BoxDecoration(
              //       //         borderRadius: BorderRadius.circular(10), color: primary),
              //       //     child: Center(
              //       //         child: Text(
              //       //       unread,
              //       //       style: TextStyle(color: white),
              //       //     )),
              //       //   ),
              //       // ),
              // ),
              //     ],
              //   ),
            )),
      ),
    );
  }
}

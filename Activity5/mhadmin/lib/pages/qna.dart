import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mhadmin/models/answer.dart';
import 'package:mhadmin/models/appuser.dart';
import 'package:mhadmin/models/question.dart';
import 'package:mhadmin/pages/adResponse.dart';
import 'package:mhadmin/theme/Style.dart';
import 'package:mhadmin/theme/colors.dart'; 
import 'package:mhadmin/widget/Buttons.dart';
import 'package:mhadmin/widget/answerTile.dart';
import 'package:mhadmin/widget/inputbox.dart';
import 'package:mhadmin/widget/loading.dart';
import 'package:mhadmin/widget/snackbar.dart';

class QNA extends StatefulWidget {
  Question question;
  String id;

  QNA({this.question, this.id});
  @override
  _QNAState createState() => _QNAState();
}

class _QNAState extends State<QNA> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int activeDay = 3;
  Appuser user;
  Appuser queuser;
  TextEditingController ans;
  Question question;
  bool isloading = false;
  Map<String, Answer> ansr;
  int total_anser = 0;
  String bestid = '';
  @override
  void initState() {
    ans = TextEditingController();
    if (widget.question != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(widget.question.qusby)
          .get()
          .then((value) {
        setState(() {
          queuser = Appuser.fromJson(value.data());
        });
      });
    }
    loadAns();
    super.initState();
  }

  loadAns() async {
    if (widget.question != null) {
      FirebaseFirestore.instance
          .collection('questions')
          .doc(widget.id)
          .collection('ans')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .listen((value) {
        setState(() {
          ansr = {};
        });
        value.docs.forEach((element) {
          setState(() {
            ansr.putIfAbsent(element.id, () => Answer.fromJson(element.data()));
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: white,
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: white,
        elevation: 0,
        // title: Text(
        //   "Create an Account",
        //   style: TextStyle(
        //       color: primary, fontWeight: FontWeight.bold, fontSize: 30),
        // ),
        title: AppTitle(title: "Discussion"),
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
              onPressed: () {},
              color: dark,
            ),
          )
        ],
      ),
      body: Container(
        color: grey,
        child: Column(
          children: [
            queuser == null
                ? Container(
                    height: 150,
                    decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(subMargin),
                            bottomRight: Radius.circular(subMargin))),
                    child: Center(child: progressBar()))
                : Container(
                    padding: EdgeInsets.all(mainMargin),
                    decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(subMargin),
                            bottomRight: Radius.circular(subMargin))),
                    child: Column(
                      children: [
                        ListTile(
                          dense: true,
                          leading: Container(
                            width: 50,
                            decoration: BoxDecoration(
                                color: primary,
                                borderRadius: BorderRadius.circular(25)),
                            child: Center(
                              child: Text(
                                (queuser.fname.substring(0, 1) +
                                        queuser.lname.substring(0, 1))
                                    .toUpperCase(),
                                style: TextStyle(
                                    color: white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          title: Text(queuser.fname + " " + queuser.lname),
                          subtitle: Text(widget.question.timestamp
                                  .toDate()
                                  .toLocal()
                                  .toString()
                                  .substring(0, 16) +
                              " " +
                              widget.question.timestamp
                                  .toDate()
                                  .timeZoneName
                                  .toString()),
                        ),
                        ListTile(
                          title: Text(widget.question.qus),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              widget.question.bestanswer == ''
                                  ? SizedBox.shrink()
                                  : Padding(
                                      padding: EdgeInsets.only(top: subMargin),
                                      child: Text(
                                        widget.question.bestanswer,
                                        style: eventsubtitle,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),
                              Padding(
                                padding: EdgeInsets.only(top: subMargin),
                                child: Row(
                                  mainAxisAlignment: (bestid != "" ||
                                          widget.question.best_ans_id != "")
                                      ? MainAxisAlignment.start
                                      : MainAxisAlignment.spaceBetween,
                                  children: [
                                    (bestid != "" ||
                                            widget.question.best_ans_id != "")
                                        ? SizedBox.shrink()
                                        : InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AddResponse(
                                                              tans: ansr.length,
                                                              id: widget
                                                                  .id))).then(
                                                  (value) {
                                                if (value == 'true') {
                                                  CustomSnackBar(
                                                          actionTile: "Close",
                                                          scaffoldKey:
                                                              scaffoldKey,
                                                          haserror: false,
                                                          isfloating: true,
                                                          onPressed: () {},
                                                          title:
                                                              // "Something went wrong ,Try again later!"
                                                              "Answer added!")
                                                      .show();
                                                }
                                              });
                                            },
                                            child: Container(
                                              width: 155,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(7),
                                                  color: grey),
                                              child: Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.comment,
                                                      size: 16,
                                                      color: dark,
                                                    ),
                                                    SizedBox(
                                                      width: subMargin,
                                                    ),
                                                    Text(
                                                      "Add Response ",
                                                      style: TextStyle(
                                                          color: dark),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                    Text(ansr == null
                                        ? 0.toString()
                                        : ansr.length.toString() + " Responses")
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
                        ),
                      ],
                    ),
                  ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(mainMargin),
                child: Container(
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
                  child: ansr == null
                      ? Loading(
                          title: "loading!",
                        )
                      : ansr.length == 0
                          ? NoData(
                              title: "No Answers from users!",
                            )
                          : ListView.separated(
                              padding:
                                  EdgeInsets.symmetric(vertical: subMargin),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onLongPress: () {
                                    // if (FirebaseAuth.instance.currentUser.uid ==
                                    //     widget.question.qusby) {
                                    //   showDialog(
                                    //     context: context,
                                    //     builder: (BuildContext context) {
                                    //       return AlertDialog(
                                    //         title: Text("Confirm"),
                                    //         content: Text(
                                    //             "Do you want to choose this answer as a best answer and close this question!"),
                                    //         actions: [
                                    //           PrimaryButton(
                                    //             isloading: false,
                                    //             title: "Sure",
                                    //             backgroundColor: primary,
                                    //             height: 40,
                                    //             foregroundColor: white,
                                    //             width: 120,
                                    //             onPressed: () {
                                    //               setState(() {
                                    //                 bestid = ansr.keys
                                    //                     .toList()[index];
                                    //               });
                                    //               FirebaseFirestore.instance
                                    //                   .collection('questions')
                                    //                   .doc(widget.id)
                                    //                   .set(
                                    //                       {
                                    //                     "answered": true,
                                    //                     "bestanswer": ansr
                                    //                         .values
                                    //                         .toList()[index]
                                    //                         .answers,
                                    //                     "best_ans_id": ansr.keys
                                    //                         .toList()[index]
                                    //                   },
                                    //                       SetOptions(
                                    //                           merge:
                                    //                               true)).then(
                                    //                       (value) {
                                    //                 Navigator.pop(
                                    //                     context, "true");
                                    //               });
                                    //             },
                                    //           ),
                                    //         ],
                                    //       );
                                    //     },
                                    //   );
                                    // }
                                  },
                                  child: AnswerTile(
                                      ans: ansr.values.toList()[index],
                                      bestid: bestid == ''
                                          ? widget.question.best_ans_id
                                          : bestid,
                                      id: ansr.keys.toList()[index]),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  height: 0,
                                );
                              },
                              itemCount: ansr.length),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

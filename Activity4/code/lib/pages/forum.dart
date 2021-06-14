import 'package:flutter/material.dart';
import 'package:mhcare/models/appuser.dart';
import 'package:mhcare/models/question.dart';
import 'package:mhcare/pages/createQus.dart';
import 'package:mhcare/providers/QueProvider.dart';
import 'package:mhcare/providers/UserProvider.dart';
import 'package:mhcare/theme/Style.dart';
import 'package:mhcare/theme/colors.dart';
import 'package:mhcare/widget/Buttons.dart';

import 'package:mhcare/widget/forumTile.dart';
import 'package:mhcare/widget/inputbox.dart';
import 'package:mhcare/widget/loading.dart';
import 'package:mhcare/widget/snackbar.dart';
import 'package:provider/provider.dart';

class Forum extends StatefulWidget {
  @override
  _ForumState createState() => _ForumState();
}

class _ForumState extends State<Forum> {
  int activeDay = 3;
  Appuser user;

  TextEditingController ques;

  bool isloading = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    ques = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider, QusProivder>(
        builder: (context, UserProvider, QusProivder, child) {
      Map<String, Question> qus = QusProivder.qus;
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: primary,
          foregroundColor: white,
          onPressed: () {
            // addques();
            // addQuestion(user: UserProvider.user);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => CreateQus())).then((value) {

                  if(value==true)
                  {
                      CustomSnackBar(
                                                    actionTile: "Close",
                                                    scaffoldKey: scaffoldKey,
                                                    haserror: false,
                                                    isfloating: true,
                                                    onPressed: () {},
                                                    title:
                                                        // "Something went wrong ,Try again later!"
                                                       "Question added!"
                                                        )
                                                .show();
                  }
                });
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          backgroundColor: white,
          title: Text(
            "Forum",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: black),
          ),
          actions: [
            // Padding(
            //   padding: EdgeInsets.only(right: mainMargin),
            //   child: IconButton(
            //     icon: Icon(Icons.search),
            //     onPressed: () {},
            //     color: dark,
            //   ),
            // )
          ],
        ),
        backgroundColor: white,
        body: Container(
          decoration: BoxDecoration(
              color: grey,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(mainMargin),
                  topRight: Radius.circular(mainMargin))),
          padding: EdgeInsets.all(mainMargin),
          child: qus == null
              ? Loading(
                  title: "Wait questions is loading!",
                )
              : qus.length == 0
                  ? NoData(
                      title: "No questions!",
                    )
                  : ListView.separated(
                      itemCount: qus.length,
                      itemBuilder: (context, index) {
                        return ForumTile(
                          question: qus.values.toList()[index],
                          id: qus.keys.toList()[index],
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: mainMargin,
                        );
                      },
                    ),
        ),
      );
    });
  }
 
}

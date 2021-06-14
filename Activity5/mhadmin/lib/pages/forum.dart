import 'package:flutter/material.dart';
import 'package:mhadmin/models/appuser.dart';
import 'package:mhadmin/models/question.dart'; 
import 'package:mhadmin/providers/QueProvider.dart';
import 'package:mhadmin/providers/UserProvider.dart';
import 'package:mhadmin/theme/Style.dart';
import 'package:mhadmin/theme/colors.dart'; 
import 'package:mhadmin/widget/forumTile.dart'; 
import 'package:mhadmin/widget/loading.dart'; 
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

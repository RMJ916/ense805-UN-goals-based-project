import 'package:flutter/material.dart';
import 'package:mhcare/models/appuser.dart';
import 'package:mhcare/pages/createQues.dart';
import 'package:mhcare/providers/UserProvider.dart';
import 'package:mhcare/theme/Style.dart';
import 'package:mhcare/theme/colors.dart';
import 'package:mhcare/widget/Buttons.dart';

import 'package:mhcare/widget/forumTile.dart';
import 'package:mhcare/widget/inputbox.dart';
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
    return Consumer<UserProvider>(builder: (context, UserProvider, child) {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: primary,
          foregroundColor: white,
          onPressed: () {
            addques();
            
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
            Padding(
              padding: EdgeInsets.only(right: mainMargin),
              child: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {},
                color: dark,
              ),
            )
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
          child: ListView.separated(
            itemCount: 3,
            itemBuilder: (context, index) {
              return ForumTile(
                  question: "What causes depression?",
                  last_answer:
                      "We all have days when we feel down, but those feelings usually pass without having too much impact on our lives. But if they last beyond a couple of weeks or you feel as though things are getting worse, it could be a sign that you’re experiencing depression.",
                  title: "Hello",
                  answered: index.isEven ? true : false,
                  total_answer: index);
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

  void addQuestion({Appuser user}) {
    showDialog(
        context: context,

        builder: (context) {
          return Container(
            height: 380,
            color: Colors.transparent,
            child: Container(
              height: 380,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(mainMargin),
                      topRight: Radius.circular(mainMargin)),
                  color: white),
              padding: EdgeInsets.zero,
              child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Container(
                    height: 380,
                    child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(mainMargin),
                            topRight: Radius.circular(mainMargin)),
                        child: CreateQues()),
                  );
                },
              ),
            ),
          );
        });
  }

  void addques() {
    showModalBottomSheet<void>(
      enableDrag: true,
      isScrollControlled: true,
      context: context,
      
        backgroundColor: white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(subMargin)),
      builder: (BuildContext context) {
        return Container(
            height: 350,
            color: Colors.transparent,
            child: ClipRRect(
               borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(mainMargin),
                      topRight: Radius.circular(mainMargin)),
              child: Container(
                height: 350,
               
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(mainMargin),
                        topRight: Radius.circular(mainMargin)),
                    color: white),
              child: Container(
                
                child: Column(
                  children: <Widget>[
                  AppBar(
                title: AppTitle(title: "Add Question"),
                actions:[ Padding(
                  padding:   EdgeInsets.only(right: subMargin-6),
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: dark,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),],
                automaticallyImplyLeading: false,
          ),
                      Expanded(
                        child: Center(
                          child: Padding(
                           padding: EdgeInsets.only(left: mainMargin,bottom: mainMargin,right: mainMargin),
                            child: inputBox(
                     controller: ques,
                    error: false,
                    errorText: "",
                    inuptformat: [],
                    labelText: "Question",
                    obscureText: false,
                    ispassword: false,
                    istextarea: true,
                    readonly: false,
                    minLine:7 ,
                    onchanged: (value) {
                            
                    },
                 ),
                          ),
                        ),
                      ),
                    Padding(
                   padding: EdgeInsets.only( bottom: mainMargin),
                      child: PrimaryButton(
                        isloading: false,
                        title: "Post",
                        backgroundColor: primary,
                        foregroundColor: white,
                        borderRadius: buttonRadius,
                        onPressed: () {},
                        height: buttonHeight,
                        width: MediaQuery.of(context).size.width-2*mainMargin,
                      ),
                    )
                  ],
                ),
              ),
          ),
            ),
        );
      },
    );
  }
}

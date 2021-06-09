import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mhcare/models/appuser.dart';
import 'package:mhcare/theme/Style.dart';
import 'package:mhcare/theme/colors.dart';
import 'package:mhcare/widget/Buttons.dart';
import 'package:mhcare/widget/answerTile.dart';
import 'package:mhcare/widget/inputbox.dart';

class QNA extends StatefulWidget {
  @override
  _QNAState createState() => _QNAState();
}

class _QNAState extends State<QNA> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int activeDay = 3;
    Appuser user;

  TextEditingController ans;

  bool isloading = false; 

  @override
  void initState() {
    ans = TextEditingController();
  
    super.initState();
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
            Container(
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
                          "RG",
                          style: TextStyle(
                              color: white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    title: Text("Reema Jiyani"),
                    subtitle: Text("12/05/21 12:37 AM PST"),
                  ),
                  ListTile(
                    title: Text('What causes depression?'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: subMargin),
                          child: Text(
                            'We all have days when we feel down, but those feelings usually pass without having too much impact on our lives. But if they last beyond a couple of weeks or you feel as though things are getting worse, it could be a sign that you’re experiencing depression.',
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
                              InkWell(
                                onTap: () {
                                  addresponse();
                                },
                                child: Container(
                                  width: 155,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
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
                                          style: TextStyle(color: dark),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Text("2 Responses")
                            ],
                          ),
                        )
                      ],
                    ),
                    
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
                  child: ListView.separated(
                      padding: EdgeInsets.symmetric(vertical: subMargin),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return AnswerTile(
                          name: "Mayank G",
                          answer: "Just relax and take long breath!",
                          answerby_admin: index.isEven ? true : false,
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 0,
                        );
                      },
                      itemCount: 2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addresponse() {
    showModalBottomSheet<void>(
      enableDrag: true,
      isScrollControlled: true,
      context: context,
      backgroundColor: white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(subMargin)),
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
                      title: AppTitle(title: "Add Response"),
                      actions: [
                        Padding(
                          padding: EdgeInsets.only(right: subMargin - 6),
                          child: IconButton(
                            icon: Icon(
                              Icons.close,
                              color: dark,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                      automaticallyImplyLeading: false,
                    ),
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: mainMargin,
                              bottom: mainMargin,
                              right: mainMargin),
                          child: inputBox(
                            controller: ans,
                            error: false,
                            errorText: "",
                            inuptformat: [],
                            labelText: "Question",
                            obscureText: false,
                            ispassword: false,
                            istextarea: true,
                            readonly: false,
                            minLine: 7,
                            onchanged: (value) {},
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: mainMargin),
                      child: PrimaryButton(
                        isloading: false,
                        title: "Post",
                        backgroundColor: primary,
                        foregroundColor: white,
                        borderRadius: buttonRadius,
                        onPressed: () {},
                        height: buttonHeight,
                        width:
                            MediaQuery.of(context).size.width - 2 * mainMargin,
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

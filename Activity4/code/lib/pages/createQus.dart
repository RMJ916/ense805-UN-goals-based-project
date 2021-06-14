import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mhcare/theme/Style.dart';
import 'package:mhcare/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:mhcare/widget/Buttons.dart';
import 'package:mhcare/widget/inputbox.dart';
import 'package:mhcare/widget/snackbar.dart';

class CreateQus extends StatefulWidget {
  @override
  _CreateQusState createState() => _CreateQusState();
}

class _CreateQusState extends State<CreateQus> {
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
    var size = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: primary,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Create Question",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: black),
        ),
      ),
      backgroundColor: white,
      body: Container(
        decoration: BoxDecoration(color: white),
        padding: EdgeInsets.all(mainMargin),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            inputBox(
              istextarea: true,
              ispassword: false,
              minLine: 4,
              error: false,
              controller: ques,
              errorText: "",
              labelText: "Question",
              obscureText: false,
              onchanged: (value) {},
              readonly: false,
            ),
            SizedBox(
              height: mainMargin,
            ),
            PrimaryButton(
              backgroundColor: primary,
              foregroundColor: white,
              height: buttonHeight,
              title: "Post",
              isloading: isloading,
              onPressed: () {
                if (ques.text == '') {
                  CustomSnackBar(
                          actionTile: "Close",
                          scaffoldKey: scaffoldKey,
                          haserror: true,
                          isfloating: true,
                          onPressed: () {},
                          title:
                              // "Something went wrong ,Try again later!"
                              "Please enter details!")
                      .show();
                } else {
                  setState(() {
                    isloading = true;
                  });
                  FirebaseFirestore.instance.collection('questions').add({
                    "answered": false,
                    "bestanswer": '',
                    "qus": ques.text,
                    "qusby": FirebaseAuth.instance.currentUser.uid,
                    "timestamp": Timestamp.now(),
                    "total_answer": 0,
                    "best_ans_id": ''
                  }).then((value) {
                    Navigator.pop(context, "true");
                  });
                }
              },
              width: size.width - 2 * mainMargin,
            )
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mhcare/models/appuser.dart';
import 'package:mhcare/providers/UserProvider.dart';
import 'package:mhcare/theme/Style.dart';
import 'package:mhcare/theme/colors.dart';
import 'package:mhcare/widget/Buttons.dart';
import 'package:mhcare/widget/inputbox.dart';
import 'package:mhcare/widget/snackbar.dart';
import 'package:provider/provider.dart';

class AddResponse extends StatefulWidget {
  String id;
  int tans;
  AddResponse({this.id, this.tans});
  @override
  _AddResponseState createState() => _AddResponseState();
}

class _AddResponseState extends State<AddResponse> {
  Appuser user;

  TextEditingController ans;

  bool isloading = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    ans = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<UserProvider>(builder: (context, UserProvider, child) {
      user = UserProvider.user;

      return Scaffold(
          key: scaffoldKey,
          backgroundColor: grey,
          appBar: AppBar(
            title: AppTitle(title: "Add Answer"),
            leading: IconButton(
              icon: Icon(
                Icons.close,
                color: dark,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Container(
            padding: EdgeInsets.all(mainMargin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                inputBox(
                  controller: ans,
                  error: false,
                  errorText: "",
                  inuptformat: [],
                  labelText: "Anser",
                  obscureText: false,
                  ispassword: false,
                  istextarea: true,
                  readonly: false,
                  minLine: 4,
                  onchanged: (value) {},
                ),
                SizedBox(
                  height: mainMargin,
                ),
                PrimaryButton(
                  isloading: isloading,
                  title: "Post",
                  backgroundColor: primary,
                  foregroundColor: white,
                  borderRadius: buttonRadius,
                  onPressed: () {
                    if (ans.text == '') {
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
                      FirebaseFirestore.instance
                          .collection('questions')
                          .doc(widget.id)
                          .collection('ans')
                          .add({
                        "answers": ans.text,
                        "by": FirebaseAuth.instance.currentUser.uid,
                        "name": user.fname + " " + user.lname,
                        "type": "user",
                        "timestamp": Timestamp.now(),
                      }).then((value) {
                        FirebaseFirestore.instance
                            .collection('questions')
                            .doc(widget.id)
                            .set({
                          "answered": false,
                          "total_answer": (widget.tans + 1)
                        }, SetOptions(merge: true)).then((value) {
                          Navigator.pop(context, "true");
                        });
                      });
                    }
                  },
                  height: buttonHeight,
                  width: MediaQuery.of(context).size.width - 2 * mainMargin,
                )
              ],
            ),
          ));
    });
  }
}

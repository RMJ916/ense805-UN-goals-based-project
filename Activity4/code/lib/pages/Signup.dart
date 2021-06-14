import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:mhcare/pages/Dashboard.dart';
import 'package:mhcare/providers/UserProvider.dart';
import 'package:mhcare/theme/Style.dart';
import 'package:mhcare/theme/colors.dart';
import 'package:mhcare/widget/Buttons.dart';
import 'package:mhcare/widget/inputbox.dart';
import 'package:mhcare/widget/snackbar.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController email, pass, fname, lname, cpass, city, state, country;
  RangeValues _currentRangeValues = const RangeValues(0, 100);
  var date;

  bool tnc = false;
  bool isloading = false;
  bool email_error = false, pass_error = false;
  bool date_error = false, fname_erorr = false;
  bool lname_error = false;
  bool city_error = false;
  bool state_error = false;
  bool country_error = false;
  String checkbox_eror = '';
  String general_error = '';
  String email_text = '';
  String pass_text = '';
  String cpass_text = '';
  String fname_text = '';
  String lname_text = '';
  String city_text = '';
  String state_text = '';
  String country_text = '';

  FirebaseAuth auth = FirebaseAuth.instance;

  void uploadProfileanddata(
      BuildContext context, UserCredential userCredential) async {}

  void signup(BuildContext context) async {
    try {
      // UserCredential userCredential = await FirebaseAuth.instance
      //     .createUserWithEmailAndPassword(
      //         email: email.text, password: pass.text);
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.text, password: pass.text)
          .then((value) {
        try {
          final CollectionReference postsRef =
              FirebaseFirestore.instance.collection('users');
          var data = {
            "email": email.text,
            "fname": fname.text,
            "lname": lname.text,
            "birthdate": Timestamp.fromDate(DateTime.parse(date)),
            "city": city.text,
            "state": state.text,
            "country": country.text,
            "saved_posts": [],
            'saved_events': [],
            "lastseen": {}
          };

          CollectionReference _token =
              FirebaseFirestore.instance.collection('tokens');

     

          postsRef.doc(value.user.uid).set(data).then((value) {
            Provider.of<UserProvider>(context, listen: false)
                .fetchLogedUser()
                .then((value) {


                       FirebaseMessaging.instance.getToken().then((token) {
            FirebaseFirestore.instance
                .collection('usertoken')
                .doc(token)
                .set({'token': token}).then((done) {



                   Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (contex) => Dashboard()),
                  (route) => false);
                });
          });
             
            });
          });
        } catch (e) {
          print("something wrong,please try again latter");
        }
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        setState(() {
          pass_text = 'The password provided is too weak';
          pass_error = true;

          isloading = false;
          CustomSnackBar(
                  actionTile: "close",
                  haserror: true,
                  scaffoldKey: scaffoldKey,
                  isfloating: false,
                  onPressed: () {},
                  title: "The password provided is too weak!")
              .show();
        });
      } else if (e.code == 'email-already-in-use') {
        setState(() {
          email_text = 'The account already exists for this email';
          email_error = true;
          isloading = false;
          CustomSnackBar(
                  actionTile: "close",
                  haserror: true,
                  scaffoldKey: scaffoldKey,
                  isfloating: false,
                  onPressed: () {},
                  title: "The account already exists for this email!")
              .show();
        });
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    email = TextEditingController();
    pass = TextEditingController();
    cpass = TextEditingController();
    fname = TextEditingController();
    lname = TextEditingController();

    city = TextEditingController();
    state = TextEditingController();
    country = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      key: scaffoldKey,
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: white,
        elevation: 0,
        // title: Text(
        //   "Create an Account",
        //   style: TextStyle(
        //       color: primary, fontWeight: FontWeight.bold, fontSize: 30),
        // ),
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
      ),
      body: Container(
        padding: EdgeInsets.all(mainMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overscroll) {
                if (overscroll.leading) {
                  // loadmore();
                  overscroll.disallowGlow();
                } else {
                  overscroll.disallowGlow();
                }
              },
              child: ListView(
                children: [
                  Text(
                    "Create Account",
                    style: TextStyle(
                        color: dark, fontWeight: FontWeight.bold, fontSize: 35),
                  ),
                  SizedBox(
                    height: mainMargin,
                  ),
                  inputBox(
                    controller: fname,
                    error: fname_erorr,
                    errorText: "",
                    readonly: isloading,
                    // inuptformat: [
                    //   new WhitelistingTextInputFormatter(RegExp("[a-zA-Z]")),
                    //   BlacklistingTextInputFormatter(new RegExp('[\\ ]')),
                    // ],
                    labelText: "First Name",
                    obscureText: false,
                    ispassword: false,
                    istextarea: false,
                    onchanged: (value) {
                      setState(() {
                        fname_erorr = false;
                      });
                    },
                  ),
                  SizedBox(
                    height: mainMargin,
                  ),
                  inputBox(
                    controller: lname,
                    error: lname_error,
                    errorText: "",
                    readonly: isloading,
                    // inuptformat: [
                    //   new WhitelistingTextInputFormatter(RegExp("[a-zA-Z]")),
                    //   BlacklistingTextInputFormatter(new RegExp('[\\ ]')),
                    // ],
                    labelText: "Last Name",
                    obscureText: false,
                    ispassword: false,
                    istextarea: false,
                    onchanged: (value) {
                      setState(() {
                        lname_error = false;
                      });
                    },
                  ),
                  SizedBox(
                    height: mainMargin,
                  ),
                  inputBox(
                    controller: email,
                    error: email_error,
                    readonly: isloading,
                    errorText: "",
                    inuptformat: [
                      BlacklistingTextInputFormatter(new RegExp('[\\ ]')),
                    ],
                    labelText: "Email Address",
                    obscureText: false,
                    ispassword: false,
                    istextarea: false,
                    onchanged: (value) {
                      setState(() {
                        email_error = false;
                      });
                    },
                  ),
                  SizedBox(
                    height: mainMargin,
                  ),
                  inputBox(
                    controller: pass,
                    error: pass_error,
                    readonly: isloading,
                    errorText: "",
                    inuptformat: [],
                    labelText: "Password",
                    obscureText: true,
                    ispassword: true,
                    istextarea: false,
                    onchanged: (value) {
                      setState(() {
                        pass_error = false;
                      });
                    },
                  ),
                  SizedBox(
                    height: mainMargin,
                  ),
                  DateTimePicker(
                    maxLines: 1,
                    type: DateTimePickerType.date,
                    dateMask: 'd MMM, yyyy',
                    readOnly: isloading,
                    autofocus: false,
                    decoration: InputDecoration(
                        errorText: date_error ? "" : null,
                        contentPadding: EdgeInsets.only(
                            right: subMargin,
                            left: subMargin,
                            bottom: subMargin,
                            top: subMargin),
                        errorStyle: TextStyle(color: errorColor, height: 0),
                        labelStyle:
                            TextStyle(color: dark, fontSize: subMargin + 2),
                        hintText: "Select Birthday",
                        labelText: "Select Birthday",
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(buttonRadius),
                          borderSide: BorderSide(width: 2, color: primary),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(buttonRadius),
                          borderSide: BorderSide(width: 1, color: grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(buttonRadius),
                          borderSide: BorderSide(width: 1, color: black),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(buttonRadius),
                            borderSide: BorderSide(
                              width: 1,
                            )),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(buttonRadius),
                            borderSide:
                                BorderSide(width: 1.5, color: errorColor)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(buttonRadius),
                            borderSide:
                                BorderSide(width: 2, color: errorColor)),
                        suffixIcon: Icon(
                          Icons.event_outlined,
                          color: dark.withOpacity(0.4),
                          size: 30,
                        )),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                    selectableDayPredicate: (date) {
                      if (date.weekday == 6 || date.weekday == 7) {
                        return true;
                      }
                      return true;
                    },
                    onChanged: (val) {
                      setState(() {
                        date = val;
                        date_error = false;
                        isloading = false;
                      });
                    },
                    validator: (val) {
                      setState(() => date = val);
                      return null;
                    },
                    onSaved: (val) {
                      setState(() {
                        date = val;
                        date_error = false;
                      });
                    },
                  ),
                  SizedBox(
                    height: mainMargin,
                  ),
                  inputBox(
                    controller: city,
                    error: city_error,
                    minLine: 3,
                    errorText: "",
                    readonly: isloading,
                    inuptformat: [],
                    labelText: "City",
                    obscureText: false,
                    ispassword: false,
                    istextarea: true,
                    onchanged: (value) {
                      setState(() {
                        city_error = false;
                      });
                    },
                  ),
                  SizedBox(
                    height: mainMargin,
                  ),
                  inputBox(
                    controller: state,
                    error: state_error,
                    minLine: 3,
                    errorText: "",
                    readonly: isloading,
                    inuptformat: [],
                    labelText: "State",
                    obscureText: false,
                    ispassword: false,
                    istextarea: true,
                    onchanged: (value) {
                      setState(() {
                        state_error = false;
                      });
                    },
                  ),
                  SizedBox(
                    height: mainMargin,
                  ),
                  inputBox(
                    controller: country,
                    error: country_error,
                    minLine: 3,
                    errorText: "",
                    readonly: isloading,
                    inuptformat: [],
                    labelText: "Country",
                    obscureText: false,
                    ispassword: false,
                    istextarea: true,
                    onchanged: (value) {
                      setState(() {
                        city_error = false;
                      });
                    },
                  ),
                ],
              ),
            )),
            SizedBox(
              height: mainMarginHalf,
            ),
            Container(
              height: 50,
              child: Stack(
                children: [
                  Positioned(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          child: Checkbox(
                            value: tnc,
                            onChanged: (value) {
                              setState(() {
                                tnc = !tnc;
                              });
                            },
                            activeColor: primary,
                          ),
                        ),
                        Expanded(
                            child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'I agree to the ',
                                style: TextStyle(
                                    color: dark.withOpacity(0.6), fontSize: 16),
                              ),
                              TextSpan(
                                text: 'Terms & Conditions',
                                style: TextStyle(
                                    color: dark,
                                    decoration: TextDecoration.underline,
                                    fontSize: 16),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // single tapped
                                  },
                              ),
                              TextSpan(
                                text: ' and ',
                                style: TextStyle(
                                    color: dark.withOpacity(0.6), fontSize: 16),
                              ),
                              TextSpan(
                                text: 'Privacy Policy ',
                                style: TextStyle(
                                    color: dark,
                                    decoration: TextDecoration.underline,
                                    fontSize: 16),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // long pressed
                                  },
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                    left: -15,
                    width: MediaQuery.of(context).size.width - 3 * mainMargin,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: mainMarginHalf,
            ),
            Hero(
              tag: 'button',
              child: PrimaryButton(
                isloading: isloading,
                onPressed: () {
                  setState(() {
                    isloading = true;
                  });
                  try {
                    setState(() {
                      fname_erorr = fname.text == "" ? true : false;
                      lname_error = lname.text == "" ? true : false;
                      email_error = email.text == "" ? true : false;

                      pass_error = pass.text == "" ? true : false;

                      date_error = date == null ? true : false;
                      city_error = city.text == "" ? true : false;
                      state_error = state.text == "" ? true : false;
                      country_error = country.text == "" ? true : false;
                      isloading = false;
                    });
                  } finally {
                    if (fname_erorr ||
                        fname_erorr ||
                        email_error ||
                        pass_error ||
                        date_error ||
                        city_error ||
                        state_error ||
                        country_error) {
                      isloading = false;

                      CustomSnackBar(
                              actionTile: "Close",
                              haserror: true,
                              isfloating: false,
                              scaffoldKey: scaffoldKey,
                              title: "Please fillup all details!")
                          .show();
                    } else {
                      if (!RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(email.text)) {
                        print("not  email");
                        setState(() {
                          CustomSnackBar(
                                  actionTile: "close",
                                  haserror: true,
                                  isfloating: false,
                                  scaffoldKey: scaffoldKey,
                                  onPressed: () {},
                                  title: "Please enter valid email!")
                              .show();
                          email_error = true;
                          isloading = false;
                        });
                      } else if (!tnc) {
                        setState(() {
                          CustomSnackBar(
                                  actionTile: "close",
                                  haserror: true,
                                  isfloating: false,
                                  scaffoldKey: scaffoldKey,
                                  onPressed: () {},
                                  title:
                                      "Please accept Terms & Conditions and Privacy Policy!")
                              .show();
                          isloading = false;
                        });
                      } else {
                        setState(() {
                          isloading = true;
                        });
                        signup(context);
                      }
                    }
                  }
                },
                title: "Continue",
                backgroundColor: primary,
                foregroundColor: white,
                height: 50,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

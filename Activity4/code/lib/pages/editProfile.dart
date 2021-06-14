import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mhcare/models/appuser.dart';
import 'package:mhcare/providers/UserProvider.dart';
import 'package:mhcare/theme/Style.dart';
import 'package:mhcare/theme/colors.dart';
import 'package:mhcare/widget/Buttons.dart';
import 'package:mhcare/widget/inputbox.dart';
import 'package:mhcare/widget/snackbar.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  Appuser user;
  EditProfile({this.user});
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController fname, lname, city, state, country;
  RangeValues _currentRangeValues = const RangeValues(0, 100);
  var date;
  Appuser user;
  bool tnc = false;
  bool isloading = false;
  bool date_error = false, fname_erorr = false;
  bool lname_error = false;
  bool city_error = false;
  bool state_error = false;
  bool country_error = false;
  String checkbox_eror = '';
  String general_error = '';
  String fname_text = '';
  String lname_text = '';
  String city_text = '';
  String state_text = '';
  String country_text = '';

  FirebaseAuth auth = FirebaseAuth.instance;

  void uploadProfileanddata(
      BuildContext context, UserCredential userCredential) async {}

  void editProfile(BuildContext context, UserProvider userProvider) async {
    try {
      final CollectionReference postsRef =
          FirebaseFirestore.instance.collection('users');
      var data = {
        "fname": fname.text,
        "lname": lname.text,
        "birthdate": Timestamp.fromDate(DateTime.parse(date.toString())),
        "city": city.text,
        "state": state.text,
        "country": country.text,
      };
      postsRef
          .doc(FirebaseAuth.instance.currentUser.uid)
          .set(data, SetOptions(merge: true))
          .then((value) {
        Provider.of<UserProvider>(context, listen: false)
            .fetchLogedUser()
            .then((value) {
          userProvider.fetchLogedUser().then((value) {
            if (value) {
              Navigator.pop(context, "updated");
            } else {
              Navigator.pop(context, "fail");
            }
          });
        });
      });
    } catch (e) {
      print(e);
      print("something wrong,please try again latter");
    }
  }

  @override
  void initState() {
    fname = TextEditingController();
    lname = TextEditingController();

    city = TextEditingController();
    state = TextEditingController();
    country = TextEditingController();
    if (widget.user != null) {
      user = widget.user;
      fname.text = user.fname;
      lname.text = user.lname;
      city.text = user.city;
      state.text = user.state;
      country.text = user.country;
      // dateOfBirth.text = DateTime.fromMillisecondsSinceEpoch(
      //         user.birthdate.millisecondsSinceEpoch)
      //     .toString()
      //     .substring(0, 10);

      date = user.birthdate.toDate();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, UserProvider, child) {
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
          title: AppTitle(title: "Edit Profile"),
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
                    DateTimePicker(
                      maxLines: 1,
                      type: DateTimePickerType.date,
                      dateMask: 'd MMM, yyyy',
                      readOnly: isloading,
                      autofocus: false,
                      initialValue: user.birthdate != null
                          ? DateTime.fromMillisecondsSinceEpoch(
                                  user.birthdate.millisecondsSinceEpoch)
                              .toString()
                          : null,
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
              PrimaryButton(
                onPressed: () {
                  setState(() {
                    isloading = true;
                  });
                  try {
                    setState(() {
                      fname_erorr = fname.text == "" ? true : false;
                      lname_error = lname.text == "" ? true : false;

                      date_error = date == null ? true : false;
                      city_error = city.text == "" ? true : false;
                      state_error = state.text == "" ? true : false;
                      country_error = country.text == "" ? true : false;
                      isloading = false;
                    });
                  } finally {
                    if (fname_erorr ||
                        fname_erorr ||
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
                      setState(() {
                        isloading = true;
                      });
                      editProfile(context, UserProvider);
                    }
                  }
                },
                title: "Save",
                backgroundColor: primary,
                foregroundColor: white,
                height: 50,
                isloading: isloading,
              ),
            ],
          ),
        ),
      );
    });
  }
}

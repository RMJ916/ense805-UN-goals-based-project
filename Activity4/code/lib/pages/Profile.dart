import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mhcare/models/appuser.dart';
import 'package:mhcare/pages/savedItem.dart';
import 'package:mhcare/pages/stepOne.dart';
import 'package:mhcare/widget/profileTile.dart';
import 'package:mhcare/widget/snackbar.dart';
import 'package:provider/provider.dart';
import 'package:mhcare/pages/editProfile.dart';
import 'package:mhcare/providers/UserProvider.dart';
import 'package:mhcare/theme/colors.dart';
import 'package:mhcare/theme/Style.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Appuser user;
  TextEditingController email, fname, lname, city, state, country;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    email = TextEditingController();
    fname = TextEditingController();
    lname = TextEditingController();

    city = TextEditingController();
    state = TextEditingController();
    country = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<UserProvider>(builder: (context, UserProvider, child) {
      user = UserProvider.user;
      if (user != null) {
        email.text = user.email;
        fname.text = user.fname;
        lname.text = user.lname;
        city.text = user.city;
        state.text = user.state;
        country.text = user.country;
        
      }
      return user == null
          ? CircularProgressIndicator.adaptive()
          : Scaffold(
              key: scaffoldKey,
              backgroundColor: grey,
              appBar: AppBar(
                title: AppTitle(title: "Profile"),
                actions: [
                  Padding(
                    padding: EdgeInsets.only(right: 4),
                    child: IconButton(
                      icon: Icon(
                        FontAwesome.bookmark,
                        color: dark,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute( 
                              builder: (context) => SavedItems()),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: mainMargin),
                    child: IconButton(
                      icon: Icon(
                        FontAwesome.power_off,
                        color: dark,
                      ),
                      onPressed: () {

                       FirebaseMessaging.instance.getToken().then((token) {
            FirebaseFirestore.instance
                .collection('usertoken')
                .doc(token)
                .delete().then((done) {
                        FirebaseAuth.instance.signOut().then((value) {

                               Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Stepone()),
                              (route) => false);
  });
                          


                });
          });
                     
                      
                      },
                    ),
                  ),
                ],
              ),
              body: RefreshIndicator(
                  color: primary,
                  backgroundColor: grey,
                  onRefresh: () async
                  {
await UserProvider.refreshAuthdata();

                  },
                child: ListView(
                
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: white,
                          boxShadow: [
                            BoxShadow(
                              color: grey.withOpacity(0.01),
                              spreadRadius: 10,
                              blurRadius: 3,
                              // changes position of shadow
                            ),
                          ],
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(2 * subMargin),
                              bottomRight: Radius.circular(2 * subMargin))),
                      child: Padding(
                        padding: EdgeInsets.all(subMargin),
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  // color: primary,
                                  color: white,
                                  borderRadius:
                                      BorderRadius.circular(subMargin),
                                  boxShadow: [
                                    BoxShadow(
                                      color: primary.withOpacity(0.01),
                                      spreadRadius: 10,
                                      blurRadius: 3,
                                      // changes position of shadow
                                    ),
                                  ]),
                              child: Padding(
                                padding: EdgeInsets.all(subMargin),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        
                                        Text(
                                          user.fname + " " + user.lname,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: dark),
                                        ),

                                        Padding(
                                          padding: EdgeInsets.only(top: 5),
                                          child: Text(
                                            !FirebaseAuth.instance.currentUser
                                                    .emailVerified
                                                ? "Your email is not verified!"
                                                : "Your email is verified",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                color: dark),
                                          ),
                                        )
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditProfile(
                                                      user: user,
                                                    ))).then((value) {
                                          if (value == 'updated') {
                                            CustomSnackBar(
                                                    actionTile: "Close",
                                                    scaffoldKey: scaffoldKey,
                                                    haserror: false,
                                                    isfloating: true,
                                                    onPressed: () {},
                                                    title:
                                                        "Your Profile has been updated successfully!")
                                                .show();
                                          } else if (value == "fail") {
                                            CustomSnackBar(
                                                    actionTile: "Close",
                                                    scaffoldKey: scaffoldKey,
                                                    haserror: false,
                                                    isfloating: true,
                                                    onPressed: () {},
                                                    title:
                                                        "Something went wrong ,Try again later!")
                                                .show();
                                          }
                                        });
                                       
                                      },
                                      child: Container(
                                        width: 70,
                                        height: 35,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: !FirebaseAuth
                                                        .instance
                                                        .currentUser
                                                        .emailVerified
                                                    ? dark
                                                    : primary,
                                                width: 2)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 12),
                                          child: Center(
                                            child: Text(
                                              "Edit",
                                              style: TextStyle(
                                                  color: !FirebaseAuth
                                                          .instance
                                                          .currentUser
                                                          .emailVerified
                                                      ? dark
                                                      : primary),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: mainMargin,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProfileTile(
                            title: "Email",
                            icon: Icons.email_rounded,
                            isverifiyed:
                                FirebaseAuth.instance.currentUser.emailVerified
                                    ? true
                                    : false,
                            send:
                                FirebaseAuth.instance.currentUser.emailVerified
                                    ? false
                                    : true,
                            value: user.email,
                          ),
                          SizedBox(
                            height: mainMargin,
                          ),
                          ProfileTile(
                            title: "Birthdate",
                            icon: Icons.event,
                            isverifiyed: false,
                            send: false,
                            value: user.birthdate
                                .toDate()
                                .toLocal()
                                .toString()
                                .substring(0, 10),
                          ),
                          SizedBox(
                            height: mainMargin,
                          ),
                          ProfileTile(
                            title: "Address",
                            icon: Icons.location_city,
                            isverifiyed: false,
                            send: false,
                            value: user.city +
                                ", " +
                                user.state +
                                ", " +
                                user.country,
                          ),
                          SizedBox(
                            height: mainMargin,
                          ),
                          Center(
                              child: Text(
                            "Version: 1.0.0",
                            style: eventtitle,
                          ))
                        ],
                      ),
                    )
                  ],
                ),
              ));
    });
  }
}

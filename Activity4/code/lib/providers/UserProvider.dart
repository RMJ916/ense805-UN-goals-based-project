import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mhcare/models/appPost.dart';
import 'package:mhcare/models/appuser.dart';
import 'package:mhcare/widget/snackbar.dart';

class UserProvider with ChangeNotifier {
  Appuser user;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  DocumentSnapshot mydata;

  UserProvider() {
    fetchLogedUser();
  }

  Future<bool> fetchLogedUser() async {
    print("fetching userdata from server");
    bool code = false;
    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser.uid)
          .snapshots() 
          .listen((DocumentSnapshot snapshot) {
        var data = snapshot.data();
        mydata = snapshot;
        user = Appuser.fromJson(data);
        code = true;
        loadsavedpost();
        notifyListeners();
      });
      notifyListeners();
    }
    return code;
  }

  Future<bool> refreshAuthdata() async {
    await FirebaseAuth.instance.currentUser.reload().then((value) {
      print("email verfified:");
      print(FirebaseAuth.instance.currentUser.emailVerified);
      notifyListeners();
      return true;
    });
  }

  sendVerificationemail() {
    try {
      FirebaseAuth.instance.currentUser.sendEmailVerification().then((value) {
        CustomSnackBar(
                actionTile: "close",
                haserror: false,
                scaffoldKey: scaffoldKey,
                isfloating: false,
                onPressed: () {},
                title: "Email Verification mail sent successfully!")
            .show();
      });
    } catch (e) {
      CustomSnackBar(
              actionTile: "close",
              haserror: true,
              scaffoldKey: scaffoldKey,
              isfloating: false,
              onPressed: () {},
              title: e.code.toString())
          .show();
    }
  }

  savePost({String id, String bid}) async {
    List<String> saved = user.saved_posts;
    saved.add(bid + "-split-" + id);
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .set({"saved_posts": saved}, SetOptions(merge: true)).then((value) {
      print("saved post:" + id);
      notifyListeners();
      fetchLogedUser();
      notifyListeners();
    });
  }

  removePostFromSaved({String id, String bid}) async {
    List<String> saved = user.saved_posts;
    saved.remove(bid + "-split-" + id);
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .set({"saved_posts": saved}, SetOptions(merge: true)).then((value) {
      print("removed post:" + id);

      notifyListeners();
      loadsavedpost();
    });
  }

  Map<String, AppPost> saved;
  Future<Map<String, AppPost>> loadsavedpost() async {
    print("saved item fetched");
    saved = {};
    for (String s in user.saved_posts) {
      FirebaseFirestore.instance
          .collection('broadcastrooms')
          .doc(s.split('-split-')[0])
          .collection('posts')
          .doc(s.split('-split-')[1])
          .snapshots() 
          .listen((value) {
        saved.putIfAbsent(
            s.split('-split-')[1], () => AppPost.fromJson(value.data()));
      });
      notifyListeners();
    }

    return saved;
  }

  void destroyUser() {
    user = null;
    notifyListeners();
  }
}

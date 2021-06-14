import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:mhcare/models/appPost.dart';
import 'package:mhcare/models/appuser.dart';
import 'package:mhcare/models/broadcastRoom.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sortedmap/sortedmap.dart';

class BroadcastProvider extends ChangeNotifier {
  Future<String> getLastDocid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String lastbdoc = prefs.getString("lastbroadcastid");
    return lastbdoc == null ? "nodoc" : lastbdoc;
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  int unseen = 0;
  String lastdocid;
  List<AppPost> bpost;
  Map<String, BroadcastRoom> broom;

  Map<String, Map<String, AppPost>> posts = {};
  BroadcastProvider() {
    loadbroadcastroom();
  }

  // loadunseenmsg() {
  //   getLastDocid().then((value) {
  //     if (value == "nodoc") {
  //       Stream bstream =
  //           FirebaseFirestore.instance.collection("broadcastrooms").orderBy("field").snapshots();
  //     } else {}
  //   });
  // }

  loadbroadcastroom() async {
    await firestore
        .collection('broadcastrooms')
        .orderBy('created_at')
        .get()
        .then((value) {
      print(value.docs);
      broom = {};
      for (DocumentSnapshot e in value.docs) {
        broom.putIfAbsent(
            e.id,
            () => BroadcastRoom(
                createdAt: e['created_at'],
                last_msg: e['last_msg'],
                name: e['name'],
                profilePicture: e['profile_picture'],
                totalMsg: e["total_msg"],
                id: e.id,
                unseen: 2));
        notifyListeners();
      }
      loadBroompost();
    });
    return true;
  }

  Map<String, DocumentSnapshot> lastdoc = {};

  loadBroompost() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      var data = snapshot.data();

      Appuser user = Appuser.fromJson(data);
      broom.forEach((key, value) {
        Map<String, AppPost> post = {};
        firestore
            .collection('broadcastrooms')
            .doc(key)
            .collection('posts')
            .orderBy('post_at')
            .limit(20)
            .snapshots()
            .listen((event) {
          event.docs.forEach((element) {
            
            post.putIfAbsent(
                element.id, () => AppPost.fromJson(element.data()));
            notifyListeners();
          });

          // var u1 = post.values.toList().where(
          //     (element) => element.postAt.compareTo(user.lastseen[key]) > 0);

          try {
            lastdoc[key] = event.docs.last;
          } catch (e) {
            lastdoc.putIfAbsent(key, () => event.docs.last);
          }
          posts.putIfAbsent(key, () => post);

          try{

          }catch(e)
          {


          }
        });
      });
    });
    notifyListeners();
  }

  LoadMorePost({
    String bid,
  }) {
    FirebaseFirestore.instance
        .collection('broadcastrooms')        .doc(bid)
            .collection('posts')
        .orderBy('post_at')
        .startAfterDocument (lastdoc[bid])
        .limit(20)
        .get()
        .then((event) {
      event.docs.forEach((element) {
        print(element.data()['title']);
        posts[bid]
            .putIfAbsent(element.id, () => AppPost.fromJson(element.data()));
        notifyListeners();
      });
      try {
        lastdoc[bid] = event.docs.last;
      } catch (e) {
        lastdoc.putIfAbsent(bid, () => event.docs.last);
      }
      notifyListeners();
    });
  }

  lastseenupdate({Appuser user, String id}) {
    if (posts[id] == null) return 0;
        if (user.lastseen[id] == null) return 0;
    var u1 = posts[id]
        .values
        .toList()
        .where((element) => element.postAt.compareTo(user.lastseen[id]) > 0);

    return u1.length;
  }

  likePost({String id, String bid, AppPost post}) async {
    List<String> likes = post.like;

    likes.add(FirebaseAuth.instance.currentUser.uid);
    print("bid" + bid);
    print("id" + id);
    await firestore
        .collection('broadcastrooms')
        .doc(bid)
        .collection('posts')
        .doc(id)
        .set({"like": likes}, SetOptions(merge: true)).then((value) {
      print("liked post:" + id);

      notifyListeners();
    });
  }

  removeLikeFromPost({String id, String bid, AppPost post}) {
    List<String> likes = post.like;

    likes.remove(FirebaseAuth.instance.currentUser.uid);
    firestore
        .collection('broadcastrooms')
        .doc(bid)
        .collection('posts')
        .doc(id)
        .set({"like": likes}, SetOptions(merge: true)).then((value) {
      notifyListeners();
    });
  }
}

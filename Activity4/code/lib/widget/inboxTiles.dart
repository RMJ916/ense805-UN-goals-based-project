import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mhcare/providers/UserProvider.dart';
import 'package:mhcare/theme/colors.dart';
import 'package:mhcare/pages/broadcastRoom.dart';
import 'package:mhcare/models/broadcastRoom.dart';
import 'package:provider/provider.dart';

class InboxTiles extends StatelessWidget {
  String title;
  String image_url;
  String lastmsg;
  String lastmsg_time;
  String unread;
  String name;
  BroadcastRoom br;
  InboxTiles(
      {this.image_url,
      this.lastmsg,
      this.lastmsg_time,
      this.title,
      this.br,
      this.name,
      this.unread});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
      child: ListTile(
        onTap: () {
          Map<String, dynamic> ls =
              Provider.of<UserProvider>(context, listen: false).user.lastseen;

          try {
            ls[br.id] = Timestamp.now();
          } catch (e) {
            ls.putIfAbsent(br.id, () => Timestamp.now());
          }
          FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser.uid)
              .set({
            'lastseen': ls
          }, SetOptions(merge: true)).then((value) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BoradcastRoomWidget(br: br)));
          });
        },
        leading: Container(
          decoration: BoxDecoration(
              border: Border.all(width: 2, color: primary),
              borderRadius: BorderRadius.circular(30)),
          child: SizedBox(
            width: 50,
            height: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Hero(
                tag: "image1",
                child: CachedNetworkImage(
                  imageUrl: image_url,
                  errorWidget: (context, url, error) => Container(
                      width: 50,
                      height: 50,
                      color: grey,
                      child: Center(
                        child: Text(
                          name[0].toUpperCase(),
                          style: TextStyle(color: dark),
                        ),
                      )),
                  placeholder: (context, value) {
                    return Container(
                      width: 46,
                      height: 46,
                      child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(dark),
                        backgroundColor: grey,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        title: Text(br.name),
        subtitle: Text(br.last_msg),
        trailing: unread == '0' || unread == null
            ? SizedBox.shrink()
            : SizedBox(
                child: Container(
                  width: unread.length == 1 ? 20 : (unread.length * 13.0),
                  height: 20,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), color: primary),
                  child: Center(
                      child: Text(
                    unread,
                    style: TextStyle(color: white),
                  )),
                ),
              ),
      ),
    );
  }
}

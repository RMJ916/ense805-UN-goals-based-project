import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mhadmin/models/broadcastRoom.dart';
import 'package:mhadmin/pages/CreateBRoom.dart';
import 'package:mhadmin/pages/CreatePost.dart';
import 'package:mhadmin/pages/stepOne.dart';
import 'package:mhadmin/providers/BordcastProvider.dart';
import 'package:mhadmin/providers/UserProvider.dart';
import 'package:mhadmin/theme/Style.dart';
import 'package:mhadmin/theme/colors.dart';
import 'package:mhadmin/widget/inboxTiles.dart';
import 'package:mhadmin/widget/loading.dart';
import 'package:mhadmin/widget/snackbar.dart';
import 'package:provider/provider.dart';

class DailyPage extends StatefulWidget {
  @override
  _DailyPageState createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
  int activeDay = 3;
  Map<String, BroadcastRoom> broom;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider, BroadcastProvider>(
        builder: (context, UserProvider, BroadcastProvider, child) {
      broom = BroadcastProvider.broom;
 
      return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: white,
          title: Text(
            "inbox",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: black),
          ),
         actions: [  Padding(
                    padding: EdgeInsets.only(right: 4),
                    child: IconButton(
                      icon: Icon(
                        FontAwesome.plus,
                        color: dark,
                      ),
                      onPressed: () {
                          Navigator.push(
                context, MaterialPageRoute(builder: (context) => CreateBroom())).then((value) {

                  if(value=="true")
                  {
                      CustomSnackBar(
                                                    actionTile: "Close",
                                                    scaffoldKey: scaffoldKey,
                                                    haserror: false,
                                                    isfloating: true,
                                                    onPressed: () {},
                                                    title:
                                                        // "Something went wrong ,Try again later!"
                                                       "Broadcast Room created!"
                                                        )
                                                .show();
                  }
                });
                      },
                    ),
                  ),
               ],),
        backgroundColor: white, floatingActionButton: FloatingActionButton(
          backgroundColor: primary,
          foregroundColor: white,
          onPressed: () {
            // addques();
            // addQuestion(user: UserProvider.user);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => CreatePost())).then((value) {

                  if(value=="true")
                  {
                      CustomSnackBar(
                                                    actionTile: "Close",
                                                    scaffoldKey: scaffoldKey,
                                                    haserror: false,
                                                    isfloating: true,
                                                    onPressed: () {},
                                                    title:
                                                        // "Something went wrong ,Try again later!"
                                                       "Post Added!"
                                                        )
                                                .show();
                  }
                });
          },
          child: Icon(Icons.add),
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: grey,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(mainMargin),
                        topRight: Radius.circular(mainMargin))),
                padding: EdgeInsets.all(mainMargin),
                child: RefreshIndicator(
                  onRefresh: () async {
                    await BroadcastProvider.loadbroadcastroom();
                  },
                  child: broom == null || BroadcastProvider.posts==null
                      ? Loading(
                          title: "Wait broadcast room is loading!",
                        )
                      : ListView.separated(
                          itemCount: broom.length,
                          itemBuilder: (context, index) {
                            BroadcastRoom br = broom.values.toList()[index];
                            print(br);
                            return InboxTiles(
                                image_url: br.profilePicture,
                                name: br.name,
                                lastmsg: br.last_msg,
                                lastmsg_time: "20/5/21",
                                title: br.name,
                                unread: BroadcastProvider.lastseenupdate(user: UserProvider.user,id: br.id).toString(),
                                br: br);
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: mainMargin,
                            );
                          },
                        ),
                ),
              ),
            ),
            // broom == null
            //     ? LinearProgressIndicator(
            //         backgroundColor: white,
            //       )
            //     : SizedBox.shrink()
          ],
        ),
      );
    });
  }
}

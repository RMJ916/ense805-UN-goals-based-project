import 'package:flutter/material.dart';
import 'package:mhcare/models/broadcastRoom.dart';
import 'package:mhcare/providers/BordcastProvider.dart';
import 'package:mhcare/providers/UserProvider.dart';
import 'package:mhcare/theme/Style.dart';
import 'package:mhcare/theme/colors.dart';
import 'package:mhcare/widget/inboxTiles.dart';
import 'package:mhcare/widget/loading.dart';
import 'package:provider/provider.dart';

class DailyPage extends StatefulWidget {
  @override
  _DailyPageState createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
  int activeDay = 3;
  Map<String, BroadcastRoom> broom;
  List<String> names = [
    "Today\'s Excercise",
    "Today\'s Energizer",
    "Today\'s Quotes",
    "Technical Help"
  ];
  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider, BroadcastProvider>(
        builder: (context, UserProvider, BroadcastProvider, child) {
      broom = BroadcastProvider.broom;
 
      return Scaffold(
        appBar: AppBar(
          backgroundColor: white,
          title: Text(
            "Inbox",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: black),
          ),
          // actions: [
          //   Padding(
          //     padding: EdgeInsets.only(right: mainMargin),
          //     child: IconButton(
          //       icon: Icon(Icons.search),
          //       onPressed: () {},
          //       color: dark,
          //     ),
          //   )
          // ],
        ),
        backgroundColor: white,
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

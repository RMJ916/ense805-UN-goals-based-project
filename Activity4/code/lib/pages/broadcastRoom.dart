import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mhcare/models/broadcastRoom.dart';
import 'package:mhcare/providers/BordcastProvider.dart';
import 'package:mhcare/providers/UserProvider.dart';
import 'package:mhcare/theme/Style.dart';
import 'package:mhcare/theme/colors.dart';
import 'package:mhcare/widget/BoradcastPost.dart';
import 'package:mhcare/widget/loading.dart';
import 'package:provider/provider.dart';

class BoradcastRoomWidget extends StatefulWidget {
  BroadcastRoom br;
  BoradcastRoomWidget({this.br});
  @override
  _BoradcastRoomState createState() => _BoradcastRoomState();
}

class _BoradcastRoomState extends State<BoradcastRoomWidget> {
  bool _pinned = true;
  bool _snap = false;
  bool _floating = false;
  ScrollController _scrollController;
  Color _theme;

  @override
  void initState() {
    super.initState();
    _theme = Colors.white;

    _scrollController = ScrollController()
      ..addListener(
        () => _isAppBarExpanded
            ? _theme != Colors.black
                ? setState(
                    () {
                      _theme = Colors.black;
                      print('setState is called');
                    },
                  )
                : {}
            : _theme != Colors.white
                ? setState(() {
                    print('setState is called');
                    _theme = Colors.white;
                  })
                : {},
      );
  }

  bool get _isAppBarExpanded {
    return _scrollController.hasClients &&
        _scrollController.offset > (200 - kToolbarHeight);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider, BroadcastProvider>(
        builder: (context, UserProvider, BroadcastProvider, child) {
      print(BroadcastProvider.posts[widget.br.id]);
      return Scaffold(
          backgroundColor: white,
          appBar: AppBar(
            brightness: Brightness.light,
            backgroundColor: white,
            elevation: 0,
            // title: Text(
            //   "Create an Account",
            //   style: TextStyle(
            //       color: primary, fontWeight: FontWeight.bold, fontSize: 30),
            // ),
            title: AppTitle(title: widget.br.name),
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
            padding: EdgeInsets.all(subMargin),
            decoration: BoxDecoration(
                color: grey,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(subMargin),
                    topRight: Radius.circular(subMargin))),
            child:BroadcastProvider.posts[widget.br.id]==null || BroadcastProvider.posts[widget.br.id].length == 0 
                ? NoData(
                    title: "No Post found, Please visit later!",
                  )
                : NotificationListener<OverscrollNotification>(
                    onNotification: (value) {
                      if (value.overscroll > 0) {
                        print("load more");
                        BroadcastProvider.LoadMorePost(bid: widget.br.id);
                      } else {
                        print("no getch");
                      }
                      return true;
                    },
                    child: ListView.separated(
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          print(BroadcastProvider.posts);
                          return BroadcastPost(
                            post: BroadcastProvider.posts[widget.br.id].values
                                .toList()[index],
                            id: BroadcastProvider.posts[widget.br.id].keys
                                .toList()[index],
                            bid: widget.br.id,
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: mainMargin,
                          );
                        },
                        itemCount:
                            BroadcastProvider.posts[widget.br.id].length),
                  ),
          ));
    });
  }
}

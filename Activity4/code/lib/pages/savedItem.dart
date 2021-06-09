import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mhcare/models/appPost.dart';
import 'package:mhcare/models/appuser.dart';
import 'package:mhcare/providers/UserProvider.dart';
import 'package:mhcare/theme/Style.dart';
import 'package:mhcare/theme/colors.dart';
import 'package:mhcare/widget/BoradcastPost.dart'; 
import 'package:mhcare/widget/hideoverglow.dart';
import 'package:mhcare/widget/loading.dart';
import 'package:provider/provider.dart';

class SavedItems extends StatefulWidget {
  @override
  _SavedItemsState createState() => _SavedItemsState();
}

class _SavedItemsState extends State<SavedItems> {
  Appuser user;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<UserProvider>(builder: (context, UserProvider, child) {
      user = UserProvider.user;
      Map<String, AppPost> saved = UserProvider.saved;
      if (user == null || saved==null) {
        return CircularProgressIndicator.adaptive();
      } else {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: grey,
            appBar: AppBar(
              title: AppTitle(title: "Saved Posts"),
              //             bottom:  TabBar(
              //   tabs: [
              //     Tab( text: "Posts",),
              //     Tab( text: "Events",),
              //   ]
              // ),
            ),
            body: Container(
              decoration: BoxDecoration(
                  color: grey,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(mainMargin),
                      topRight: Radius.circular(mainMargin))),
              padding: EdgeInsets.all(subMargin),
              child:saved.length==0?NoData(title: "No Saved Posts!",) :HideOverGlow(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: saved.length,
                  itemBuilder: (context, index) {
                    return BroadcastPost(
                      id: saved.keys.toList()[index],
                      post: saved.values.toList()[index],
                      bid: user.saved_posts[index].split('-split-')[0],
                    );
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
        );
      }
    });
  }
}

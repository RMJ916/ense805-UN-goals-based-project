import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mhadmin/models/appPost.dart';
import 'package:mhadmin/providers/BordcastProvider.dart';
import 'package:mhadmin/providers/UserProvider.dart';
import 'package:mhadmin/theme/Style.dart';
import 'package:mhadmin/theme/colors.dart';
import 'package:mhadmin/widget/Buttons.dart';
import 'package:provider/provider.dart';

class BroadcastPost extends StatelessWidget {
  AppPost post;
  String id;
  String bid;
  BroadcastPost({this.post, this.id, this.bid});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer2<UserProvider, BroadcastProvider>(
        builder: (context, UserProvider, BroadcastProvider, child) {
      return InkWell(
        onLongPress: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Confirm"),
                  actionsPadding:
                      EdgeInsets.only(bottom: subMargin, right: subMargin),
                  content: Text(
                      "Are you sure that you want to delete this post?"),
                  actions: [
                    PrimaryButton(
                      isloading: false,
                      title: "Sure",
                      backgroundColor: primary,
                      height: 40,
                      foregroundColor: white,
                      width: 120,
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('broadcastrooms')
                            .doc(bid)
                            .collection('posts')
                            .doc(id)
                            .delete()
                            .then((value) {
                          BroadcastProvider.loadbroadcastroom();
                          Navigator.pop(context);
                        });
                      },
                    ),
                  ],
                );
              });
        },
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: grey.withOpacity(0.01),
              spreadRadius: 10,
              blurRadius: 3,
              // changes position of shadow
            ),
          ]),
          child: Container(
            child: Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              color: white,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(subMargin),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: subMargin, top: subMargin, right: subMargin),
                    child: CachedNetworkImage(
                      imageUrl: post.images[0],
                      width: double.infinity,
                      height: 160,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(
                        width: double.infinity,
                        height: 160,
                        color: grey,
                        child: Center(child: Icon(Icons.image)),
                      ),
                      placeholder: (context, value) {
                        // return Center(
                        //   child: Container(
                        //     width: 46,
                        //     height: 46,
                        //     child: CircularProgressIndicator(
                        //       valueColor: new AlwaysStoppedAnimation<Color>(dark),
                        //       backgroundColor: grey,
                        //     ),
                        //   ),
                        // );
                        return Container(
                          width: double.infinity,
                          height: 160,
                          color: grey,
                          child: Center(
                              child: Icon(
                            Icons.image,
                            size: 45,
                            color: dark.withOpacity(0.5),
                          )),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(subMargin),
                    child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  post.title,
                                  // style: FlutterFlowTheme.bodyText1.override(
                                  //   fontFamily: 'Poppins',
                                  //   fontSize: 15,
                                  //   fontWeight: FontWeight.w600,
                                  // ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    //     Text(
                                    // "      getCurrentTimestamp.toString(),",
                                    //       // style:
                                    //       //     FlutterFlowTheme.bodyText1.override(
                                    //       //   fontFamily: 'Poppins',
                                    //       //   color: FlutterFlowTheme.secondaryColor,
                                    //       // ),
                                    //     )
                                  ],
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                            child: Text(
                              post.description,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                            child: Text(
                              post.postAt.toDate().toString().substring(0, 17),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          // SizedBox(
                          //   height: subMargin,
                          // ),
                          //   Row(
                          //     mainAxisSize: MainAxisSize.max,
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     children: [
                          //       Container(
                          //         width: (size.width -
                          //                 2 * mainMargin -
                          //                 3 * subMargin) /
                          //             3,
                          //         child: Row(
                          //           children: [
                          //             InkWell(
                          //               onTap: () {
                          //                 if (post.like.contains(FirebaseAuth
                          //                     .instance.currentUser.uid)) {
                          //                   BroadcastProvider.removeLikeFromPost(
                          //                       post: post,
                          //                       id: id,
                          //                       bid: bid);
                          //                 } else {
                          //                   BroadcastProvider.likePost(
                          //                       post: post,
                          //                       id:id,
                          //                       bid: bid);
                          //                 }
                          //               },
                          //               child: Icon(
                          //                 post.like.contains(FirebaseAuth
                          //                         .instance.currentUser.uid)
                          //                     ? Icons.favorite
                          //                     : Icons.favorite_outline,
                          //                 color: red,
                          //                 size: 24,
                          //               ),
                          //             ),
                          //             post.like.length == 0
                          //                 ? SizedBox.shrink()
                          //                 : Text(post.like.length.toString() +
                          //                     " likes")
                          //           ],
                          //         ),
                          //       ),
                          //       Container(
                          //         width: (size.width -
                          //                 2 * mainMargin -
                          //                 3 * subMargin) /
                          //             3,
                          //         child: InkWell(
                          //           onTap: () {
                          //             if (UserProvider.user.saved_posts
                          //                 .contains(bid+"-split-"+id)) {
                          //               UserProvider.removePostFromSaved(id: id,bid: bid);
                          //             } else {
                          //               UserProvider.savePost(id: id,bid: bid);
                          //             }
                          //           },
                          //           child: Icon(
                          //             UserProvider.user.saved_posts.contains(bid+"-split-"+id)
                          //                 ? FontAwesome.bookmark
                          //                 : FontAwesome.bookmark_o,
                          //             color: primary,
                          //             size: 24,
                          //           ),
                          //         ),
                          //       ),
                          //       Container(
                          //         width: (size.width -
                          //                 2 * mainMargin -
                          //                 3 * subMargin) /
                          //             3,
                          //         child: Row(
                          //           mainAxisAlignment: MainAxisAlignment.end,
                          //           children: [
                          //             InkWell(
                          //               onTap: () {
                          //                   },
                          //               child: Icon(
                          //                 Icons.share,
                          //                 color: Colors.black,
                          //                 size: 24,
                          //               ),
                          //             ),
                          //           ],
                          //         ),
                          //       )
                          //     ],
                          //   )
                          // ],
                        ]),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

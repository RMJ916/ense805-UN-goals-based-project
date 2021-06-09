import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mhcare/models/appPost.dart';
import 'package:mhcare/providers/BordcastProvider.dart';
import 'package:mhcare/providers/UserProvider.dart';
import 'package:mhcare/theme/Style.dart';
import 'package:mhcare/theme/colors.dart';
import 'package:mhcare/util/uitility.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class BroadcastPost extends StatelessWidget {
  AppPost post;
  String id;
  String bid;
  BroadcastPost({this.post, this.id, this.bid});

  ScreenshotController controller = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer2<UserProvider, BroadcastProvider>(
        builder: (context, UserProvider, BroadcastProvider, child) {
      return Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: grey.withOpacity(0.01),
              spreadRadius: 10,
              blurRadius: 3,
              // changes position of shadow
            ),
          ]),
          child:Screenshot(
        controller: controller,
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
                        imageUrl:
                            'https://www.biospectrumasia.com/uploads/articles/mental_health_awareness_concept_23_2148514643-17096.jpg',
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
                                  
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    
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
                          SizedBox(
                            height: subMargin,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: (size.width -
                                        2 * mainMargin -
                                        3 * subMargin) /
                                    3,
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (post.like.contains(FirebaseAuth
                                            .instance.currentUser.uid)) {
                                          BroadcastProvider.removeLikeFromPost(
                                              post: post,
                                              id: id,
                                              bid: bid);
                                        } else {
                                          BroadcastProvider.likePost(
                                              post: post,
                                              id:id,
                                              bid: bid);
                                        }
                                      },
                                      child: Icon(
                                        post.like.contains(FirebaseAuth
                                                .instance.currentUser.uid)
                                            ? Icons.favorite
                                            : Icons.favorite_outline,
                                        color: red,
                                        size: 24,
                                      ),
                                    ),
                                    post.like.length == 0
                                        ? SizedBox.shrink()
                                        : Text(post.like.length.toString() +
                                            " likes")
                                  ],
                                ),
                              ),
                              Container(
                                width: (size.width -
                                        2 * mainMargin -
                                        3 * subMargin) /
                                    3,
                                child: InkWell(
                                  onTap: () {
                                    if (UserProvider.user.saved_posts
                                        .contains(bid+"-split-"+id)) {
                                      UserProvider.removePostFromSaved(id: id,bid: bid);
                                    } else {
                                      UserProvider.savePost(id: id,bid: bid);
                                    }
                                  },
                                  child: Icon(
                                    UserProvider.user.saved_posts.contains(bid+"-split-"+id)
                                        ? FontAwesome.bookmark
                                        : FontAwesome.bookmark_o,
                                    color: primary,
                                    size: 24,
                                  ),
                                ),
                              ),
                              Container(
                                width: (size.width -
                                        2 * mainMargin -
                                        3 * subMargin) /
                                    3,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        shareImage1(
                                            controller: controller,
                                            msg:
                                                "hey,download MHcare app to get daily awareness content!");
                                      },
                                      child: Icon(
                                        Icons.share,
                                        color: Colors.black,
                                        size: 24,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ));
    });
  }
}

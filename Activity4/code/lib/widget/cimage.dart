import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mhcare/theme/colors.dart';

class Cimage extends StatelessWidget {
  String image_url;
  Cimage({this.image_url});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CachedNetworkImage(
        width: MediaQuery.of(context).size.width,
        imageUrl: image_url,
        
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
    );
  }
}

Widget cimage({String image_url, BuildContext context}) {
  return CachedNetworkImage(
    imageUrl: image_url,
    fit: BoxFit.cover,
    
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
  );
}

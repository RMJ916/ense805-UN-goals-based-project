import 'package:flutter/material.dart';
import 'package:mhcare/theme/Style.dart';
import 'package:mhcare/theme/colors.dart';

class Loading extends StatelessWidget {
  String title;
  Loading({this.title});
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
        child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: 70,
              height: 70,
              child: CircularProgressIndicator(
                backgroundColor: white,
              )),
          Padding(
            padding: EdgeInsets.only(top: mainMargin),
            child: Text(
              title,
              style: ladingtitle,
            ),
          )
        ],
      ),
    ));
  }
}
class NoData extends StatelessWidget {
  String title;
  NoData({this.title});
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
        child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: 300,
              height: 300,
              child: Image.asset('assets/nodata.png',fit: BoxFit.fitHeight,)),
          Padding(
            padding: EdgeInsets.only(top: mainMargin),
            child: Text(
              title,
              style: ladingtitle,
            ),
          )
        ],
      ),
    ));
  }
}

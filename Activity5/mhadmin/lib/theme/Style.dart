import 'package:flutter/material.dart';
import 'package:mhadmin/theme/colors.dart'; 

double mainMargin = 18;
double mainMarginDouble = 30;
double subMargin = 14;

double buttonRadius = 8;
double mainMarginHalf = 9;
double buttonHeight = 50;
TextStyle eventtitle =
    TextStyle(color: dark, fontWeight: FontWeight.w600, fontSize: 18);

TextStyle eventsubtitle = TextStyle(
    color: dark.withOpacity(0.8), fontWeight: FontWeight.w400, fontSize: 14);
TextStyle onbsubttile =
    TextStyle(color: dark.withOpacity(0.55), fontWeight: FontWeight.w400, fontSize: 18);

TextStyle onbmaintitle =
    TextStyle(color: dark, fontWeight: FontWeight.w600, fontSize: 28);

TextStyle appbartitle =
    TextStyle(color: primary, fontWeight: FontWeight.w600, fontSize: 24);

TextStyle brandingtitle =
    TextStyle(color: primary, fontWeight: FontWeight.w500, fontSize: 18);

TextStyle settingtiletitle =
    TextStyle(color: dark, fontWeight: FontWeight.w500, fontSize: 18);
TextStyle ladingtitle = TextStyle(
    color: dark.withOpacity(0.6), fontWeight: FontWeight.w500, fontSize: 18);
TextStyle settingtilesubtitle =
    TextStyle(color: primary, fontWeight: FontWeight.w400, fontSize: 14);

TextStyle boxtitle =
    TextStyle(color: primary, fontWeight: FontWeight.w600, fontSize: 18);

TextStyle dashboardboxtitle =
    TextStyle(color: primary, fontWeight: FontWeight.w500, fontSize: 16);

TextStyle batteryTextStyle =
    TextStyle(color: white, fontWeight: FontWeight.w500, fontSize: 10);

TextStyle batteryTextStyleblack =
    TextStyle(color: primary, fontWeight: FontWeight.w500, fontSize: 10);

TextStyle bltsearchtitle =
    TextStyle(color: primary, fontWeight: FontWeight.w400, fontSize: 9);

TextStyle blthtitle =
    TextStyle(color: primary, fontWeight: FontWeight.w500, fontSize: 16);

TextStyle blthsubtitleligh =
    TextStyle(color: secondary, fontWeight: FontWeight.w400, fontSize: 16);

TextStyle blthsubtitle =
    TextStyle(color: secondary, fontWeight: FontWeight.w400, fontSize: 14);

TextStyle filetiletitle =
    TextStyle(color: primary, fontWeight: FontWeight.w500, fontSize: 14);

TextStyle filetilesubtitle =
    TextStyle(color: secondary, fontWeight: FontWeight.w500, fontSize: 13);

TextStyle diagnosistitle = TextStyle(
    color: primary.withOpacity(0.6), fontWeight: FontWeight.w400, fontSize: 14);

TextStyle questionStyle =
    TextStyle(color: primary, fontWeight: FontWeight.w400, fontSize: 16);

class AppTitle extends StatelessWidget {
  String title;
  AppTitle({this.title});
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: black),
    );
  }
}

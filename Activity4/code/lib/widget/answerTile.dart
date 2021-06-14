import 'package:flutter/material.dart';
import 'package:mhcare/theme/colors.dart';
import 'package:mhcare/models/answer.dart';
import 'package:mhcare/theme/Style.dart';
import 'package:mhcare/theme/colors.dart';

class AnswerTile extends StatelessWidget {
  Answer ans;
  String id, bestid;
  AnswerTile({this.ans,this.id,this.bestid});
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
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => BoradcastRoom()));
        },
        leading: Container(
          decoration: BoxDecoration(
              border: Border.all(width: 2, color: primary),
              borderRadius: BorderRadius.circular(30)),
          child: SizedBox(
            width: 40,
            height: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Hero(
                tag: "image1a1",
                child: ans.type == "admin"
                    ? Image.asset(
                        "assets/logo.png",
                        width: 35,
                        height: 35,
                      )
                    : Container(
                        width: 40,
                        decoration: BoxDecoration(
                            color: primary,
                            borderRadius: BorderRadius.circular(25)),
                        child: Center(
                          child: Text(
                            ans.name.split(' ')[0].substring(0,1).toUpperCase()+ans.name.split(' ')[1].substring(0,1).toUpperCase(),
                            style: TextStyle(
                                color: white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ),
        title: Row(
          children: [
            Text(ans.type == "admin" ? "Mental Health Care" : ans.name),
            SizedBox(
              width: subMargin - 5,
            ),
            ans.type == "admin"
                ? Icon(
                    Icons.verified,
                    color: primary,
                    size: 18,
                  )
                : SizedBox.shrink()
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ans.timestamp.toDate().toLocal().toString().substring(0, 16) +
                  " " +
                  ans.timestamp.toDate().timeZoneName.toString(),
              style: TextStyle(fontSize: 12),
            ),
            SizedBox(
              height: 7,
            ),
            Text(ans.answers),
          ],
        ),
        trailing: bestid==id?Icon(Icons.check_circle,color: primary,):SizedBox.shrink(),
      ),
    );
  }
}

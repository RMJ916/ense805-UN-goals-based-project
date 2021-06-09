import 'package:flutter/material.dart';
import 'package:mhcare/theme/Style.dart';
import 'package:mhcare/theme/colors.dart';

class AnswerTile extends StatelessWidget {
  String name;
  String answer;
  bool answerby_admin;

  AnswerTile({this.answer, this.answerby_admin, this.name});
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
                child: answerby_admin
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
                      "MG",
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
            Text(      answerby_admin?"Mental Health Care":name), 
            SizedBox(width: subMargin-5,),
            answerby_admin
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
            Text("12/05/21 12:00 AM PST",style: TextStyle(fontSize: 12),),
            SizedBox(height: 7,),
             Text(answer),
          ],
        ),
      ),
    );
  }
}

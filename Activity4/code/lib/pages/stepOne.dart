import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mhcare/pages/Signin.dart';
import 'package:mhcare/pages/Signup.dart';
import 'package:mhcare/theme/Style.dart';
import 'package:mhcare/theme/colors.dart';
import 'package:mhcare/widget/Buttons.dart';

class Stepone extends StatefulWidget {
  @override
  _SteponeState createState() => _SteponeState();
}

class _SteponeState extends State<Stepone> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: white,
        body: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: mainMargin),
                  decoration: BoxDecoration(
                    color: white,
                    // image: DecorationImage(
                    //     image: AssetImage("assets/onb2.png"),
                    //     fit: BoxFit.fitWidth),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: subMargin),
                          child: Image(
                            image: AssetImage("assets/logo.png"),
                            width: 100,
                          ),
                        ),
                        SizedBox(
                          height: 6 * subMargin,
                        ),
                        Hero(
                          tag: 'button',
                          child: PrimaryButton(
                            isloading: false,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignIn()));
                            },
                            title: "Login",
 
                            backgroundColor: primary,
                            foregroundColor: white,
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: mainMargin, vertical: 2 * subMargin),
                decoration: BoxDecoration(color: white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   
                    Center(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Signup()));
                        },
                        child: Text(
                          "New here? Create New Account",
                          style: TextStyle(
                              fontSize: mainMargin - 2,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mhadmin/providers/UserProvider.dart';
import 'package:mhadmin/theme/Style.dart';
import 'package:mhadmin/theme/colors.dart';
import 'package:provider/provider.dart';

class ProfileTile extends StatelessWidget {
  String title, value;
  IconData icon;
  bool isverifiyed,send;
  
  ProfileTile({this.title, this.icon, this.send,this.value,this.isverifiyed});
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
 
      builder: (context,UserProvider, child) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: subMargin),
          decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(subMargin),
              boxShadow: [
                BoxShadow(
                  color: primary.withOpacity(0.01),
                  spreadRadius: 10,
                  blurRadius: 3,
                  // changes position of shadow
                ),
              ]),
          child: ListTile(
            leading: Icon(icon),
            contentPadding: EdgeInsets.zero,
            title: Text(value),
            trailing: isverifiyed?Icon(Icons.verified_rounded,color: primary,):send?InkWell(onTap: (){

    if (!FirebaseAuth.instance.currentUser
                                            .emailVerified) {
                                          UserProvider.sendVerificationemail();
                                        }
            },
            
            child: Text("Send",style: TextStyle(color: primary),),
            ):SizedBox.shrink(),
            // subtitle: Text(value),
          ),
        );
      }
    );
  }
}

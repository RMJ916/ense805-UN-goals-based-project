import 'package:flutter/material.dart';
import 'package:mhcare/models/appuser.dart';
import 'package:mhcare/providers/UserProvider.dart';
import 'package:mhcare/theme/Style.dart';
import 'package:mhcare/theme/colors.dart';
import 'package:mhcare/widget/Buttons.dart';
import 'package:mhcare/widget/inputbox.dart';
import 'package:provider/provider.dart';

class CreateQues extends StatefulWidget {
  @override
  _CreateQuesState createState() => _CreateQuesState();
}

class _CreateQuesState extends State<CreateQues> {
  Appuser user;

  TextEditingController ques;

  bool isloading = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    ques = TextEditingController();
  
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<UserProvider>(builder: (context, UserProvider, child) {
      user = UserProvider.user;

      return Scaffold(
          key: scaffoldKey,
          backgroundColor: grey,
          appBar: AppBar(
            title: AppTitle(title: "Add Question"),
            leading: IconButton(
              icon: Icon(
                Icons.close,
                color: dark,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Container(
            padding: EdgeInsets.all(mainMargin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 inputBox(
                controller: ques,
                error: false,
                errorText: "",
                inuptformat: [],
                labelText: "Question",
                obscureText: false,
                ispassword: false,
                istextarea: true,
                readonly: false,
                minLine:4 ,
                onchanged: (value) {
                  
                },
             ),
                PrimaryButton(
                  isloading: false,
                  title: "Post",
                  backgroundColor: primary,
                  foregroundColor: white,
                  borderRadius: buttonRadius,
                  onPressed: () {},
                  height: buttonHeight,
                  width: MediaQuery.of(context).size.width-2*mainMargin,
                )
              ],
            ),
          ));
    });
  }
}

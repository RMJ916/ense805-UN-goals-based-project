import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart'; 
import 'package:image_picker/image_picker.dart';
import 'package:mhadmin/providers/BordcastProvider.dart';
import 'package:mhadmin/theme/Style.dart';
import 'package:mhadmin/theme/colors.dart';
import 'package:mhadmin/widget/Buttons.dart';
import 'package:mhadmin/widget/inputbox.dart';
import 'package:mhadmin/widget/snackbar.dart';
import 'package:provider/provider.dart';
class CreateBroom extends StatefulWidget {
  const CreateBroom({ Key  key }) : super(key: key);

  @override
  _CreateBroomState createState() => _CreateBroomState();
}

class _CreateBroomState extends State<CreateBroom> {
  final firestoreInstance = FirebaseFirestore.instance;
  final picker = ImagePicker();
  String _url = " "; 
  final title = TextEditingController(); 
  bool isloading = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
   
    title.dispose();
    super.dispose();
  }

  File imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: white,
        elevation: 0,
        // title: Text(
        //   "Create an Account",
        //   style: TextStyle(
        //       color: primary, fontWeight: FontWeight.bold, fontSize: 30),
        // ),
        title: AppTitle(title: "Create Broadcast Room"),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: black,
            size: mainMargin + 6,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(mainMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overscroll) {
                if (overscroll.leading) {
                  // loadmore();
                  overscroll.disallowGlow();
                } else {
                  overscroll.disallowGlow();
                }
              },
              child: ListView(
                children: [
                  SizedBox(
                    height: mainMargin,
                  ),
                  inputBox(
                    controller: title,
                    error: false,
                    errorText: "",
                    readonly: isloading,
                    // inuptformat: [
                    //   new WhitelistingTextInputFormatter(RegExp("[a-zA-Z]")),
                    //   BlacklistingTextInputFormatter(new RegExp('[\\ ]')),
                    // ],
                    labelText: "Broom Name",
                    obscureText: false,
                    ispassword: false,
                    istextarea: false,
                    onchanged: (value) {},
                  ),
                
                 
                  SizedBox(
                    height: mainMargin,
                  ),
                  imageFile ==null
                      ? PrimaryButton(
                          onPressed: () {
                            _takeImage();
                          },
                          title: "Select Picture",
                          backgroundColor: dark.withOpacity(0.2),
                          foregroundColor: black,
                          height: 50,
                          isloading: isloading,
                        )
                      : Image.file(
                          imageFile,
                          fit: BoxFit.fitWidth,
                        )
                ],
              ),
            )),
            SizedBox(
              height: mainMarginHalf,
            ),
            PrimaryButton(
              onPressed: () {
                setState(() {
                  isloading = true;
                });

                if ( 
                    title.text == '' || 
                    imageFile == null) {
                  isloading = false;

                  CustomSnackBar(
                          actionTile: "Close",
                          haserror: true,
                          isfloating: true,
                          scaffoldKey: scaffoldKey,
                          title: "Please fillup all details!")
                      .show();
                } else {
                  setState(() {
                    isloading = true;
                    _uploadImageToFirebase(imageFile);
                  });
                }
              },
              title: "Create",
              backgroundColor: primary,
              foregroundColor: white,
              height: 50,
              isloading: isloading,
            ),
          ],
        ),
      ),
    );
  }

  void get_data() {
    firestoreInstance.collection("broadcastrooms").add({
       
        "created_at": Timestamp.now(),
        "profile_picture": _url,
        "name": title.text,
        "last_msg": '',
        "total_msg": 0, 
      
    }).then((value) {
      print(value.id);
                                Provider.of<BroadcastProvider>(context,listen: false)
                              .loadbroadcastroom();
      Navigator.pop(context, "true");
    });
  }

  Future _takeImage() async {
    // Get image from gallery.
    var pickedFile = await picker.getImage(source: ImageSource.gallery);
    imageFile = File(pickedFile.path);
    setState(() {});
  }

  Future<void> _uploadImageToFirebase(File imageFile) async {
    try {
      // Make random image name.
      setState(() {
        isloading = true;
      });
      int randomNumber = Random().nextInt(10000);
      String imageLocation = 'images/image$randomNumber.jpg';

      // Upload image to firebase.
      await firebase_storage.FirebaseStorage.instance
          .ref(imageLocation)
          .putFile(imageFile);
      setState(() {});

      _url = await firebase_storage.FirebaseStorage.instance
          .ref(imageLocation)
          .getDownloadURL();
      print(_url);
      get_data();
    } on FirebaseException catch (e) {
      print(e.code);
      setState(() {
        isloading = false;
      });
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.code),
            );
          });
    } catch (e) {
      print("e");
      setState(() {
        isloading = false;
      });
    }
  }
}

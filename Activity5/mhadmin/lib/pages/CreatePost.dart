import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mhadmin/models/broadcastRoom.dart';
import 'package:mhadmin/providers/BordcastProvider.dart';
import 'package:mhadmin/theme/Style.dart';
import 'package:mhadmin/theme/colors.dart';
import 'package:mhadmin/widget/Buttons.dart';
import 'package:mhadmin/widget/inputbox.dart';
import 'package:mhadmin/widget/loading.dart';
import 'package:mhadmin/widget/snackbar.dart';
import 'package:provider/provider.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({Key key}) : super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final firestoreInstance = FirebaseFirestore.instance;
  final picker = ImagePicker();
  String _url = " ";

  final description = TextEditingController();
  final title = TextEditingController();
  String date1 = " ";
  bool isloading = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    description.dispose();
    title.dispose();
    super.dispose();
  }

  String selected;
  File imageFile;

  @override
  Widget build(BuildContext context) {
    return Consumer<BroadcastProvider>(
        builder: (context, BroadcastProvider, child) {
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
          title: AppTitle(title: "Create Post"),
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
          child: BroadcastProvider.broom == null
              ? Loading(
                  title: "Loading data",
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: NotificationListener<
                            OverscrollIndicatorNotification>(
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
                          IgnorePointer(
                            ignoring: false,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 15),
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.black)),
                              child: DropdownButton(
                                isExpanded: true,
                                value: selected,
                                hint: Text("Select Broadcast room"),
                                onChanged: (value) {
                                  setState(() {
                                    selected = value;
                                  });
                                },
                                items: BroadcastProvider.broom.keys
                                    .toList()
                                    .map((e) => DropdownMenuItem(
                                          child: Text(
                                              BroadcastProvider.broom[e].name),
                                          value: BroadcastProvider.broom[e].id,
                                        ))
                                    .toList(),
                                underline: SizedBox(),
                              ),
                            ),
                          ),
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
                            labelText: "Title",
                            obscureText: false,
                            ispassword: false,
                            istextarea: false,
                            onchanged: (value) {},
                          ),
                          SizedBox(
                            height: mainMargin,
                          ),
                          inputBox(
                            controller: description,
                            error: false,
                            errorText: "",
                            readonly: isloading,
                            // inuptformat: [
                            //   new WhitelistingTextInputFormatter(RegExp("[a-zA-Z]")),
                            //   BlacklistingTextInputFormatter(new RegExp('[\\ ]')),
                            // ],
                            labelText: "Description",
                            obscureText: false,
                            ispassword: false,
                            istextarea: false,
                            onchanged: (value) {},
                          ),
                          SizedBox(
                            height: mainMargin,
                          ),
                          imageFile == null
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

                        if (date1 == '' ||
                            description.text == '' ||
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
                      title: "Post",
                      backgroundColor: primary,
                      foregroundColor: white,
                      height: 50,
                      isloading: isloading,
                    ),
                  ],
                ),
        ),
      );
    });
  }

  void get_data() {
    firestoreInstance
        .collection("broadcastrooms")
        .doc(selected)
        .collection('posts')
        .add({
      'title': title.text,
      "type": 'text',
      "description": description.text,
      "post_at": Timestamp.now(),
      "like": [],
      "images": [_url],
      "video": [],
    }).then((value) {
      print(value.id);
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

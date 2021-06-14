import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mhadmin/theme/Style.dart';
import 'package:mhadmin/theme/colors.dart';
import 'package:mhadmin/widget/Buttons.dart';
import 'package:mhadmin/widget/inputbox.dart';
import 'package:mhadmin/widget/snackbar.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({Key key}) : super(key: key);

  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  final firestoreInstance = FirebaseFirestore.instance;
  final picker = ImagePicker();
  String _url = " ";

  final dec = TextEditingController();
  final location = TextEditingController();
  final person = TextEditingController();
  final title = TextEditingController();
  String date1 = " ";
  bool isloading = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    dec.dispose();
    location.dispose();
    person.dispose();
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
        title: AppTitle(title: "Create Event"),
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
                    controller: dec,
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
                  inputBox(
                    controller: location,
                    error: false,
                    errorText: "",
                    readonly: isloading,
                    inuptformat: [],
                    labelText: "Location",
                    obscureText: false,
                    ispassword: false,
                    istextarea: true,
                    onchanged: (value) {},
                  ),
                  SizedBox(
                    height: mainMargin,
                  ),
                  inputBox(
                    controller: person,
                    error: false,
                    errorText: "",
                    readonly: isloading,
                    inuptformat: [],
                    labelText: "Person",
                    obscureText: false,
                    ispassword: false,
                    istextarea: true,
                    onchanged: (value) {},
                  ),
                  SizedBox(
                    height: mainMargin,
                  ),
                  DateTimePicker(
                    maxLines: 1,
                    type: DateTimePickerType.date,
                    dateMask: 'd MMM, yyyy',
                    readOnly: isloading,
                    autofocus: false,
                    decoration: InputDecoration(
                        errorText: null,
                        contentPadding: EdgeInsets.only(
                            right: subMargin,
                            left: subMargin,
                            bottom: subMargin,
                            top: subMargin),
                        errorStyle: TextStyle(color: errorColor, height: 0),
                        labelStyle:
                            TextStyle(color: dark, fontSize: subMargin + 2),
                        hintText: "Event Date",
                        labelText: "Event Date",
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(buttonRadius),
                          borderSide: BorderSide(width: 2, color: primary),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(buttonRadius),
                          borderSide: BorderSide(width: 1, color: grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(buttonRadius),
                          borderSide: BorderSide(width: 1, color: black),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(buttonRadius),
                            borderSide: BorderSide(
                              width: 1,
                            )),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(buttonRadius),
                            borderSide:
                                BorderSide(width: 1.5, color: errorColor)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(buttonRadius),
                            borderSide:
                                BorderSide(width: 2, color: errorColor)),
                        suffixIcon: Icon(
                          Icons.event_outlined,
                          color: dark.withOpacity(0.4),
                          size: 30,
                        )),
                    firstDate:DateTime.now() ,
                    lastDate:DateTime(2100) ,
                    selectableDayPredicate: (date) {
                      if (date.weekday == 6 || date.weekday == 7) {
                        return true;
                      }
                      return true;
                    },
                    onChanged: (val) {
                      setState(() {
                        date1 = val;
                      });
                    },
                    validator: (val) {
                      setState(() => date1 = val);
                      return null;
                    },
                    onSaved: (val) {
                      setState(() {
                        date1 = val;
                      });
                    },
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

                if (date1 == '' ||
                    dec.text == '' ||
                    title.text == '' ||
                    location.text == '' ||
                    person.text == '' ||
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
    firestoreInstance.collection("events").add({
      "location": location.text,
      "title": title.text,
      "dec": dec.text,
      "person": person.text,
      "event_date": Timestamp.fromDate(DateTime.parse(date1)),
      "image": _url
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

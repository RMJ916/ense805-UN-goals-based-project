import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

Appuser appuserFromJson(String str) => Appuser.fromJson(json.decode(str));

String appuserToJson(Appuser data) => json.encode(data.toJson());

class Appuser {
  Appuser(
      {this.fname,
      this.lname,
      this.email,
      this.city,
      this.state,
      this.country,
      this.birthdate,
      this.saved_posts,
      this.saved_events,
      this.lastseen});

  String fname;
  String lname;
  String email;
  String city;
  String state;
  String country;
  List<String> saved_posts,saved_events;
  Timestamp birthdate;
  Map<String, dynamic> lastseen;

  factory Appuser.fromJson(Map<String, dynamic> json) => Appuser(
      fname: json["fname"],
      lname: json["lname"],
      email: json["email"],
      city: json["city"],
      state: json["state"],
      saved_posts: List<String>.from(json["saved_posts"].map((x) => x)),
      saved_events:List<String>.from(json["saved_events"].map((x) => x)),
      country: json["country"],
      birthdate: json["birthdate"],
      lastseen: json['lastseen']);

  Map<String, dynamic> toJson() => {
        "fname": fname,
        "lname": lname,
        "email": email,
        "city": city,
        "state": state,
        "country": country,
        "birthdate": birthdate,
        'saved_posts':saved_posts,
        'lastseen': lastseen,
        'saved_events':saved_events
      };
}

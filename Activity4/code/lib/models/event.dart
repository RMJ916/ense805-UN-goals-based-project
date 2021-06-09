// To parse this JSON data, do
//
//     final event = eventFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

Event eventFromJson(String str) => Event.fromJson(json.decode(str));

String eventToJson(Event data) => json.encode(data.toJson());

class Event {
    Event({
        this.title,
        this.dec,
        this.image,
        this.location,
        this.eventDate,
        this.person,
    });

    String title;
    String dec;
    String image;
    String location;
    Timestamp eventDate;
    String person;

    factory Event.fromJson(Map<String, dynamic> json) => Event(
        title: json["title"],
        dec: json["dec"],
        image: json["image"],
        location: json["location"],
        eventDate: json["event_date"],
        person: json["person"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "dec": dec,
        "image": image,
        "location": location,
        "event_date": eventDate,
        "person": person,
    };
}

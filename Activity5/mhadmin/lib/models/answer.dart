// To parse this JSON data, do
//
//     final answer = answerFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

Answer answerFromJson(String str) => Answer.fromJson(json.decode(str));

String answerToJson(Answer data) => json.encode(data.toJson());

class Answer {
    Answer({
        this.answers,
        this.by,
        this.name,
        this.type,
        this.timestamp,
    });

    String answers;
    String by;
    String name;
    String type;
    Timestamp timestamp;

    factory Answer.fromJson(Map<String, dynamic> json) => Answer(
        answers: json["answers"],
        by: json["by"],
        name: json["name"],
        type: json["type"],
        timestamp: json["timestamp"],
    );

    Map<String, dynamic> toJson() => {
        "answers": answers,
        "by": by,
        "name": name,
        "type": type,
        "timestamp": timestamp,
    };
}

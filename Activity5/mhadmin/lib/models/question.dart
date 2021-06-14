// To parse this JSON data, do
//
//     final question = questionFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

Question questionFromJson(String str) => Question.fromJson(json.decode(str));

String questionToJson(Question data) => json.encode(data.toJson());

class Question {
  Question(
      {this.answered,
      this.bestanswer,
      this.qus,
      this.qusby,
      this.timestamp,
      this.best_ans_id,
      this.total_answer});

  bool answered;
  String bestanswer;
  String qus;
  String qusby;
  String best_ans_id;
  Timestamp timestamp;
  int total_answer;
  factory Question.fromJson(Map<String, dynamic> json) => Question(
      answered: json["answered"],
      bestanswer: json["bestanswer"],
      qus: json["qus"],
      qusby: json["qusby"],
      timestamp: json["timestamp"],

      best_ans_id:json['best_ans_id'],
      total_answer: json['total_answer']);


  Map<String, dynamic> toJson() => {
        "answered": answered,
        "bestanswer": bestanswer,
        "qus": qus,
        "qusby": qusby,
        "timestamp": timestamp,
        "total_answer": total_answer,
        "best_ans_id":best_ans_id
      };
}

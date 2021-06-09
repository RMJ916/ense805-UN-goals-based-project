// To parse this JSON data, do
//
//     final appPost = appPostFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

AppPost appPostFromJson(String str) => AppPost.fromJson(json.decode(str));

String appPostToJson(AppPost data) => json.encode(data.toJson());

class AppPost {
  AppPost({
    this.type,
    this.description,
    this.postAt,
    this.like,
    this.images,
    this.title,
    this.video,
  });

  String type;
  String description;
  Timestamp postAt;
  List<String> like;
  List<String> images;
  List<String> video;
  String title;

  factory AppPost.fromJson(Map<String, dynamic> json) => AppPost(
        type: json["type"],
        description: json["description"],
        postAt: json["post_at"],
        title: json['title'],
        like: List<String>.from(json["like"].map((x) => x)),
        images: List<String>.from(json["images"].map((x) => x)),
        video: List<String>.from(json["video"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        "type": type,
        "description": description,
        "post_at": postAt,
        "like": List<dynamic>.from(like.map((x) => x)),
        "images": List<dynamic>.from(images.map((x) => x)),
        "video": List<dynamic>.from(video.map((x) => x)),
      };
}

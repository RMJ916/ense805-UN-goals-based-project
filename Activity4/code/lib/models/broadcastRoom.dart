// To parse this JSON data, do
//
//     final broadcastRoom = broadcastRoomFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

BroadcastRoom broadcastRoomFromJson(String str) =>
    BroadcastRoom.fromJson(json.decode(str));

String broadcastRoomToJson(BroadcastRoom data) => json.encode(data.toJson());

class BroadcastRoom {
  BroadcastRoom(
      {this.createdAt,
      this.profilePicture,
      this.name,
      this.last_msg,
      this.totalMsg,
      this.unseen,
      this.id});

  Timestamp createdAt;
  String profilePicture;
  String name;
  String last_msg;
  int totalMsg;
  int unseen;
  String id;

  factory BroadcastRoom.fromJson(Map<String, dynamic> json) => BroadcastRoom(
        createdAt: json["created_at"].toDouble(),
        profilePicture: json["profile_picture"],
        name: json["name"],
        last_msg: json["last_msg"],
        totalMsg: json["total_msg"],
        unseen: json["unseen"],
        id:json['id']
      );

  Map<String, dynamic> toJson() => {
        "created_at": createdAt,
        "profile_picture": profilePicture,
        "name": name,
        "last_msg": last_msg,
        "total_msg": totalMsg,
        "unseen": unseen,
        "id":id
      };

  updateUnseen({int value}) {
    unseen = value;
  }
}

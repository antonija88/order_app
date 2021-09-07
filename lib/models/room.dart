import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';


class Room{
  String title;
  String id;
  bool isActive;

  Room({@required this.title, this.id, this.isActive = true});

  static Room fromJson(Map<String, dynamic> json)  => Room(
      title: json['title'],
      id: json['id'],
      isActive: json['isActive']
      );

  Map<String, dynamic> toJson() => {
    'title': title,
    'id': id,
    'isActive': isActive
  };

  factory Room.fromFirestore(DocumentSnapshot documentSnapshot) {
    Room room = Room.fromJson(documentSnapshot.data());
    room.id = documentSnapshot.id;
    return room;
  }



}


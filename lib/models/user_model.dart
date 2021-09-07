import 'package:cloud_firestore/cloud_firestore.dart';


class UID {

  final String uid;

  UID({ this.uid });
}


class UserModel {
  String username;
  String email;
  String uid;
  String profileImage;


  UserModel({this.username, this.email, this.uid, this.profileImage});

  static UserModel fromJson(Map<String, dynamic> json)  => UserModel(
    username: json['username'],
    email: json['email'],
    uid: json['uid'],
    profileImage: json['profileImage']
  );

  Map<String, dynamic> toJson() => {
    'username': username,
    'email': email,
    'uid': uid,
    'profileImage': profileImage
  };

  factory UserModel.fromFirestore(DocumentSnapshot documentSnapshot) {
    UserModel user = UserModel.fromJson(documentSnapshot.data());
    user.uid = documentSnapshot.id;
    return user;
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Order {
  String id;
  String foodName;
  String userName;
  String userNameID;
  double price;
  Image userProfilePicture;

  Order(
      {this.id ,this.foodName, this.userName, this.userNameID, this.price, this.userProfilePicture});

  Map<String, dynamic> toJson() => {
    'id' : id,
    'foodName': foodName,
    'userName' : userName,
    'userNameID': userNameID,
    'price' : price
  };

  static Order fromJson(Map<String, dynamic> json)  => Order(
    id: json['id'],
    foodName: json['foodName'],
    userName: json['userName'],
    userNameID: json['userNameID'],
    price: json['price']
  );

  factory Order.fromFirestore(DocumentSnapshot documentSnapshot) {
    Order order = Order.fromJson(documentSnapshot.data());
    order.id = documentSnapshot.id;
    return order;
  }

}


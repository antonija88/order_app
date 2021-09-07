import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:order_app/models/order.dart';
import 'package:order_app/models/room.dart';
import 'package:order_app/models/user_model.dart';
import 'package:order_app/providers/rooms_provider.dart';
import 'package:order_app/utility/transform.dart';
import 'package:provider/provider.dart';


final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class FirebaseApi {

  String uid;
  FirebaseApi({this.uid});

  static Future<String> createRoom(Room room) async{
    final docRoom = _firestore.collection('room').doc();
    room.id = docRoom.id;
    await docRoom.set(room.toJson());
    return docRoom.id;
  }

  static Stream<List<Room>> readRooms() {
    CollectionReference _roomsCollection = _firestore.collection('room');
    return _roomsCollection.snapshots().map((item) => item.docs.map((doc) => Room.fromFirestore(doc)).toList());
  }

  static Future updateRoom(Room room) async {
    final docRoom = FirebaseFirestore.instance.collection('room').doc(room.id);
    await docRoom.update(room.toJson());
  }

  static Future deleteRoom(Room room) async {
    Future<QuerySnapshot> ordersInRoom = FirebaseFirestore.instance.collection('room').doc(room.id).collection('orders').get();
    ordersInRoom.then((value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance.collection('room').doc(room.id).collection('orders').doc(element.id).delete();
      });
    });
    final docRoom = FirebaseFirestore.instance.collection('room').doc(room.id);
    await docRoom.delete();
  }
  
  static Future addOrder(Order order, Room room) async{
    final docOrder = _firestore.collection('room').doc(room.id).collection("orders").add(order.toJson());
  }

  static Future deleteOrder(Order order, Room room) async {
    final docOrder = _firestore.collection('room').doc(room.id).collection('orders').doc(order.id);
    await docOrder.delete();
  }

  static Future updateOrder(Order order, Room room) async {
    final docOrder = _firestore.collection('room').doc(room.id).collection('orders').doc(order.id);
    await docOrder.update(order.toJson());
  }

  static Stream<List<Order>> readOrdersInRoom(Room room) {
    CollectionReference _ordersCollection = _firestore.collection('room').doc(room.id).collection('orders');
    return _ordersCollection.snapshots().map((item) => item.docs.map((doc) => Order.fromFirestore(doc)).toList());
  }

  static Future<UserModel> getUser(String id) async {
    final userDoc = _firestore.collection('users').doc(id);
    return userDoc.get().then((value) => UserModel.fromFirestore(value));
  }

  static Future<bool> isUserExistInFirebaseFirestore(String id) async {
    final user = _firestore.collection('users').doc(id);
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }

  static Future createUserData(UserModel user) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc(user.uid);
    await docUser.set(user.toJson());
  }

  static Future updateUserData(UserModel user) async{
    final docUser= FirebaseFirestore.instance.collection('users').doc(user.uid);
    await docUser.update(user.toJson());
  }

  static Stream<List<UserModel>> readUserData() {
    CollectionReference _userCollection = _firestore.collection('users');
    return _userCollection.snapshots().map((item) => item.docs.map((doc) => UserModel.fromFirestore(doc)).toList());
  }

  static Future deleteUser(UserModel user) async {
    final docUser = _firestore.collection('users').doc(user.uid);
    await docUser.delete();
  }

  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }


// static Stream readUser() => FirebaseFirestore.instance
  //     .collection('user')
  //     .doc()
  //     .snapshots().transform(Utils.transformer(UserModel.fromJson));



}
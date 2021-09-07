import 'package:flutter/material.dart';
import 'package:order_app/api/firebase_api.dart';
import 'package:order_app/models/order.dart';
import 'package:order_app/models/room.dart';
import 'package:order_app/providers/rooms_provider.dart';
import 'package:provider/provider.dart';

class OrderProvider extends ChangeNotifier {
  List<Order> _orders = [];

  void addOrder(Order order, Room room) {
    FirebaseApi.addOrder(order, room);
  }

  void readOrders(Room room) {
    FirebaseApi.readOrdersInRoom(room);
  }

  void deleteOrder(Order order, Room room) {
    FirebaseApi.deleteOrder(order, room);
    int indexToDelete = _orders.indexWhere((element) => element.id == order.id);
    _orders.removeAt(indexToDelete);
    notifyListeners();
  }

  void updateOrder(Order order, Room room) {
    FirebaseApi.updateOrder(order, room);
  }


  void setOrders(List<Order> orders) { WidgetsBinding.instance.addPostFrameCallback((_) {
    _orders = orders;
    notifyListeners();
    });
  }

  // void undoDeletion(int index, Order item) {
  //   _orders.insert(index, item);
  //   notifyListeners();
  // }

  // void removeOrder(Order item) {
  //   _orders.remove(item);
  //   notifyListeners();
  // }

  double totalPrice() {
    double totalPrice = 0;
    _orders.forEach((element) => totalPrice += element.price);
    return totalPrice;
  }

  List<Order> get orders => _orders;

  set orders(List<Order> value) {
    _orders = value;
  }
}

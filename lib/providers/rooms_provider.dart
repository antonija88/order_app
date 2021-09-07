import 'package:flutter/cupertino.dart';
import 'package:order_app/api/firebase_api.dart';
import 'package:order_app/models/room.dart';

class RoomsProvider extends ChangeNotifier {
  Room _room;
  List<Room> _rooms = [];

  List<Room> get rooms => _rooms;

  void setRooms(List<Room> rooms) { WidgetsBinding.instance.addPostFrameCallback((_) {
    _rooms = rooms;
    notifyListeners();
  });
  }

  void setRoom(Room room){
    _room = room;
    notifyListeners();
  }


  Room get room => _room;

  set room(Room value) {
    _room = value;
  }

  void addRooms(Room room) => FirebaseApi.createRoom(room);
  void removeRoom(Room room) => FirebaseApi.deleteRoom(room);
  void updateRoom(Room room, String title) {
    room.title = title;
    FirebaseApi.updateRoom(room);
    notifyListeners();
  }
}

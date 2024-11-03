import 'dart:collection';

import 'package:flutter/cupertino.dart';

import '../models/room.dart';

class RoomsProvider extends ChangeNotifier{
  final List<Room> _rooms = [];

  int _serialRoomId = 0;

  UnmodifiableListView<Room> get rooms => UnmodifiableListView(_rooms);

  List<Room> getFilteredList(String query) {
    return _rooms
        .where((Room room) =>
        room.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void add(String name) {
    Room room = Room(_serialRoomId, name);
    _rooms.add(room);
    _serialRoomId++;
    notifyListeners();
  }

  void remove(int roomId) {
    _rooms.removeWhere((room) => room.id == roomId);
    notifyListeners();
  }

  void removeAll(List<Room> rooms) {
    for (Room room in rooms) {
      _rooms.remove(room);
    }

    notifyListeners();
  }

  void rename(int roomId, String name) {
    Room room = _rooms.firstWhere(
          (room) => room.id == roomId,
    );

    room.rename(name);
    notifyListeners();
  }


}
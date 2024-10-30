import 'package:dispositivos_moveis_2024_2/models/room.dart';
import 'package:timeago/timeago.dart' as timeago;

class Project {
  final int _id;
  final DateTime _createdAt = DateTime.now();
  DateTime _updatedAt = DateTime.now();
  String _name;
  bool pinned = false;
  final List<Room> _rooms = [];

  Project(this._id, this._name);

  int get id => _id;

  DateTime get createdAt => _createdAt;

  DateTime get updatedAt => _updatedAt;

  String get name => _name;

  List<Room> get rooms => List.unmodifiable(_rooms);

  String get updatedAtTimeAgo => timeago.format(_updatedAt);

  void rename(String newName) {
    _name = newName;
    _updatedAt = DateTime.now();
  }

  void addRoom(Room room) {
    if (!_rooms.contains(room)) {
      _rooms.add(room);
      _updatedAt = DateTime.now();
    }
  }

  void removeRoom(Room room) {
    if (_rooms.remove(room)) {
      _updatedAt = DateTime.now();
    }
  }
}

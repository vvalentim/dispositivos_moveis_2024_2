import 'package:dispositivos_moveis_2024_2/models/test_entry.dart';
import 'package:timeago/timeago.dart' as timeago;

class Room {
  final DateTime _createdAt = DateTime.now();
  DateTime _updatedAt = DateTime.now();
  String _name;
  final int _id;
  final List<TestEntry> _tests = [];
  int get id => _id;
  String get updatedAtTimeAgo => timeago.format(_updatedAt);


  Room(this._id,this._name);

  DateTime get createdAt => _createdAt;

  DateTime get updatedAt => _updatedAt;

  String get name => _name;

  List<TestEntry> get entries => List.unmodifiable(_tests);

  void rename(String newName) {
    _name = newName;
    _updatedAt = DateTime.now();
  }

  void addTestEntry(TestEntry test) {
    if (!_tests.contains(test)) {
      _tests.add(test);
      _updatedAt = DateTime.now();
    }
  }

  void removeTestEntry(TestEntry test) {
    if (_tests.remove(test)) {
      _updatedAt = DateTime.now();
    }
  }
}

import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:dispositivos_moveis_2024_2/locator.dart';
import 'package:dispositivos_moveis_2024_2/models/project.dart';
import 'package:dispositivos_moveis_2024_2/models/room.dart';
import 'package:dispositivos_moveis_2024_2/models/test_entry.dart';
import 'package:dispositivos_moveis_2024_2/repositories/active_project/active_project_repository.dart';

// TODO: handle repository exceptions
class ActiveProjectController extends ChangeNotifier {
  final ActiveProjectRepository _repository = locator<ActiveProjectRepository>();

  final Project project;

  bool _loading = false;

  List<Room> _projectRooms = [];

  List<TestEntry> _projectTestEntries = [];

  UnmodifiableListView<Room> get rooms => UnmodifiableListView(_projectRooms);

  UnmodifiableListView<TestEntry> get testEntries => UnmodifiableListView(_projectTestEntries);

  bool get loading => _loading;

  ActiveProjectController(this.project) {
    _load();
  }

  void _load() async {
    debugPrint('Loading ActiveProjectController');

    _loading = true;
    notifyListeners();

    // Fake delay
    await Future.delayed(const Duration(seconds: 1));

    _projectRooms = await _repository.fetchRooms(project.id);
    _projectTestEntries = await _repository.fetchTestEntries(project.id);

    _loading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _projectRooms.clear();
    _projectTestEntries.clear();
    debugPrint('Disposing of ActiveProjectController(${project.name})');
    super.dispose();
  }

  void createRoom(String name) async {
    Room room = await _repository.createRoom(project.id, name);
    _projectRooms.add(room);
    notifyListeners();
  }

  void createTestEntry(int roomId, TestEntryData data) async {
    TestEntry entry = await _repository.createTestEntry(project.id, roomId, data);
    _projectTestEntries.add(entry);
    notifyListeners();
  }

  void removeRoom(Room room) async {
    await _repository.deleteRoom(room);
    _projectRooms.remove(room);
    notifyListeners();
  }

  void removeTestEntry(TestEntry entry) async {
    await _repository.deleteTestEntry(entry);
    _projectTestEntries.remove(entry);
    notifyListeners();
  }
}

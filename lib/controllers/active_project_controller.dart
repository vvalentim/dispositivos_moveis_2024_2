import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
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

  bool _roomSelectionMode = false;

  bool _testEntrySelectionMode = false;

  List<Room> _projectRooms = [];

  List<TestEntry> _projectTestEntries = [];

  final List<Room> _selectedRooms = [];

  final List<TestEntry> _selectedTestEntries = [];

  UnmodifiableListView<Room> get rooms => UnmodifiableListView(_projectRooms);

  UnmodifiableListView<Room> get selectedRooms => UnmodifiableListView(_selectedRooms);

  UnmodifiableListView<TestEntry> get testEntries => UnmodifiableListView(_projectTestEntries);

  UnmodifiableListView<TestEntry> get selectedTestEntries {
    return UnmodifiableListView(_selectedTestEntries);
  }

  bool get loading => _loading;

  bool get roomSelectionMode => _roomSelectionMode;

  bool get testEntrySelectionMode => _testEntrySelectionMode;

  ActiveProjectController(this.project) {
    _load();
  }

  void _load() async {
    debugPrint('Loading ActiveProjectController(${project.name})');

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
    _projectTestEntries.removeWhere((entry) => entry.roomId == room.id);
    _projectRooms.remove(room);
    notifyListeners();
  }

  void removeTestEntry(TestEntry entry) async {
    await _repository.deleteTestEntry(entry);
    _projectTestEntries.remove(entry);
    notifyListeners();
  }

  void renameRoom(int id, String name) async {
    Room? previousReference = _projectRooms.firstWhereOrNull((room) => room.id == id);

    if (previousReference != null) {
      Room newReference = previousReference.copyWith(name: name, updatedAt: DateTime.now());

      await _repository.updateRoom(newReference);
      _projectRooms.remove(previousReference);
      _projectRooms.add(newReference);
      notifyListeners();
    }
  }

  void updateTestEntry(int id, {int? roomId, TestEntryData? data}) async {
    TestEntry? previousReference = _projectTestEntries.firstWhereOrNull((entry) => entry.id == id);

    if (previousReference != null) {
      TestEntry newReference = previousReference.copyWith(
        roomId: roomId ?? previousReference.roomId,
        data: data ?? previousReference.data,
        updatedAt: DateTime.now(),
      );

      await _repository.updateTestEntry(newReference);
      _projectTestEntries.remove(previousReference);
      _projectTestEntries.add(newReference);
      notifyListeners();
    }
  }

  void clearRoomSelection() {
    _roomSelectionMode = false;
    _selectedRooms.clear();
    notifyListeners();
  }

  void removeAllSelectedRooms() async {
    _loading = true;
    notifyListeners();

    // TODO: "proper" batch delete
    for (final room in _selectedRooms) {
      removeRoom(room);
    }

    _loading = false;
    clearRoomSelection();
    notifyListeners();
  }

  void clearTestEntrySelection() {
    _testEntrySelectionMode = false;
    _selectedTestEntries.clear();
    notifyListeners();
  }

  void removeAllSelectedTestEntries() async {
    _loading = true;
    notifyListeners();

    // TODO: "proper" batch delete
    for (final entry in _selectedTestEntries) {
      await _repository.deleteTestEntry(entry);
      _projectTestEntries.remove(entry);
    }

    _loading = false;
    clearTestEntrySelection();
    notifyListeners();
  }

  void toggleRoomSelection(Room room) {
    if (!_roomSelectionMode) {
      _roomSelectionMode = true;
    }

    if (_selectedRooms.contains(room)) {
      _selectedRooms.remove(room);
    } else {
      _selectedRooms.add(room);
    }

    notifyListeners();
  }

  void toggleTestEntrySelection(TestEntry entry) {
    if (!_testEntrySelectionMode) {
      _testEntrySelectionMode = true;
    }

    if (_selectedTestEntries.contains(entry)) {
      _selectedTestEntries.remove(entry);
    } else {
      _selectedTestEntries.add(entry);
    }

    notifyListeners();
  }

  String? getRoomName(int roomId) {
    return _projectRooms.firstWhereOrNull((room) => room.id == roomId)?.name;
  }
}

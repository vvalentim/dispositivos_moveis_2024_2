import 'package:dispositivos_moveis_2024_2/db/memory_db.dart';
import 'package:dispositivos_moveis_2024_2/models/project.dart';
import 'package:dispositivos_moveis_2024_2/models/room.dart';
import 'package:dispositivos_moveis_2024_2/models/test_entry.dart';
import 'package:dispositivos_moveis_2024_2/repositories/active_project/active_project_repository.dart';

class MemoryActiveProjectRepository implements ActiveProjectRepository {
  final MemoryDB _db = MemoryDB.instance;

  // Workaround to update project timestamp
  // Project model is immutable so we need to replace it's entry on 'MemoryDB'
  // This is only necessary for this kind of in memory repository
  void _updateProject(int projectId) {
    Project? project = _db.projects[projectId];

    if (project != null) {
      _db.projects[projectId] = project.copyWith(updatedAt: DateTime.now());
    }
  }

  @override
  Future<Room> createRoom(int projectId, String name) {
    Room room = Room(
      id: _db.currentRoomId,
      projectId: projectId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      name: name,
    );

    _db.rooms[room.id] = room;
    _updateProject(projectId);

    return Future.value(room);
  }

  @override
  Future<TestEntry> createTestEntry(int projectId, int roomId, TestEntryData data) {
    TestEntry entry = TestEntry(
      id: _db.currentTestEntryId,
      projectId: projectId,
      roomId: roomId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      data: data,
    );

    _db.testEntries[entry.id] = entry;
    _updateProject(projectId);

    return Future.value(entry);
  }

  @override
  Future<void> deleteRoom(Room room) {
    _db.testEntries.removeWhere((_, entry) => entry.roomId == room.id);
    _db.rooms.remove(room.id);
    _updateProject(room.projectId);

    return Future.value(null);
  }

  @override
  Future<void> deleteTestEntry(TestEntry entry) {
    _db.testEntries.remove(entry.id);
    _updateProject(entry.projectId);

    return Future.value(null);
  }

  @override
  Future<List<Room>> fetchRooms(int projectId) async {
    final rooms = _db.rooms.values.where((room) => room.projectId == projectId);

    return Future.value(rooms.toList());
  }

  @override
  Future<List<TestEntry>> fetchTestEntries(int projectId) async {
    final testEntries = _db.testEntries.values.where((entry) => entry.projectId == projectId);

    return Future.value(testEntries.toList());
  }

  @override
  Future<Room> updateRoom(Room room) {
    _db.rooms[room.id] = room;
    _updateProject(room.projectId);

    return Future.value(room);
  }

  @override
  Future<TestEntry> updateTestEntry(TestEntry entry) {
    _db.testEntries[entry.id];
    _updateProject(entry.projectId);

    return Future.value(entry);
  }
}

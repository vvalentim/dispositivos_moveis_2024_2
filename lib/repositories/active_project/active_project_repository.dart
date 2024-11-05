import 'package:dispositivos_moveis_2024_2/models/room.dart';
import 'package:dispositivos_moveis_2024_2/models/test_entry.dart';

abstract class ActiveProjectRepository {
  Future<List<Room>> fetchRooms(int projectId);

  Future<List<TestEntry>> fetchTestEntries(int projectId);

  Future<Room> createRoom(int projectId, String name);

  Future<TestEntry> createTestEntry(int projectId, int roomId, TestEntryData data);

  Future<Room> updateRoom(Room room);

  Future<TestEntry> updateTestEntry(TestEntry entry);

  Future<void> deleteRoom(Room room);

  Future<void> deleteTestEntry(TestEntry entry);
}

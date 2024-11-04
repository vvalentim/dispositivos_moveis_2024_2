import 'package:dispositivos_moveis_2024_2/models/project.dart';
import 'package:dispositivos_moveis_2024_2/models/room.dart';
import 'package:dispositivos_moveis_2024_2/models/test_entry.dart';

class MemoryDB {
  MemoryDB._internal();

  static final MemoryDB instance = MemoryDB._internal();

  final Map<int, Project> projects = {};
  final Map<int, Room> rooms = {};
  final Map<int, TestEntry> testEntries = {};

  int _serialProjectId = 0;
  int _serialRoomId = 0;
  int _serialTestEntryId = 0;

  int get currentProjectId => _serialProjectId++;
  int get currentRoomId => _serialRoomId++;
  int get currentTestEntryId => _serialTestEntryId++;
}

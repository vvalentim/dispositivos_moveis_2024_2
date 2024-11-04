import 'package:dispositivos_moveis_2024_2/db/memory_db.dart';
import 'package:dispositivos_moveis_2024_2/models/project.dart';
import 'package:dispositivos_moveis_2024_2/repositories/projects_list/projects_list_repository.dart';

class MemoryProjectsListRepository implements ProjectsListRepository {
  final MemoryDB _db = MemoryDB.instance;

  @override
  Future<Project> create(String name) {
    var project = Project(
      id: _db.currentProjectId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      name: name,
    );

    _db.projects[project.id] = project;

    return Future.value(project);
  }

  @override
  Future<void> delete(int projectId) {
    _db.testEntries.removeWhere((id, entry) => entry.projectId == projectId);
    _db.rooms.removeWhere((id, room) => room.projectId == projectId);
    _db.projects.remove(projectId);

    return Future.value(null);
  }

  @override
  Future<List<Project>> fetchAll() async {
    // Fake delay
    await Future.delayed(const Duration(seconds: 1));

    return Future.value(_db.projects.values.toList());
  }

  @override
  Future<Project> update(Project project) {
    _db.projects[project.id] = project;

    return Future.value(project);
  }
}

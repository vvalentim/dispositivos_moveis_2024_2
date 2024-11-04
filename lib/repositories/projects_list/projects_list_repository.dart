import 'package:dispositivos_moveis_2024_2/models/project.dart';

abstract class ProjectsListRepository {
  Future<Project> create(String name);

  Future<List<Project>> fetchAll();

  Future<Project> update(Project project);

  Future<void> delete(int projectId);
}

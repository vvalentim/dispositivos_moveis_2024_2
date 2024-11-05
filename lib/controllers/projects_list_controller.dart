import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:dispositivos_moveis_2024_2/locator.dart';
import 'package:dispositivos_moveis_2024_2/models/project.dart';
import 'package:dispositivos_moveis_2024_2/repositories/projects_list/projects_list_repository.dart';

// TODO: handle repository exceptions
class ProjectsListController extends ChangeNotifier {
  final ProjectsListRepository _repository = locator<ProjectsListRepository>();

  final List<Project> _selected = [];

  List<Project> _projects = [];

  bool _loading = false;

  bool _selectionMode = false;

  bool _hasActiveProject = false;

  ProjectsListController() {
    _load();
  }

  UnmodifiableListView<Project> get projects => UnmodifiableListView(_projects);

  UnmodifiableListView<Project> get selected => UnmodifiableListView(_selected);

  bool get loading => _loading;

  bool get selectionMode => _selectionMode;

  void _sortProjectsByTimestamp() {
    _projects.sort(
      (a, b) => b.updatedAt.compareTo(a.updatedAt),
    );
  }

  void _load() async {
    _loading = true;
    notifyListeners();

    // Fake delay
    await Future.delayed(const Duration(seconds: 1));

    _projects = await _repository.fetchAll();
    _sortProjectsByTimestamp();

    _loading = false;
    notifyListeners();
  }

  void createProject(String name) async {
    Project project = await _repository.create(name);
    _projects.add(project);
    _sortProjectsByTimestamp();
    notifyListeners();
  }

  void removeProject(int id) async {
    await _repository.delete(id);
    _projects.removeWhere((project) => project.id == id);
    _sortProjectsByTimestamp();
    notifyListeners();
  }

  void renameProject(int id, String name) async {
    Project? previousReference = _projects.firstWhereOrNull((project) => project.id == id);

    if (previousReference != null) {
      Project newReference = previousReference.copyWith(name: name, updatedAt: DateTime.now());

      await _repository.update(newReference);
      _projects.remove(previousReference);
      _projects.add(newReference);
      _sortProjectsByTimestamp();
      notifyListeners();
    }
  }

  void clearSelection() {
    _selectionMode = false;
    _selected.clear();
    notifyListeners();
  }

  void toggleItemSelection(Project project) {
    if (!_selectionMode) {
      _selectionMode = true;
    }

    if (_selected.contains(project)) {
      _selected.remove(project);
    } else {
      _selected.add(project);
    }

    notifyListeners();
  }

  void removeAllSelectedProjects() async {
    _loading = true;
    notifyListeners();

    // TODO: "proper" batch delete
    for (final project in _selected) {
      await _repository.delete(project.id);
      _projects.remove(project);
    }

    _sortProjectsByTimestamp();
    _loading = false;
    clearSelection();
    notifyListeners();
  }

  void toggleActiveProject() {
    // When returning from ActiveProjectPage, refresh the list of projects to detect project updates
    // Just a little detail to refresh the 'updatedAt' timestamp
    if (_hasActiveProject) {
      _load();
    }

    _hasActiveProject = !_hasActiveProject;
    notifyListeners();
  }
}

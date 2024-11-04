import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:dispositivos_moveis_2024_2/locator.dart';
import 'package:dispositivos_moveis_2024_2/models/project.dart';
import 'package:dispositivos_moveis_2024_2/repositories/projects_list/projects_list_repository.dart';

class ProjectsListController extends ChangeNotifier {
  final ProjectsListRepository _repository = locator<ProjectsListRepository>();

  final List<Project> _selected = [];

  List<Project> _projects = [];

  bool _loading = false;

  bool _selectionMode = false;

  ProjectsListController() {
    _load();
  }

  UnmodifiableListView<Project> get projects => UnmodifiableListView(_projects);

  UnmodifiableListView<Project> get selected => UnmodifiableListView(_selected);

  bool get loading => _loading;

  bool get selectionMode => _selectionMode;

  void _load() async {
    _loading = true;
    notifyListeners();

    // TODO: handle fetchAll exceptions
    _projects = await _repository.fetchAll();

    _loading = false;
    notifyListeners();
  }

  void createProject(String name) async {
    // TODO: handle create exceptions
    Project project = await _repository.create(name);
    _projects.add(project);
    notifyListeners();
  }

  void removeProject(int id) async {
    await _repository.delete(id);
    _projects.removeWhere((project) => project.id == id);
    notifyListeners();
  }

  void renameProject(int id, String name) async {
    Project? previousReference = _projects.firstWhereOrNull((project) => project.id == id);

    if (previousReference != null) {
      Project newReference = previousReference.copyWith(name: name, updatedAt: DateTime.now());

      await _repository.update(newReference);
      _projects.remove(previousReference);
      _projects.add(newReference);
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

    _loading = false;
    clearSelection();
    notifyListeners();
  }
}

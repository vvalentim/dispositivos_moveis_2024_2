import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:dispositivos_moveis_2024_2/models/project.dart';

class ProjectsProvider extends ChangeNotifier {
  final List<Project> _projects = [];

  int _serialProjectId = 0;

  UnmodifiableListView<Project> get projects => UnmodifiableListView(_projects);

  List<Project> getFilteredList(String query) {
    return _projects
        .where((Project project) =>
            project.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void add(String name) {
    Project project = Project(_serialProjectId, name);
    _projects.add(project);
    _serialProjectId++;
    notifyListeners();
  }

  void remove(int projectId) {
    _projects.removeWhere((project) => project.id == projectId);
    notifyListeners();
  }

  void removeAll(List<Project> projects) {
    for (Project project in projects) {
      _projects.remove(project);
    }

    notifyListeners();
  }

  void rename(int projectId, String name) {
    Project project = _projects.firstWhere(
      (project) => project.id == projectId,
    );

    project.rename(name);
    notifyListeners();
  }
}

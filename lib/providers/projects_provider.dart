import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:dispositivos_moveis_2024_2/models/project.dart';

class ProjectsProvider extends ChangeNotifier {
  final List<Project> _projects = [
    Project('Casa Neves'),
    Project('Apartamento Oficinas'),
    Project('Empresa ABC'),
  ];

  UnmodifiableListView<Project> get projects => UnmodifiableListView(_projects);

  List<Project> getFilteredList(String query) {
    return _projects
        .where((Project project) =>
            project.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void add(Project project) {
    _projects.add(project);
    notifyListeners();
  }

  void remove(Project project) {
    _projects.remove(project);
    notifyListeners();
  }

  void rename(Project project, String name) {
    project.rename(name);
    notifyListeners();
  }
}

import 'package:dispositivos_moveis_2024_2/models/project.dart';
import 'package:dispositivos_moveis_2024_2/providers/projects_provider.dart';
import 'package:dispositivos_moveis_2024_2/widgets/projects_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  TextEditingController controllerProjectName = TextEditingController();
  String searchQuery = '';

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(209, 209, 209, 1),
        centerTitle: true,
        title: const Text(
          'Projects',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: ProjectsListWidget(
        searchQuery: '',
        dialogCallback: _createOrRenameProjectDialog,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createOrRenameProjectDialog(),
        shape: const CircleBorder(),
        backgroundColor: const Color.fromRGBO(209, 209, 209, 1),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _createProject(String projectName) {
    context.read<ProjectsProvider>().add(Project(projectName));
  }

  void _renameProject(Project? project, String name) {
    if (project != null && project.name != name) {
      context.read<ProjectsProvider>().rename(project, name);
    }
  }

  Future<void> _createOrRenameProjectDialog({
    bool actionRename = false,
    Project? project,
  }) async {
    final alertTitle = actionRename ? 'Rename Project' : 'Create Project';

    if (actionRename && project != null) {
      controllerProjectName.text = project.name;
    }

    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(alertTitle),
          content: TextField(
            controller: controllerProjectName,
            decoration: const InputDecoration(
              labelText: 'Project name',
              border: OutlineInputBorder(),
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.elliptical(10, 10)),
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            OutlinedButton(
              child: const Text('Cancel'),
              onPressed: () {
                controllerProjectName.clear();
                Navigator.of(context).pop();
              },
            ),
            FilledButton(
              style: const ButtonStyle(),
              onPressed: () {
                if (actionRename) {
                  _renameProject(
                    project,
                    controllerProjectName.text,
                  );
                } else {
                  _createProject(controllerProjectName.text);
                }

                controllerProjectName.clear();
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

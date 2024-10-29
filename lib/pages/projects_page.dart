import 'package:dispositivos_moveis_2024_2/models/project.dart';
import 'package:dispositivos_moveis_2024_2/pages/active_project_page.dart';
import 'package:dispositivos_moveis_2024_2/providers/projects_provider.dart';
import 'package:dispositivos_moveis_2024_2/widgets/bottom_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  late ProjectsProvider projectsProvider;

  late List<Project> filteredProjects;

  final form = GlobalKey<FormState>();

  final projectNameController = TextEditingController();

  String _searchQuery = '';

  void _createProject() {
    projectsProvider.add(Project(projectNameController.text));
  }

  void _renameProject(Project project) {
    projectsProvider.rename(project, projectNameController.text);
  }

  @override
  void dispose() {
    super.dispose();
    projectNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    projectsProvider = context.watch<ProjectsProvider>();
    filteredProjects = projectsProvider.getFilteredList(_searchQuery);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Projects'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateOrRenameProject(),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: ListView.builder(
        itemCount: filteredProjects.length,
        itemBuilder: (
          BuildContext context,
          int projectIndex,
        ) {
          return InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    ActiveProjectPage(project: filteredProjects[projectIndex]),
              ),
            ),
            child: Ink(
              color: projectIndex % 2 != 0
                  ? primaryColor.withOpacity(0.2)
                  : primaryColor.withOpacity(0.1),
              child: _getProjectListTile(
                filteredProjects[projectIndex],
              ),
            ),
          );
        },
      ),
    );
  }

  ListTile _getProjectListTile(Project project) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 12,
      ),
      title: Text(project.name),
      subtitle: Text("Modified ${project.updatedAtTimeAgo}"),
      trailing: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Wrap(
            children: [
              IconButton(
                onPressed: () => _showCreateOrRenameProject(project),
                padding: const EdgeInsets.all(16),
                icon: const Icon(Icons.mode_edit),
              ),
              IconButton(
                onPressed: () => _showDeleteProject(project),
                padding: const EdgeInsets.all(16),
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Form _buildFormName() {
    return Form(
      key: form,
      child: TextFormField(
        controller: projectNameController,
        decoration: const InputDecoration(
          labelText: 'Project name',
          border: OutlineInputBorder(),
        ),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ]")),
        ],
        validator: (value) {
          if (value!.length < 3 || value.length > 20) {
            return "The project should be between 3 to 20 characters.";
          }

          return null;
        },
      ),
    );
  }

  Future<void> _showCreateOrRenameProject([Project? project]) async {
    final title = project != null ? 'Rename Project' : 'Create Project';

    if (project != null) {
      projectNameController.text = project.name;
    }

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      builder: (BuildContext context) {
        return BottomSheetWidget(
          title: title,
          content: _buildFormName(),
          submitCallback: () {
            if (form.currentState!.validate()) {
              if (project != null) {
                _renameProject(project);
              } else {
                _createProject();
              }

              projectNameController.clear();
              Navigator.of(context).pop();
            }
          },
        );
      },
    );
  }

  Future<void> _showDeleteProject(
    Project project,
  ) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Delete Project',
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.warning_rounded,
                size: 48,
              ),
              Text(
                "Are you sure you want to delete '${project.name}'?",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.fade,
              ),
              const SizedBox(height: 15),
              const Text(
                "All data associated with it will also be deleted.",
                textAlign: TextAlign.center,
              ),
            ],
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.elliptical(10, 10)),
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            OutlinedButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            FilledButton(
              style: const ButtonStyle(),
              onPressed: () {
                context.read<ProjectsProvider>().remove(project);
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

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
  late ProjectsProvider _projectsProvider;

  late List<Project> _filteredProjects;

  final _form = GlobalKey<FormState>();

  final _projectNameController = TextEditingController();

  String _searchQuery = '';

  void _createProject() {
    _projectsProvider.add(Project(_projectNameController.text));
  }

  void _renameProject(Project project) {
    _projectsProvider.rename(project, _projectNameController.text);
  }

  @override
  void dispose() {
    super.dispose();
    _projectNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    _projectsProvider = context.watch<ProjectsProvider>();
    _filteredProjects = _projectsProvider.getFilteredList(_searchQuery);

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
        itemCount: _filteredProjects.length,
        itemBuilder: (
          BuildContext context,
          int projectIndex,
        ) {
          return InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    ActiveProjectPage(project: _filteredProjects[projectIndex]),
              ),
            ),
            child: Ink(
              color: projectIndex % 2 != 0
                  ? primaryColor.withOpacity(0.2)
                  : primaryColor.withOpacity(0.1),
              child: _getProjectListTile(
                _filteredProjects[projectIndex],
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
      key: _form,
      child: TextFormField(
        controller: _projectNameController,
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
      _projectNameController.text = project.name;
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
            if (_form.currentState!.validate()) {
              if (project != null) {
                _renameProject(project);
              } else {
                _createProject();
              }

              _projectNameController.clear();
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

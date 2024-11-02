import 'package:dispositivos_moveis_2024_2/models/project.dart';
import 'package:dispositivos_moveis_2024_2/pages/active_project_page.dart';
import 'package:dispositivos_moveis_2024_2/providers/projects_provider.dart';
import 'package:dispositivos_moveis_2024_2/widgets/bottom_sheet_widget.dart';
import 'package:dispositivos_moveis_2024_2/widgets/confirm_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  bool _onSelectionMode = false;

  late ProjectsProvider _provider;

  late List<Project> _projects;

  final List<Project> _selected = [];

  final _form = GlobalKey<FormState>();

  final _name = TextEditingController();

  // String _searchQuery = '';

  void _clearSelectionMode() {
    setState(() {
      _onSelectionMode = false;
      _selected.clear();
    });
  }

  void _createProject() {
    context.read<ProjectsProvider>().add(_name.text);
  }

  void _renameProject(int projectId) {
    context.read<ProjectsProvider>().rename(projectId, _name.text);
  }

  void _removeAllSelected() {
    context.read<ProjectsProvider>().removeAll(_selected);

    _clearSelectionMode();
  }

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _provider = context.watch<ProjectsProvider>();
    // _projects = _provider.getFilteredList(_searchQuery);
    _projects = _provider.projects;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: _buildAppBarLeading(),
        actions: _buildAppBarActions(),
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
        itemCount: _projects.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildProjectListTile(_projects[index], index);
        },
      ),
    );
  }

  Widget? _buildAppBarLeading() {
    return _onSelectionMode
        ? IconButton(
            onPressed: () => _clearSelectionMode(),
            icon: const Icon(Icons.undo),
          )
        : null;
  }

  List<Widget> _buildAppBarActions() {
    final List<Widget> actions = [];

    if (_onSelectionMode) {
      actions.add(
        IconButton(
          onPressed: () => _showDeleteSelectedProjects(),
          icon: const Icon(Icons.delete),
        ),
      );
    }

    return actions;
  }

  Widget _buildProjectListTile(Project project, int index) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return InkWell(
      onLongPress: () {
        setState(() {
          if (!_onSelectionMode) {
            _onSelectionMode = true;

            if (_selected.contains(project)) {
              _selected.remove(project);
            } else {
              _selected.add(project);
            }
          } else {
            _clearSelectionMode();
          }
        });
      },
      onTap: () {
        if (!_onSelectionMode) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ActiveProjectPage(project: project),
            ),
          );
        } else {
          setState(() {
            if (_selected.contains(project)) {
              _selected.remove(project);
            } else {
              _selected.add(project);
            }
          });
        }
      },
      child: Ink(
        color: index % 2 != 0
            ? primaryColor.withOpacity(0.2)
            : primaryColor.withOpacity(0.1),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12,
          ),
          minLeadingWidth: 0,
          horizontalTitleGap: 10,
          leading: _buildListTileLeadingSelection(project),
          title: Text(project.name),
          subtitle: Text("Modified ${project.updatedAtTimeAgo}"),
          trailing: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              Wrap(
                children: <Widget>[
                  IconButton(
                    onPressed: () => _showCreateOrRenameProject(project),
                    padding: const EdgeInsets.all(16),
                    icon: const Icon(Icons.mode_edit),
                  ),
                  // IconButton(
                  //   onPressed: () => _showDeleteProject(project),
                  //   padding: const EdgeInsets.all(16),
                  //   icon: const Icon(Icons.delete),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  AnimatedContainer _buildListTileLeadingSelection(Project project) {
    return AnimatedContainer(
      margin: const EdgeInsets.all(0),
      height: double.infinity,
      width: _onSelectionMode ? 30 : 0,
      duration: Durations.short4,
      child: _onSelectionMode
          ? _selected.contains(project)
              ? const Icon(Icons.check_box)
              : const Icon(Icons.check_box_outline_blank)
          : null,
    );
  }

  Form _buildFormName() {
    return Form(
      key: _form,
      child: TextFormField(
        controller: _name,
        decoration: const InputDecoration(
          labelText: 'Project name',
          border: OutlineInputBorder(),
        ),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ]")),
        ],
        validator: (value) {
          if (value!.length < 3 || value.length > 20) {
            return "The project name should be between 3 to 20 characters.";
          }

          return null;
        },
      ),
    );
  }

  Future<void> _showCreateOrRenameProject([Project? project]) {
    final title = project != null ? 'Rename Project' : 'Create Project';

    if (project != null) {
      _name.text = project.name;
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
                _renameProject(project.id);
              } else {
                _createProject();
              }

              Navigator.of(context).pop();
            }
          },
        );
      },
    ).whenComplete(() {
      _name.clear();
    });
  }

  Future<void> _showDeleteSelectedProjects() {
    return showDialog(
      context: context,
      builder: (context) {
        return ConfirmDialogWidget(
          title: 'Delete Projects',
          contents: const [
            Icon(
              Icons.warning_rounded,
              size: 48,
            ),
            Text(
              "Are you sure you want to delete all projects?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.fade,
            ),
            SizedBox(height: 15),
            Text(
              "All data associated with it will also be deleted.",
              textAlign: TextAlign.center,
            ),
          ],
          submitCallback: () {
            _removeAllSelected();
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}

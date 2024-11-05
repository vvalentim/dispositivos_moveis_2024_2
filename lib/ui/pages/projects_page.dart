import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:dispositivos_moveis_2024_2/controllers/projects_list_controller.dart';
import 'package:dispositivos_moveis_2024_2/controllers/active_project_controller.dart';
import 'package:dispositivos_moveis_2024_2/models/project.dart';
import 'package:dispositivos_moveis_2024_2/ui/pages/active_project_page.dart';
import 'package:dispositivos_moveis_2024_2/ui/widgets/bottom_sheet_widget.dart';
import 'package:dispositivos_moveis_2024_2/ui/widgets/confirm_dialog_widget.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  late ProjectsListController _controller;

  final _form = GlobalKey<FormState>();

  final _nameInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameInputController.dispose();
    super.dispose();
  }

  void _onTileTap(Project project) {
    if (_controller.selectionMode) {
      return _controller.toggleItemSelection(project);
    }

    _controller.toggleActiveProject();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          return ChangeNotifierProvider<ActiveProjectController>(
            create: (_) => ActiveProjectController(project),
            child: const ActiveProjectPage(),
          );
        },
      ),
    ).then((_) {
      _controller.toggleActiveProject();
    });
  }

  void _onTileLongPress(Project project) {
    if (_controller.selectionMode) {
      return _controller.clearSelection();
    }

    _controller.toggleItemSelection(project);
  }

  @override
  Widget build(BuildContext context) {
    _controller = Provider.of<ProjectsListController>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: _buildAppBarLeading(),
        actions: _buildAppBarActions(),
        title: const Text('Projects'),
      ),
      floatingActionButton: !_controller.loading
          ? FloatingActionButton(
              onPressed: () => _showCreateOrRenameProject(),
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            )
          : null,
      body: _buildProjectsList(),
    );
  }

  Widget? _buildAppBarLeading() {
    return _controller.selectionMode
        ? IconButton(
            onPressed: () => _controller.clearSelection(),
            icon: const Icon(Icons.undo),
          )
        : null;
  }

  List<Widget> _buildAppBarActions() {
    final List<Widget> actions = [];

    if (_controller.selectionMode) {
      actions.add(
        IconButton(
          onPressed: () => _showDeleteSelectedProjects(),
          icon: const Icon(Icons.delete),
        ),
      );
    }

    return actions;
  }

  Widget _buildProjectsList() {
    if (_controller.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: _controller.projects.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildProjectsListTile(_controller.projects[index], index);
      },
    );
  }

  Widget _buildProjectsListTile(Project project, int index) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return InkWell(
      onLongPress: () => _onTileLongPress(project),
      onTap: () => _onTileTap(project),
      child: Ink(
        color: index % 2 != 0 ? primaryColor.withOpacity(0.2) : primaryColor.withOpacity(0.1),
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Show or hide checkbox depending on "selectionMode"
  AnimatedContainer _buildListTileLeadingSelection(Project project) {
    return AnimatedContainer(
      margin: const EdgeInsets.all(0),
      height: double.infinity,
      width: _controller.selectionMode ? 30 : 0,
      duration: Durations.short4,
      child: _controller.selectionMode
          ? _controller.selected.contains(project)
              ? const Icon(Icons.check_box)
              : const Icon(Icons.check_box_outline_blank)
          : null,
    );
  }

  Form _buildFormName() {
    return Form(
      key: _form,
      child: TextFormField(
        controller: _nameInputController,
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
      _nameInputController.text = project.name;
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
                _controller.renameProject(project.id, _nameInputController.text);
              } else {
                _controller.createProject(_nameInputController.text);
              }

              Navigator.of(context).pop();
            }
          },
        );
      },
    ).whenComplete(() {
      _nameInputController.clear();
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
            _controller.removeAllSelectedProjects();
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}

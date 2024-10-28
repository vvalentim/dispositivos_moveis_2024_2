import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dispositivos_moveis_2024_2/models/project.dart';
import 'package:dispositivos_moveis_2024_2/providers/projects_provider.dart';

class ProjectsListWidget extends StatelessWidget {
  final String searchQuery;
  final Future<void> Function({Project project, bool actionRename})
      dialogCallback;

  const ProjectsListWidget({
    super.key,
    required this.searchQuery,
    required this.dialogCallback,
  });

  @override
  Widget build(BuildContext context) {
    var projectsProvider = context.watch<ProjectsProvider>();
    var filteredProjects = projectsProvider.getFilteredList(searchQuery);

    filteredProjects.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onDoubleTap: () => {},
          child: Ink(
            color:
                index % 2 == 0 ? Colors.grey.withOpacity(0.25) : Colors.white,
            child: _getProjectListTile(filteredProjects[index]),
          ),
        );
      },
      itemCount: filteredProjects.length,
      padding: const EdgeInsets.all(0),
    );
  }

  ListTile _getProjectListTile(Project project) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      leading: null,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(project.name),
          Text(
            "Modified ${project.updatedAtTimeAgo}",
            textScaler: const TextScaler.linear(0.8),
          ),
        ],
      ),
      trailing: IconButton(
        onPressed: () => dialogCallback(project: project, actionRename: true),
        icon: const Icon(Icons.mode_edit),
      ),
    );
  }
}

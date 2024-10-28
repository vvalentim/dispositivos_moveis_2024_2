import 'package:dispositivos_moveis_2024_2/models/project.dart';
import 'package:flutter/material.dart';

class ActiveProjectPage extends StatefulWidget {
  final Project project;

  const ActiveProjectPage({
    super.key,
    required this.project,
  });

  @override
  State<ActiveProjectPage> createState() => _ActiveProjectPageState();
}

class _ActiveProjectPageState extends State<ActiveProjectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project.name),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.meeting_room),
            label: 'Rooms',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Test Entries',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_chart),
            label: 'Reports',
          )
        ],
      ),
    );
  }
}

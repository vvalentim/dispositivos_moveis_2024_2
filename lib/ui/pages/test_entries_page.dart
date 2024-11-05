import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dispositivos_moveis_2024_2/controllers/active_project_controller.dart';

class TestEntriesPage extends StatefulWidget {
  const TestEntriesPage({super.key});

  @override
  State<TestEntriesPage> createState() => _TestEntriesPageState();
}

class _TestEntriesPageState extends State<TestEntriesPage> {
  late ActiveProjectController _controller;

  @override
  Widget build(BuildContext context) {
    _controller = Provider.of<ActiveProjectController>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_controller.project.name),
      ),
    );
  }
}

import 'package:dispositivos_moveis_2024_2/models/project.dart';
import 'package:flutter/material.dart';

class RoomsPage extends StatefulWidget {
  final Project project;

  const RoomsPage({
    super.key,
    required this.project,
  });

  @override
  State<RoomsPage> createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rooms'),
      ),
    );
  }
}

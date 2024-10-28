import 'package:flutter/material.dart';

class RoomPage extends StatefulWidget {
  final String projectName;

  const RoomPage({super.key, required this.projectName});

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.projectName),
      ),
      body: Container(),
    );
  }
}

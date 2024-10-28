import 'package:flutter/material.dart';

class TestEntryPage extends StatefulWidget {
  final String projectName;

  const TestEntryPage({super.key, required this.projectName});

  @override
  State<TestEntryPage> createState() => _TestEntryPageState();
}

class _TestEntryPageState extends State<TestEntryPage> {
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

import 'package:flutter/material.dart';

class TestEntriesPage extends StatefulWidget {
  const TestEntriesPage({super.key});

  @override
  State<TestEntriesPage> createState() => _TestEntriesPageState();
}

class _TestEntriesPageState extends State<TestEntriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Entries'),
      ),
    );
  }
}

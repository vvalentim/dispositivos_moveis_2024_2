import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dispositivos_moveis_2024_2/controllers/active_project_controller.dart';
import 'package:dispositivos_moveis_2024_2/ui/widgets/card_test_entry_widget.dart';
import 'package:dispositivos_moveis_2024_2/ui/widgets/empty_list_message_widget.dart';

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
      body: _buildTestEntriesList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildTestEntriesList() {
    if (_controller.rooms.isEmpty) {
      return const EmptyListMessageWidget(
        title: "Looks like you didn't add any rooms yet.",
        subtitle: 'Add a new room to be able to upload test data.',
      );
    }

    if (_controller.testEntries.isEmpty) {
      return const EmptyListMessageWidget(
        title: "Looks like you didn't add any test data yet.",
        subtitle: 'Click on the button below to create a new entry.',
      );
    }

    return ListView.builder(
      itemCount: _controller.testEntries.length,
      itemBuilder: (BuildContext context, int index) {
        // TODO: pass callbacks and/or values instead of the controller

        return CardTestEntryWidget(
          entry: _controller.testEntries[index],
          controller: _controller,
        );
      },
    );
  }
}

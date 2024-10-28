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
        title: const Text(
          'Project Name',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),

      body: Container(),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
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

      //
    );
  }
}

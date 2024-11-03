import 'package:dispositivos_moveis_2024_2/pages/test_entries_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/room.dart';

class ActiveRoomPage extends StatefulWidget{
  final Room room;

  const ActiveRoomPage({
    super.key,
    required this.room,
  });

  @override
  State<ActiveRoomPage> createState() => _ActiveRoomPageState();
}

class _ActiveRoomPageState extends State<ActiveRoomPage> {
  int _currentPage = 0;

  late PageController _pageController;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: _currentPage);
  }

  void setCurrentPage(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (page) {
          setCurrentPage(page);
        },

      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        onTap: (page) {
          _pageController.animateToPage(
            page,
            duration: Durations.medium1,
            curve: Curves.ease,
          );
        },
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
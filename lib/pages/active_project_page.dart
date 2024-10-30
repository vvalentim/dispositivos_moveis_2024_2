import 'package:dispositivos_moveis_2024_2/models/project.dart';
import 'package:dispositivos_moveis_2024_2/pages/reports_page.dart';
import 'package:dispositivos_moveis_2024_2/pages/rooms_page.dart';
import 'package:dispositivos_moveis_2024_2/pages/test_entries_page.dart';
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
        children: [
          RoomsPage(project: widget.project),
          const TestEntriesPage(),
          const ReportsPage(),
        ],
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

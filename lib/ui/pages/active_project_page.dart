import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dispositivos_moveis_2024_2/ui/pages/reports_page.dart';
import 'package:dispositivos_moveis_2024_2/ui/pages/rooms_page.dart';
import 'package:dispositivos_moveis_2024_2/ui/pages/test_entries_page.dart';
import 'package:dispositivos_moveis_2024_2/controllers/active_project_controller.dart';

class ActiveProjectPage extends StatefulWidget {
  const ActiveProjectPage({super.key});

  @override
  State<ActiveProjectPage> createState() => _ActiveProjectPageState();
}

class _ActiveProjectPageState extends State<ActiveProjectPage> {
  int _currentPage = 0;

  late ActiveProjectController _controller;

  late PageController _pageViewController;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController(initialPage: _currentPage);
  }

  @override
  Widget build(BuildContext context) {
    _controller = Provider.of<ActiveProjectController>(context);

    if (_controller.loading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: PageView(
        controller: _pageViewController,
        onPageChanged: (page) {
          setState(() {
            _currentPage = page;
          });
        },
        children: const [
          RoomsPage(),
          TestEntriesPage(),
          ReportsPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        onTap: (page) {
          _pageViewController.animateToPage(
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

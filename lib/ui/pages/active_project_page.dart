import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dispositivos_moveis_2024_2/controllers/active_project_controller.dart';
import 'package:dispositivos_moveis_2024_2/ui/pages/reports_page.dart';
import 'package:dispositivos_moveis_2024_2/ui/pages/rooms_page.dart';
import 'package:dispositivos_moveis_2024_2/ui/pages/test_entries_page.dart';

class ActiveProjectPage extends StatefulWidget {
  final int projectId;

  const ActiveProjectPage({super.key, required this.projectId});

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
      body: ChangeNotifierProvider(
        create: (context) => ActiveProjectController(),
        child: PageView(
          controller: _pageController,
          onPageChanged: (page) {
            setCurrentPage(page);
          },
          children: const [
            RoomsPage(),
            TestEntriesPage(),
            ReportsPage(),
          ],
        ),
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

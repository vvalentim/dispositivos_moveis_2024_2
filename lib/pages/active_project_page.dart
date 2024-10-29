import 'package:dispositivos_moveis_2024_2/models/project.dart';
import 'package:dispositivos_moveis_2024_2/pages/reports_page.dart';
import 'package:dispositivos_moveis_2024_2/pages/rooms_page.dart';
import 'package:dispositivos_moveis_2024_2/pages/test_entries_page.dart';
import 'package:dispositivos_moveis_2024_2/providers/active_project_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  int currentPage = 0;

  bool didUpdateProject = false;

  late PageController pageController;

  @override
  void initState() {
    super.initState();

    pageController = PageController(initialPage: currentPage);
  }

  void setCurrentPage(int page) {
    setState(() {
      currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => ActiveProjectProvider(widget.project),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.project.name),
        ),
        body: PageView(
          controller: pageController,
          onPageChanged: (page) {
            setCurrentPage(page);
          },
          children: const [
            RoomsPage(),
            TestEntriesPage(),
            ReportsPage(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentPage,
          onTap: (page) {
            pageController.animateToPage(
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
      ),
    );
  }
}

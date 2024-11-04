import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dispositivos_moveis_2024_2/ui/theme/theme.dart';
import 'package:dispositivos_moveis_2024_2/ui/pages/projects_page.dart';
import 'package:dispositivos_moveis_2024_2/controllers/projects_list_controller.dart';

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.defaultTheme,
      themeMode: ThemeMode.dark,
      home: ChangeNotifierProvider(
        create: (context) => ProjectsListController(),
        child: const ProjectsPage(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

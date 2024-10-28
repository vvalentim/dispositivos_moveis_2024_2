import 'package:flutter/material.dart';
import 'package:dispositivos_moveis_2024_2/pages/projects_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const ProjectsPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

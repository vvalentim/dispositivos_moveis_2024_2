import 'package:dispositivos_moveis_2024_2/providers/projects_provider.dart';
import 'package:flutter/material.dart';
import 'package:dispositivos_moveis_2024_2/app.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => ProjectsProvider(),
    child: const App(),
  ));
}

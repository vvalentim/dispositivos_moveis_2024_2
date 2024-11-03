import 'package:dispositivos_moveis_2024_2/providers/projects_provider.dart';
import 'package:dispositivos_moveis_2024_2/providers/rooms_provider.dart';
import 'package:flutter/material.dart';
import 'package:dispositivos_moveis_2024_2/app.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProjectsProvider()),
        ChangeNotifierProvider(create: (context) => RoomsProvider()),
      ],
      child: const App(),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:dispositivos_moveis_2024_2/locator.dart';
import 'package:dispositivos_moveis_2024_2/repositories/active_project/active_project_repository.dart';

class ActiveProjectController extends ChangeNotifier {
  final ActiveProjectRepository _repository = locator<ActiveProjectRepository>();

  ActiveProjectController();
}

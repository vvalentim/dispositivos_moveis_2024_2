import 'dart:collection';

import 'package:dispositivos_moveis_2024_2/models/project.dart';

class ActiveProjectProvider {
  final Project _project;

  ActiveProjectProvider(this._project);

  UnmodifiableListView get rooms => UnmodifiableListView(_project.rooms);
}

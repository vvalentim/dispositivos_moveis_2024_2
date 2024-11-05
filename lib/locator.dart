import 'package:get_it/get_it.dart';

// Contracts
import 'package:dispositivos_moveis_2024_2/repositories/projects_list/projects_list_repository.dart';
import 'package:dispositivos_moveis_2024_2/repositories/active_project/active_project_repository.dart';

// Implementation
import 'package:dispositivos_moveis_2024_2/repositories/active_project/memory_active_project_repository.dart';
import 'package:dispositivos_moveis_2024_2/repositories/projects_list/memory_projects_list_repository.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<ProjectsListRepository>(() => MemoryProjectsListRepository());
  locator.registerLazySingleton<ActiveProjectRepository>(() => MemoryActiveProjectRepository());
}

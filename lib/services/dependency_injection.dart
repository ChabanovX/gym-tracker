import 'package:get_it/get_it.dart';

import '/blocs/workout_bloc/workout_bloc.dart';
import '/blocs/exercise_service_bloc/exercise_service_bloc.dart';
import '/repositories/workout_repository.dart';

final getIt = GetIt.instance;

Future<void> setUpDependencies() async {
  // Register Repositories
  getIt.registerLazySingleton<WorkoutRepository>(() => WorkoutRepository());

  // Register Services
  getIt.registerSingletonAsync<ExerciseServiceBloc>(() async {
    final service = ExerciseServiceBloc();
    await service.loadExercises();
    return service;
  });

  // Register Blocs
  getIt.registerFactory<WorkoutBloc>(
      () => WorkoutBloc(workoutRepository: getIt<WorkoutRepository>()));
}

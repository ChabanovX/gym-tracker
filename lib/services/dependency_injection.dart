import 'package:get_it/get_it.dart';
import '../blocs/workout_bloc/workout_bloc.dart';
import '../repositories/workout_repository.dart';
import '../services/exercise_service.dart';

final getIt = GetIt.instance;

void setUpDependencies() {
  // Register Repositories
  getIt.registerLazySingleton<WorkoutRepository>(() => WorkoutRepository());

  // Register Services
  getIt.registerLazySingleton<ExerciseService>(() => ExerciseService());

  // Register Blocs
  getIt.registerFactory<WorkoutBloc>(
      () => WorkoutBloc(workoutRepository: getIt<WorkoutRepository>()));
}
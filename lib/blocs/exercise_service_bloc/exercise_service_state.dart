import '/models/basic_exercise_model/exercise.dart';

abstract class ExerciseServiceState {}

class ExerciseServiceInitial extends ExerciseServiceState {}

class ExerciseServiceLoading extends ExerciseServiceState {}

class ExerciseServiceLoaded extends ExerciseServiceState {

  final List<Exercise> exercises;

  ExerciseServiceLoaded({required this.exercises});
}

class ExerciseServiceError extends ExerciseServiceState {

  final String message;

  ExerciseServiceError({required this.message});
}


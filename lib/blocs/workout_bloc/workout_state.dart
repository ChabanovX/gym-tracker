import '../../models/workout.dart';

abstract class WorkoutState {}

class WorkoutInitialState extends WorkoutState {}

class WorkoutLoadingState extends WorkoutState {}

class WorkoutLoadedState extends WorkoutState {
  final List<Workout> workouts;

  WorkoutLoadedState(this.workouts);
}

class WorkoutErrorState extends WorkoutState {
  final String message;

  WorkoutErrorState(this.message);
}


import '../../models/workout_model/workout.dart';

abstract class WorkoutState {}

class WorkoutInitialState extends WorkoutState {}

class WorkoutLoadingState extends WorkoutState {}

class WorkoutLoadedState extends WorkoutState {
  final List<Workout> workouts;

  WorkoutLoadedState(this.workouts);
}

class WorkoutAddedState extends WorkoutState {
  final Workout workout;

  WorkoutAddedState(this.workout);
}

class WorkoutErrorState extends WorkoutState {
  final String message;

  WorkoutErrorState(this.message);
}


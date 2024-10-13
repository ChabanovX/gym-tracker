import '../../models/workout.dart';

abstract class WorkoutEvent {}

class LoadWorkoutsEvent extends WorkoutEvent {}

class AddWorkoutEvent extends WorkoutEvent {
  final Workout workout;
  AddWorkoutEvent(this.workout);
}

class UpdateWorkoutEvent extends WorkoutEvent {
  final Workout workout;
  UpdateWorkoutEvent(this.workout);
}

class DeleteWorkoutEvent extends WorkoutEvent {
  final Workout workout;
  DeleteWorkoutEvent(this.workout);
}



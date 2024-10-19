import 'package:hive/hive.dart';
import '../models/workout_model/workout.dart';

class WorkoutRepository {
  final Box<Workout> _workoutBox = Hive.box<Workout>('workouts');

  Future<void> addWorkout(Workout workout) async {
    await _workoutBox.put(workout.id, workout);
  }

  Future<void> updateWorkout(Workout workout) async {
    await _workoutBox.put(workout.id, workout);
  }

  Future<void> deleteWorkout(Workout workout) async {
    await _workoutBox.delete(workout.id);
  }

  List<Workout> getAllWorkouts() {
    return _workoutBox.values.toList();
  }

  Workout? getWorkoutById(String id) {
    return _workoutBox.get(id);
  }
}

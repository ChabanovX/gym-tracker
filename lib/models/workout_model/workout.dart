import 'package:hive/hive.dart';

import '../advanced_exercise_model/workout_exercise.dart';

part 'workout.g.dart';

@HiveType(typeId: 0)
class Workout {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final List<WorkoutExercise> exercises;

  @HiveField(4)
  final Duration duration;

  Workout({
    required this.id,
    required this.name,
    required this.date,
    required this.exercises,
    required this.duration,
  });
}

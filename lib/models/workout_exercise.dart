import 'package:hive/hive.dart';
import 'exercise_set.dart';

part 'workout_exercise.g.dart';

@HiveType(typeId: 2)
class WorkoutExercise {
  @HiveField(0)
  final int exerciseId;

  @HiveField(1)
  final List<ExerciseSet> sets;

  WorkoutExercise({
    required this.exerciseId,
    required this.sets,
  });
}

import 'package:hive/hive.dart';
import '../exercise_set_model/exercise_set.dart';

part 'workout_exercise.g.dart';

@HiveType(typeId: 2)
class WorkoutExercise {
  @HiveField(0)
  final String exerciseName;

  @HiveField(1)
  late List<ExerciseSet>? sets;

  WorkoutExercise({
    required this.exerciseName,
    this.sets,
  });

  void setSets(List<ExerciseSet> sets) {
    this.sets = sets;
  }

  void addSet(ExerciseSet set) {
    sets ??= [];
    sets!.add(set);
  }
}

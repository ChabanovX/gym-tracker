import 'package:hive_flutter/hive_flutter.dart';

part 'exercise_set.g.dart';

@HiveType(typeId: 1)
class ExerciseSet {
  @HiveField(0)
  final int reps;

  @HiveField(1)
  final double weight;

  ExerciseSet({
    required this.reps,
    required this.weight,
  });
}

import 'package:hive/hive.dart';

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
  final List<int> exerciseIds;

  Workout({
    required this.id,
    required this.name,
    required this.date,
    required this.exerciseIds,
  });
}

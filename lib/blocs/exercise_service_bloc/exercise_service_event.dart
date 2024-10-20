
abstract class ExerciseServiceEvent {}

class GetExercisesEvent extends ExerciseServiceEvent {
  final ExerciseFetchType fetchType;
  final int? id;
  final List<int>? ids;
  final String? category;

  GetExercisesEvent({
    required this.fetchType,
    this.id,
    this.ids,
    this.category,
  });
}

enum ExerciseFetchType {
  all,
  id,
  ids,
  category,
}

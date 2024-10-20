import '/models/basic_exercise_model/exercise.dart';

abstract class ExerciseServiceEvent {}

class GetExercisesEvent extends ExerciseServiceEvent {}

class GetExerciseByIdEvent extends ExerciseServiceEvent {
  final int id;

  GetExerciseByIdEvent(this.id);
}

class GetExercisesByIdsEvent extends ExerciseServiceEvent {
  final List<int> ids;

  GetExercisesByIdsEvent(this.ids);
}

class GetExercisesByCategoryEvent extends ExerciseServiceEvent {
  final String category;

  GetExercisesByCategoryEvent(this.category);
}

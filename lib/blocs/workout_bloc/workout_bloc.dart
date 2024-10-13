import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/workout_repository.dart';
import 'workout_event.dart';
import 'workout_state.dart';

class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  final WorkoutRepository workoutRepository;

  WorkoutBloc({required this.workoutRepository})
      : super(WorkoutInitialState()) {
    on<LoadWorkoutsEvent>(_onLoadWorkouts);
    on<AddWorkoutEvent>(_onAddWorkout);
    on<UpdateWorkoutEvent>(_onUpdateWorkout);
    on<DeleteWorkoutEvent>(_onDeleteWorkout);
  }

  void _onLoadWorkouts(
      LoadWorkoutsEvent event, Emitter<WorkoutState> emit) async {
    emit(WorkoutLoadingState());
    try {
      final workouts = workoutRepository.getAllWorkouts();
      emit(WorkoutLoadedState(workouts));
    } catch (e) {
      emit(WorkoutErrorState("Failed to load workouts"));
    }
  }

  void _onAddWorkout(AddWorkoutEvent event, Emitter<WorkoutState> emit) async {
    try {
      workoutRepository.addWorkout(event.workout);
      add(LoadWorkoutsEvent());
    } catch (e) {
      emit(WorkoutErrorState("Failed to add workout"));
    }
  }

  void _onUpdateWorkout(
      UpdateWorkoutEvent event, Emitter<WorkoutState> emit) async {
    try {
      workoutRepository.updateWorkout(event.workout);
      add(LoadWorkoutsEvent());
    } catch (e) {
      emit(WorkoutErrorState("Failed to update workout"));
    }
  }

  void _onDeleteWorkout(
      DeleteWorkoutEvent event, Emitter<WorkoutState> emit) async {
    try {
      workoutRepository.deleteWorkout(event.workout);
      add(LoadWorkoutsEvent());
    } catch (e) {
      emit(WorkoutErrorState("Failed to delete workout"));
    }
  }
}

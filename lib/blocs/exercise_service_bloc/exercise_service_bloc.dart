import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

import '/models/basic_exercise_model/exercise.dart';
import 'exercise_service_event.dart';
import 'exercise_service_state.dart';

class ExerciseServiceBloc
    extends Bloc<ExerciseServiceEvent, ExerciseServiceState> {
  List<Exercise>? _exercises;

  ExerciseServiceBloc() : super(ExerciseServiceInitial()) {
    on<GetExercisesEvent>(_onGetExercises);
  }

  void _onGetExercises(
    GetExercisesEvent event,
    Emitter<ExerciseServiceState> emit,
  ) async {
    emit(ExerciseServiceLoading());
    try {
      if (_exercises == null) {
        await loadExercises();
      }
      switch (event.fetchType) {
        case ExerciseFetchType.all:
          emit(ExerciseServiceLoaded(
            exercises: _exercises!,
          ));
          break;
        case ExerciseFetchType.id:
          emit(ExerciseServiceLoaded(
            exercises: [
              _exercises!.firstWhere((exercise) => exercise.id == event.id!)
            ],
          ));
          break;
        case ExerciseFetchType.ids:
          emit(ExerciseServiceLoaded(
            exercises: _exercises!
                .where((exercise) => event.ids!.contains(exercise.id))
                .toList(),
          ));
          break;
        case ExerciseFetchType.category:
          emit(ExerciseServiceLoaded(
            exercises: _exercises!
                .where((exercise) => exercise.category == event.category!)
                .toList(),
          ));
          break;
      }
    } catch (e) {
      emit(ExerciseServiceError(message: "Failed to load exercises\n $e"));
    }
  }

  Future<void> loadExercises() async {
    final String response =
        await rootBundle.loadString('assets/exercises.json');
    final List<dynamic> data = json.decode(response);

    _exercises = data.map((json) => Exercise.fromJson(json)).toList();
  }
}

import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

import '/models/basic_exercise_model/exercise.dart';
import 'exercise_service_event.dart';
import 'exercise_service_state.dart';

enum ExerciseFetchType {
  all,
  id,
  ids,
  category,
}

class ExerciseServiceBloc
    extends Bloc<ExerciseServiceEvent, ExerciseServiceState> {
  List<Exercise>? _exercises;

  ExerciseServiceBloc() : super(ExerciseServiceInitial()) {
    on<GetExercisesEvent>(_onGetExercises);
    on<GetExerciseByIdEvent>(_onGetExercises);
    on<GetExercisesByIdsEvent>(_onGetExercises);
    on<GetExercisesByCategoryEvent>(_onGetExercises);
  }

  void _onGetExercises(
    GetExercisesEvent event,
    Emitter<ExerciseServiceState> emit,
    ExerciseFetchType fetchType,
  ) async {
    emit(ExerciseServiceLoading());
    try {
      if (_exercises == null) {
        await _loadExercises();
      }
      switch (fetchType) {
        case ExerciseFetchType.all:
          emit(ExerciseServiceLoaded(
            exercises: _exercises!,
          ));
          break;
        case ExerciseFetchType.id:
          emit(ExerciseServiceLoaded(
            exercises: _exercises!.firstWhere((exercise) => exercise.id == id),
          ));
          break;
        case ExerciseFetchType.ids:
          emit(ExerciseServiceLoaded(
            exercises: _exercises!
                .where((exercise) => ids.contains(exercise.id))
                .toList(),
          ));
          break;
        case ExerciseFetchType.category:
          emit(ExerciseServiceLoaded(
            exercises: _exercises!
                .where((exercise) => exercise.category == category)
                .toList(),
          ));
          break;
      }
    } catch (e) {
      emit(ExerciseServiceError(message: "Failed to load exercises"));
    }
  }

  Future<void> _loadExercises() async {
    final String response =
        await rootBundle.loadString('assets/exercises.json');
    final List<dynamic> data = json.decode(response);

    _exercises = data.map((json) => Exercise.fromJson(json)).toList();
  }

  Exercise? getExerciseById(int id) {
    if (_exercises == null) {
      return null;
    }
    return _exercises!.firstWhere((exercise) => exercise.id == id);
  }

  List<Exercise> getExercisesByIds(List<int> ids) {
    if (_exercises == null) return [];
    return _exercises!.where((exercise) => ids.contains(exercise.id)).toList();
  }

  // Available categories: chest | legs | back | arms | shoulders
  List<Exercise> getExercisesByCategory(String category) {
    if (_exercises == null) return [];
    return _exercises!
        .where((exercise) => exercise.category == category)
        .toList();
  }

  void _onGetExerciseById(
    GetExerciseByIdEvent event,
    Emitter<ExerciseServiceState> emit,
  ) async {
    emit(ExerciseServiceLoading());
    try {
      if (_exercises == null) {
        await _loadExercises();
      }
      emit(ExerciseServiceLoaded(exercises: _exercises!));
    } catch (e) {
      emit(ExerciseServiceError(message: "Failed to load exercises"));
    }
  }

  void _onGetExercisesByIds(
    GetExercisesByIdsEvent event,
    Emitter<ExerciseServiceState> emit,
  ) async {
    emit(ExerciseServiceLoading());
    try {
      if (_exercises == null) {
        await _loadExercises();
      }
      emit(ExerciseServiceLoaded(exercises: _exercises!));
    } catch (e) {
      emit(ExerciseServiceError(message: "Failed to load exercises"));
    }
  }

  void _onGetExercisesByCategory(
    GetExercisesByCategoryEvent event,
    Emitter<ExerciseServiceState> emit,
  ) async {
    emit(ExerciseServiceLoading());
    try {
      if (_exercises == null) {
        await _loadExercises();
      }
      emit(ExerciseServiceLoaded(exercises: _exercises!));
    } catch (e) {
      emit(ExerciseServiceError(message: "Failed to load exercises"));
    }
  }
}

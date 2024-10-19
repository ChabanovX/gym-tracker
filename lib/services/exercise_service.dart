import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/basic_exercise_model/exercise.dart';

class ExerciseService {
  List<Exercise>? _exercises;

  Future<List<Exercise>> getExercises() async {
    if (_exercises == null) {
      await _loadExercises();
    }
    return _exercises!;
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
}

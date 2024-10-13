import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/exercise.dart';
import '../../services/exercise_service.dart';
import '../../services/dependency_injection.dart';

class AddExercisePopup extends StatefulWidget {
  // Add a callback to return the selected exercise
  final Function(Exercise) onExerciseSelected;

  const AddExercisePopup({required this.onExerciseSelected, super.key});

  @override
  createState() => _AddExercisePopupState();
}

class _AddExercisePopupState extends State<AddExercisePopup> {
  late ExerciseService _exerciseService;
  List<Exercise> _exercises = [];
  List<Exercise> _filteredExercises = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _exerciseService = getIt<ExerciseService>();
    _loadExercises();
  }

  void _loadExercises() async {
    try {
    List<Exercise> exercises = await _exerciseService.getExercises();
    setState(() {
      _exercises = exercises;
      _filteredExercises = exercises;
      _isLoading = false;
    });
    } catch (e) {
      setState(() {
        _isLoading = true;
        print(e);
      });
    }
  }

  void _filterExercises(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredExercises = _exercises;
      });
    } else {
      setState(() {
        _filteredExercises = _exercises
            .where((exercise) =>
                exercise.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPopupSurface(
      isSurfacePainted: true,
      child: SafeArea(
        top: false,
        child: Container(
          height: 660,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CupertinoSearchTextField(
                  placeholder: 'Search exercises...',
                  onChanged: (text) {
                    _filterExercises(text);
                  },
                ),
              ),
              Expanded(
                child: _isLoading
                    ? const Center(child: CupertinoActivityIndicator())
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12.0,
                            mainAxisSpacing: 12.0,
                            childAspectRatio: 3 / 4,
                          ),
                          itemCount: _filteredExercises.length,
                          itemBuilder: (context, index) {
                            final exercise = _filteredExercises[index];
                            return GestureDetector(
                              onTap: () {
                                // Pass the exercise to the callback
                                widget.onExerciseSelected(exercise);
                                Navigator.pop(
                                    context); // Close the popup after selection
                              },
                              child: GridTile(
                                footer: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color:
                                        CupertinoColors.black.withOpacity(0.5),
                                    borderRadius: const BorderRadius.vertical(
                                      bottom: Radius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    exercise.name,
                                    textAlign: TextAlign.center,
                                    style: CupertinoTheme.of(context)
                                        .textTheme
                                        .navTitleTextStyle
                                        .copyWith(
                                          fontSize: 14,
                                          color: CupertinoColors.white,
                                        ),
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    exercise.imagePath,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) => const Icon(
                                      CupertinoIcons.exclamationmark_circle,
                                      size: 40,
                                      color: CupertinoColors.systemRed,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

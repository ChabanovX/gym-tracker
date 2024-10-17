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
  List<String> _categories = [];
  List<String> _selectedCategories = [];
  String _currentQuery = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _exerciseService = getIt<ExerciseService>();
    _loadExercises();
  }

  List<String> _extractCategories(List<Exercise> exercises) {
    return exercises.map((e) => e.category).toSet().toList();
  }

  void _loadExercises() async {
    try {
      List<Exercise> exercises = await _exerciseService.getExercises();
      _categories = _extractCategories(exercises);
      setState(() {
        _exercises = exercises;
        _filteredExercises = exercises;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = true;
      });
    }
  }

  // Matches both query and category
  void _filterExercises(String query) {
    _currentQuery = query;
    setState(() {
      _filteredExercises = _exercises.where((exercise) {
        final matchesQuery =
            exercise.name.toLowerCase().contains(query.toLowerCase());
        final matchesCategory = _selectedCategories.isEmpty ||
            _selectedCategories.contains(exercise.category);
        return matchesQuery && matchesCategory;
      }).toList();
    });
  }

  Widget _buildSearchField() {
    return Padding(
      // padding: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: CupertinoSearchTextField(
        placeholder: 'Search exercises...',
        onChanged: (text) {
          _filterExercises(text);
        },
      ),
    );
  }

Widget _buildCategoryFilter() {
  return Container(
    height: 40,
    margin: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distribute buttons evenly
      children: _categories.map((category) {
        final isSelected = _selectedCategories.contains(category);
        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                if (isSelected) {
                  _selectedCategories.remove(category);
                } else {
                  _selectedCategories.add(category);
                }
                _filterExercises(_currentQuery);
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              padding: const EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                color: isSelected
                    ? CupertinoTheme.of(context).primaryColor
                    : CupertinoColors.systemGrey4,
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Center(
                child: Text(
                  category,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14, // Adjust font size as needed
                    color: isSelected
                        ? CupertinoColors.white
                        : CupertinoColors.black,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return CupertinoPopupSurface(
      isSurfacePainted: true,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 660,
          child: Column(
            children: [
              _buildSearchField(),
              _buildCategoryFilter(),
              Expanded(
                child: _isLoading
                    ? const Center(child: CupertinoActivityIndicator())
                    : _buildGrid(
                        filteredExercises: _filteredExercises,
                        onExerciseSelected: (widget.onExerciseSelected)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

GridView _buildGrid({
  required List<Exercise> filteredExercises,
  required Function(Exercise) onExerciseSelected,
}) {
  return GridView.builder(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 12.0,
      mainAxisSpacing: 12.0,
      childAspectRatio: 3 / 4,
    ),
    itemCount: filteredExercises.length,
    itemBuilder: (context, index) {
      final exercise = filteredExercises[index];
      return GestureDetector(
        onTap: () {
          onExerciseSelected(exercise);
          Navigator.pop(context);
        },
        child: GridTile(
          footer: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: CupertinoColors.black.withOpacity(0.5),
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
              errorBuilder: (context, error, stackTrace) => const Icon(
                CupertinoIcons.exclamationmark_circle,
                size: 40,
                color: CupertinoColors.systemRed,
              ),
            ),
          ),
        ),
      );
    },
  );
}

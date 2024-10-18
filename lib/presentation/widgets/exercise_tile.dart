import 'package:flutter/cupertino.dart';

import 'package:gymgym/models/exercise_set.dart';
import 'package:gymgym/models/workout_exercise.dart';

class ExerciseTile extends StatefulWidget {
  final WorkoutExercise exercise;

  const ExerciseTile({super.key, required this.exercise});

  @override
  _ExerciseTileState createState() => _ExerciseTileState();
}

class _ExerciseTileState extends State<ExerciseTile> {
  bool _isExpanded = false; // Manage the expansion state
  final TextEditingController _repsController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  @override
  void dispose() {
    _repsController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded; // Toggle expansion state
        });
      },
      child: Column(
        children: [
          // The main tile
          Container(
            height: 70,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: (widget.exercise.sets == null ||
                      widget.exercise.sets!.isEmpty)
                  ? CupertinoColors.inactiveGray
                  : CupertinoTheme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: CupertinoColors.black.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      CupertinoIcons.flame_fill,
                      color: CupertinoColors.white,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      widget.exercise.exerciseName,
                      style: CupertinoTheme.of(context)
                          .textTheme
                          .textStyle
                          .copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: CupertinoColors.white,
                          ),
                    ),
                  ],
                ),
                Icon(
                  _isExpanded
                      ? CupertinoIcons.chevron_down
                      : CupertinoIcons.chevron_forward,
                  color: CupertinoTheme.of(context).primaryContrastingColor,
                ),
              ],
            ),
          ),

          // Animated dropdown section for inputting sets, reps, and weight
          AnimatedContainer(
            duration: const Duration(milliseconds: 200), // Animation duration
            curve: Curves.easeInSine, // Animation curve
            height: _isExpanded ? 75 : 0, // Toggle height based on _isExpanded
            child: SingleChildScrollView(
              // Add scroll functionality
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: _isExpanded
                    ? Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: CupertinoTextField(
                                  controller: _repsController,
                                  placeholder: 'Reps',
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: CupertinoTextField(
                                  controller: _weightController,
                                  placeholder: 'Weight (kg)',
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              CupertinoButton(
                                child: const Text('Add Set'),
                                onPressed: () {
                                  int reps =
                                      int.tryParse(_repsController.text) ?? 0;
                                  double weight =
                                      double.tryParse(_weightController.text) ??
                                          0.0;
                                  if (reps > 0 && weight > 0) {
                                    setState(() {
                                      widget.exercise.setSets([
                                        ExerciseSet(reps: reps, weight: weight)
                                      ]);
                                    });
                                    print(
                                      "Added sets for ${widget.exercise.exerciseName}: $weight kg x $reps reps",
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      )
                    : null, // If not expanded, don't show the content
              ),
            ),
          ),
        ],
      ),
    );
  }
}

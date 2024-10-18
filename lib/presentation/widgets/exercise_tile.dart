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

  void _addSet() {
    int reps = int.tryParse(_repsController.text) ?? 0;
    double weight = double.tryParse(_weightController.text) ?? 0.0;
    if (reps > 0 && weight > 0) {
      setState(() {
        widget.exercise.addSet(
          ExerciseSet(reps: reps, weight: weight),
        );
      });
      // Clear input fields
      _repsController.clear();
      _weightController.clear();
      // Show confirmation
      _showCupertinoNotification(
        title: "Success",
        message:
            "Added set: $weight kg x $reps reps for ${widget.exercise.exerciseName}",
        color: CupertinoColors.systemGreen,
      );
    } else {
      // Show error message
      _showCupertinoNotification(
        title: "Error",
        message: "Please enter valid reps and weight.",
        color: CupertinoColors.systemRed,
      );
    }
  }

  void _deleteSet(int index) {
    setState(() {
      widget.exercise.sets = [
        ...widget.exercise.sets!..removeAt(index),
      ];
    });
    _showCupertinoNotification(
      title: "Deleted",
      message: "Deleted set ${index + 1} for ${widget.exercise.exerciseName}",
      color: CupertinoColors.systemYellow,
    );
  }

  void _editSet(int index, int newReps, double newWeight) {
    setState(() {
      widget.exercise.sets = [
        for (int i = 0; i < widget.exercise.sets!.length; i++)
          if (i == index)
            ExerciseSet(reps: newReps, weight: newWeight)
          else
            widget.exercise.sets![i],
      ];
    });
    _showCupertinoNotification(
      title: "Updated",
      message: "Updated set ${index + 1} for ${widget.exercise.exerciseName}",
      color: CupertinoColors.systemBlue,
    );
  }

  void _showCupertinoNotification(
      {required String title, required String message, required Color color}) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine tile color based on whether sets are added
    final bool hasSets =
        widget.exercise.sets != null && widget.exercise.sets!.isNotEmpty;
    final Color tileColor =
        hasSets ? CupertinoColors.systemOrange : CupertinoColors.inactiveGray;

    return Column(
      children: [
        // The main tile
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded; // Toggle expansion state
            });
          },
          child: Container(
            height: 70,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: tileColor,
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
                // Exercise Name and Icon
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
                // Set Summary and Expand/Collapse Icon
                Row(
                  children: [
                    if (hasSets)
                      Row(
                        children: [
                          const Icon(
                            CupertinoIcons.check_mark_circled,
                            color: CupertinoColors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.exercise.sets!.length} Set(s)',
                            style: CupertinoTheme.of(context)
                                .textTheme
                                .textStyle
                                .copyWith(
                                  fontSize: 16,
                                  color: CupertinoColors.white,
                                ),
                          ),
                        ],
                      ),
                    const SizedBox(width: 8),
                    Icon(
                      _isExpanded
                          ? CupertinoIcons.chevron_down
                          : CupertinoIcons.chevron_forward,
                      color: CupertinoTheme.of(context).primaryContrastingColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Animated dropdown section for inputting sets, reps, and weight
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: _isExpanded
              ? Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      // Input Fields for Reps and Weight
                      Row(
                        children: [
                          Expanded(
                            child: CupertinoTextField(
                              controller: _repsController,
                              placeholder: 'Reps',
                              keyboardType: TextInputType.number,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CupertinoTextField(
                              controller: _weightController,
                              placeholder: 'Weight (kg)',
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                            ),
                          ),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: const Text('Add Set'),
                            onPressed: _addSet,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // List of Added Sets
                      if (hasSets)
                        CupertinoListSection.insetGrouped(
                          header: const Text('Added Sets'),
                          children: [
                            for (int index = 0;
                                index < widget.exercise.sets!.length;
                                index++)
                              CupertinoListTile(
                                title: Text(
                                  'Set ${index + 1}: ${widget.exercise.sets![index].weight} kg x ${widget.exercise.sets![index].reps} reps',
                                  style: CupertinoTheme.of(context)
                                      .textTheme
                                      .textStyle
                                      .copyWith(
                                        fontSize: 16,
                                      ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      child: const Icon(
                                        CupertinoIcons.pencil,
                                        color: CupertinoColors.systemBlue,
                                      ),
                                      onPressed: () {
                                        _showEditDialog(index,
                                            widget.exercise.sets![index]);
                                      },
                                    ),
                                    CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      child: const Icon(
                                        CupertinoIcons.delete_simple,
                                        color: CupertinoColors.systemRed,
                                      ),
                                      onPressed: () {
                                        _confirmDelete(index);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  // Function to show a dialog for editing a set
  void _showEditDialog(int index, ExerciseSet set) {
    final TextEditingController editRepsController =
        TextEditingController(text: set.reps.toString());
    final TextEditingController editWeightController =
        TextEditingController(text: set.weight.toString());

    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('Edit Set ${index + 1}'),
          content: Column(
            children: [
              const SizedBox(height: 10),
              CupertinoTextField(
                controller: editRepsController,
                placeholder: 'Reps',
                keyboardType: TextInputType.number,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
              const SizedBox(height: 10),
              CupertinoTextField(
                controller: editWeightController,
                placeholder: 'Weight (kg)',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: const Text('Save'),
              onPressed: () {
                int newReps = int.tryParse(editRepsController.text) ?? set.reps;
                double newWeight =
                    double.tryParse(editWeightController.text) ?? set.weight;
                if (newReps > 0 && newWeight > 0) {
                  _editSet(index, newReps, newWeight);
                  Navigator.of(context).pop();
                } else {
                  // Show error message
                  _showCupertinoNotification(
                    title: "Error",
                    message: "Please enter valid reps and weight.",
                    color: CupertinoColors.systemRed,
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Function to confirm deletion
  void _confirmDelete(int index) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Delete Set'),
          content: Text('Are you sure you want to delete set ${index + 1}?'),
          actions: [
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text('Delete'),
              onPressed: () {
                _deleteSet(index);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

// Custom CupertinoListTile since Cupertino doesn't have a built-in ListTile
class CupertinoListTile extends StatelessWidget {
  final Widget title;
  final Widget? trailing;

  const CupertinoListTile({super.key, required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: CupertinoColors.separator,
            width: 0.0, // One physical pixel.
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: title),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

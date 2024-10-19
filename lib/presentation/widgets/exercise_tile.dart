import 'package:flutter/cupertino.dart';
import 'package:gymgym/models/exercise_set.dart';
import 'package:gymgym/models/workout_exercise.dart';

class ExerciseTile extends StatefulWidget {
  final WorkoutExercise exercise;

  const ExerciseTile({Key? key, required this.exercise}) : super(key: key);

  @override
  _ExerciseTileState createState() => _ExerciseTileState();
}

class _ExerciseTileState extends State<ExerciseTile>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  final TextEditingController _repsController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller and animation
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic, // iOS-like curve
    );
  }

  @override
  void dispose() {
    _repsController.dispose();
    _weightController.dispose();
    _controller.dispose(); // Dispose the animation controller
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleExpanded,
      child: Column(
        children: [
          // The main tile
          Container(
            height: 70,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey5,
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
                      color: CupertinoColors.systemRed,
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
                            color: CupertinoColors.black,
                          ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    if (widget.exercise.sets != null &&
                        widget.exercise.sets!.isNotEmpty)
                      Text(
                        '${widget.exercise.sets!.length} sets',
                        style: CupertinoTheme.of(context)
                            .textTheme
                            .textStyle
                            .copyWith(
                              color: CupertinoColors.systemGrey,
                            ),
                      ),
                    const SizedBox(width: 8),
                    Icon(
                      _isExpanded
                          ? CupertinoIcons.chevron_down
                          : CupertinoIcons.chevron_forward,
                      color: CupertinoColors.systemGrey,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Animated expansion
          SizeTransition(
            sizeFactor: _animation,
            axisAlignment: -1.0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display list of sets
                  if (widget.exercise.sets != null &&
                      widget.exercise.sets!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sets:',
                          style: CupertinoTheme.of(context)
                              .textTheme
                              .textStyle
                              .copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Column(
                          children: widget.exercise.sets!.map((set) {
                            int index =
                                widget.exercise.sets!.indexOf(set) + 1;
                            return Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Set $index: ${set.reps} reps x ${set.weight} kg',
                                  style: CupertinoTheme.of(context)
                                      .textTheme
                                      .textStyle,
                                ),
                                CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  child: Icon(
                                    CupertinoIcons.delete,
                                    color: CupertinoColors.destructiveRed,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      widget.exercise.sets!.remove(set);
                                    });
                                  },
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  // Input fields
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
                              widget.exercise.sets ??= [];
                              widget.exercise.sets!.add(ExerciseSet(
                                  reps: reps, weight: weight));
                              _repsController.clear();
                              _weightController.clear();
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

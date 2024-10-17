import 'package:flutter/cupertino.dart';
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../widgets/add_exercise_surface_bottom.dart';
import '../widgets/add_exercise_surface_popup.dart';
import '../widgets/exercise_tile.dart';
import '../../models/exercise.dart';
import '../../models/workout.dart';
import '../../blocs/workout_bloc/workout_bloc.dart';
import '../../blocs/workout_bloc/workout_event.dart';
import '../../blocs/workout_bloc/workout_state.dart';
import '../../style/style.dart';
import '../../utils/utils.dart';

class TrainingProcess extends StatefulWidget {
  const TrainingProcess({super.key});

  @override
  State<TrainingProcess> createState() => _TrainingProcessState();
}

class _TrainingProcessState extends State<TrainingProcess> {
  final List<Exercise> _exercises = [];
  late Timer _timer;
  final Stopwatch _stopwatch = Stopwatch();

  @override // Starts timer when builds the page
  void initState() {
    super.initState();
    _startStopwatch();
  }

  @override // Disposes timer when page is disposed
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startStopwatch() {
    _stopwatch.start();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  // Function to add exercise to the list
  void _addExercise(Exercise exercise) {
    setState(() {
      _exercises.add(exercise);
    });
  }

  void _saveWorkout() {
    String workoutName = 'Workout ${DateTime.now().toLocal().toString()}';

    var uuid = const Uuid();
    int workoutId = uuid.v1().hashCode;

    Workout newWorkout = Workout(
        id: workoutId,
        name: workoutName,
        date: DateTime.now(),
        exerciseIds: _exercises.map((exercise) => exercise.id).toList(),
        duration: _stopwatch.elapsed);

    context.read<WorkoutBloc>().add(AddWorkoutEvent(newWorkout));
  }

  void _saveWorkoutButtonEvent() async {
    if (_exercises.isEmpty) {
      showDialog(
        context: context,
        title: 'No Exercises',
        content: 'Please add at least one exercise to save the workout.',
        barrierDismissible: true,
      );
      return;
    }

    // Show confirmation dialog before saving
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Are you done?'),
          content: const Text('Do you want to stop training?'),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _saveWorkout(); // Proceed to save the workout
              },
              child: const Text('Yes'),
            ),
            CupertinoDialogAction(
              isDestructiveAction: false,
              onPressed: () => Navigator.of(context).pop(), // Cancel
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _leaveButtonEvent() {
    // Only triggers when user trying to leave with added exercises
    showDialog(
      context: context,
      title: 'Discard Workout?',
      content: 'You have added exercises. Would you like to discard them?',
      barrierDismissible: true,
      actions: [
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () {
            Navigator.pop(context); // Close "Discard Workout?" dialog
            Navigator.pop(context); // Leave page
          },
          child: const Text('Discard'),
        ),
        CupertinoDialogAction(
          onPressed: () {
            Navigator.pop(context); // Close "Discard Workout?" dialog
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WorkoutBloc, WorkoutState>(
        listener: (context, state) {
          if (state is WorkoutAddedState) {
            showDialog(
              context: context,
              title: "Workout Saved",
              content:
                  'Your workout "${state.workout.name}" has been saved successfully.',
              actions: [
                CupertinoDialogAction(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Leave page
                  },
                ),
              ],
            );
          } else if (state is WorkoutErrorState) {
            showDialog(
              context: context,
              title: "Error",
              content: 'Failed to save the workout. Please try again.',
            );
          }
        },
        child: PopScope(
          // Used only if we leave with added exercises
          canPop: _exercises.isEmpty,
          onPopInvokedWithResult: (bool didPop, dynamic result) {
            if (!didPop) {
              _leaveButtonEvent();
              return;
            }
          },
          child: CupertinoPageScaffold(
            navigationBar: _buildNavigationBar(),
            child: SafeArea(
              child: Column(
                children: [
                  _buildTitleSection(exercises: _exercises),
                  Flexible(
                    flex: 4,
                    child: _buildExerciseListSection(exercises: _exercises),
                  ),
                  Flexible(
                    flex: 1,
                    child: _buildAddExerciseSection(
                      stopWatch: _stopwatch,
                      addExercise: _addExercise,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  CupertinoNavigationBar _buildNavigationBar() {
    return CupertinoNavigationBar(
      previousPageTitle: "Back",
      middle: const Text('Workout Plan!'),
      trailing: CupertinoButton(
        padding: const EdgeInsets.all(10),
        child: const Icon(
          CupertinoIcons.check_mark_circled,
        ),
        onPressed: () {
          _saveWorkoutButtonEvent();
        },
      ),
    );
  }
}

// **
// SHIT CODE HAPPENS HERE
// IT IS KINDA UNGROUPING THE WIDGETS
// SHOULD BE ORGANISED BETTER
// **
class _buildTitleSection extends StatelessWidget {
  const _buildTitleSection({
    super.key,
    required List<Exercise> exercises,
  }) : _exercises = exercises;

  final List<Exercise> _exercises;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      alignment: Alignment.centerLeft,
      child: Text(
        _exercises.isEmpty ? "No exercises" : "Your exercises",
        style: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle,
      ),
    );
  }
}

class _buildExerciseListSection extends StatelessWidget {
  const _buildExerciseListSection({
    super.key,
    required List<Exercise> exercises,
  }) : _exercises = exercises;

  final List<Exercise> _exercises;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BackgroundStyles.gradientDecoration(context),
      child: CupertinoScrollbar(
        child: ListView.builder(
          itemCount: _exercises.length,
          itemBuilder: (context, index) {
            return ExerciseTile(
              title: _exercises[index].name,
              onTap: () {},
            );
          },
        ),
      ),
    );
  }
}

Widget _buildAddExerciseSection({
  required addExercise,
  required stopWatch,
}) {
  return AddExerciseSurfaceBottom(
    stopwatch: stopWatch,
    popUpSurface: AddExercisePopup(
      onExerciseSelected: addExercise, // Pass the callback function
    ),
  );
}

import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import "/models/advanced_exercise_model/workout_exercise.dart";
import 'package:uuid/uuid.dart';

import '/models/basic_exercise_model/exercise.dart';
import '/models/workout_model/workout.dart';
import '/blocs/workout_bloc/workout_bloc.dart';
import '/blocs/workout_bloc/workout_event.dart';
import '/blocs/workout_bloc/workout_state.dart';
import '/utils/utils.dart';
import '../widgets/add_exercise_surface_bottom.dart';
import '../widgets/add_exercise_surface_popup.dart';
import '../widgets/exercise_tile.dart';

class TrainingProcess extends StatefulWidget {
  const TrainingProcess({super.key});

  @override
  State<TrainingProcess> createState() => _TrainingProcessState();
}

class _TrainingProcessState extends State<TrainingProcess> {
  final List<WorkoutExercise> _exercises = [];
  late Timer _timer;
  final Stopwatch _stopwatch = Stopwatch();

  @override
  void initState() {
    super.initState();
    _startStopwatch();
  }

  @override
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

  void _addExercise(Exercise exercise) {
    setState(() {
      _exercises.add(WorkoutExercise(
        exerciseName: exercise.name,
      ));
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
      exercises: [], // TODO: Add exercises
      duration: _stopwatch.elapsed,
    );

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
    showCupertinoDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Are you done?'),
          content: const Text('Do you want to stop training?'),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.of(context).pop();
                _saveWorkout();
              },
              child: const Text('Yes'),
            ),
            CupertinoDialogAction(
              isDestructiveAction: false,
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _leaveButtonEvent() {
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
    const double bottomWidgetHeight = 150.0;

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
          resizeToAvoidBottomInset: false, // Forbid keyboard shifting widgets
          child: SafeArea(
            bottom: false,
            child: GestureDetector(
              // Dismiss keyboard when tapping outside
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: _buildBlurringOverlay(
                slivers: [
                  _buildSliverNavigationBar(hasExercises: _exercises.isNotEmpty),
                  _buildSliverExerciseListSection(exercises: _exercises),
                ],
                unscrollableWidget: AddExerciseSurfaceBottom(
                  popUpSurface: AddExercisePopup(
                    onExerciseSelected: _addExercise,
                  ),
                  stopwatch: _stopwatch,
                ),
                unscrollableWidgetHeight: bottomWidgetHeight,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // When scrollable items go below unscrollable widget, blurring effect is applied
  Widget _buildBlurringOverlay({
    required List<Widget> slivers,
    required Widget unscrollableWidget,
    required double unscrollableWidgetHeight,
  }) {
    // Takes slivers and compensates for the height of unscrollable widget
    CustomScrollView customScrollView = CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: slivers +
          [
            SliverPadding(
              padding: EdgeInsets.only(
                bottom: unscrollableWidgetHeight,
              ),
            ),
          ],
    );

    return Stack(
      children: [
        customScrollView,
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
              child: Container(
                height: unscrollableWidgetHeight,
                color: CupertinoColors.white.withOpacity(0.2),
                child: unscrollableWidget,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildSliverNavigationBar({required bool hasExercises}) {
    return CupertinoSliverNavigationBar(
      stretch: true,
      border: null,
      backgroundColor: CupertinoColors.white,
      largeTitle: Text(
        hasExercises ? 'Your Exercises' : 'No exercises',
      ),
      trailing: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: _saveWorkoutButtonEvent,
        child: const Icon(
          CupertinoIcons.check_mark_circled,
        ),
      ),
    );
  }

  Widget _buildSliverExerciseListSection(
      {required List<WorkoutExercise> exercises}) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return ExerciseTile(
            exercise: exercises[index],
          );
        },
        childCount: exercises.length,
      ),
    );
  }
}

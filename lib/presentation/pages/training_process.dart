import 'package:flutter/cupertino.dart';

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

class TrainingProcess extends StatefulWidget {
  const TrainingProcess({super.key});

  @override
  State<TrainingProcess> createState() => _TrainingProcessState();
}

class _TrainingProcessState extends State<TrainingProcess> {
  final List<Exercise> _exercises = [];

  // Function to add exercise to the list
  void _addExercise(Exercise exercise) {
    setState(() {
      _exercises.add(exercise);
    });
  }

  // Helper method. Might go into a separate file
  void _showDialog(
      {required String title, required String content, List<Widget>? actions}) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: actions ??
            [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
      ),
    );
  }

  // Saves workout and returns workout name.
  void _saveWorkout() {
    // Create a Workout object with the list of exercises
    String workoutName = 'Workout ${DateTime.now().toLocal().toString()}';

    // Generate a unique ID for the workout
    var uuid = const Uuid();
    int workoutId = uuid.v1().hashCode;

    // Create a workout object
    Workout newWorkout = Workout(
        id: workoutId,
        name: workoutName,
        date: DateTime.now(),
        exerciseIds: _exercises.map((exercise) => exercise.id).toList(),
        duration: const Duration(hours: 1) // TODO: !
        );

    context.read<WorkoutBloc>().add(AddWorkoutEvent(newWorkout));
  }

  void _saveWorkoutButtonEvent() async {
    if (_exercises.isEmpty) {
      _showDialog(
        title: 'No Exercises',
        content: 'Please add at least one exercise to save the workout.',
      );
      return;
    }
    _saveWorkout();
  }

  void _leaveButtonEvent() {
    // Only triggers when user trying to leave with added exercises
    _showDialog(
        title: 'Save Workout?',
        content:
            'You have added exercises. Would you like to discard them?',
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context); // Close "Save Workout?" dialog
              Navigator.pop(context); // Leave page
            },
            child: const Text('Discard'),
          ),
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context); // Leave page
            },
            child: const Text('Cancel'),
          ),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WorkoutBloc, WorkoutState>(
        listener: (context, state) {
          if (state is WorkoutAddedState) {
            _showDialog(
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
            _showDialog(
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
                    child: _buildAddExerciseSection(addExercise: _addExercise),
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

Widget _buildAddExerciseSection({required addExercise}) {
  return AddExerciseSurfaceBottom(
    popUpSurface: AddExercisePopup(
      onExerciseSelected: addExercise, // Pass the callback function
    ),
  );
}

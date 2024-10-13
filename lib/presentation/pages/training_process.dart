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

  void _saveWorkout() async {
    if (_exercises.isEmpty) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('No Exercises'),
          content:
              const Text('Please add at least one exercise to save the workout.'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
      return;
    }
    // Create a Workout object with the list of exercises
    String workoutName = 'Workout ${DateTime.now().toIso8601String()}';

    // Generate a unique ID for the workout
    var uuid = const Uuid();
    int workoutId = uuid.v1().hashCode;

    // Create a workout object
    Workout newWorkout = Workout(
      id: workoutId,
      name: workoutName,
      date: DateTime.now(),
      exerciseIds: _exercises.map((exercise) => exercise.id).toList(),
      duration: Duration(hours: 1) // TODO: GET TIME FROM STOPWATCH
    );

    try {
      // Send AddWorkoutEvent to the bloc
      context.read<WorkoutBloc>().add(AddWorkoutEvent(newWorkout));

      // Provide user feedback
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Workout Saved'),
          content:
              Text('Your workout "$workoutName" has been saved successfully.'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => {Navigator.pop(context), Navigator.pop(context)},
            ),
          ],
        ),
      );
    } catch (e) {
      // Handle errors gracefully
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Error'),
          content: const Text('Failed to save the workout. Please try again.'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
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
    );
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
          setState(() {
            _saveWorkout();
          });
        },
      ),
    );
  }
}

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
              onTap: () {
                // TODO: DELETE THTAT SHIT
              },
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

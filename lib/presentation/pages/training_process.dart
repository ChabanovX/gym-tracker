import 'package:flutter/cupertino.dart';

import '../widgets/add_exercise_surface_bottom.dart';
import '../widgets/add_exercise_surface_popup.dart';
import '../widgets/exercise_tile.dart';
import '../../models/exercise.dart';
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
            _exercises.add(Exercise(name: "Squat", sets: 3, reps: 10));
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
                print(_exercises[index].name);
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

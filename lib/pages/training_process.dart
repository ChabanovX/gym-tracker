import 'package:flutter/cupertino.dart';

import '../widgets/add_exercise_surface_bottom.dart';
import '../widgets/add_exercise_surface_popup.dart';
import '../widgets/exercise_tile.dart';

import '../models/exercise.dart';

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
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: "Back",
        middle: const Text('Workout Plan'),
        trailing: CupertinoButton(
          padding: const EdgeInsets.all(10),
          child: const Icon(
            CupertinoIcons.check_mark_circled,
          ),
          onPressed: () {
            setState(() {
              _exercises.add(
                const Exercise(
                  name: "Curl",
                  sets: 3,
                  reps: 12,
                ),
              );
            });
          },
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              height: 50,
              alignment: Alignment.centerLeft,
              child: Text(
                _exercises.isEmpty ? "No exercises" : "Your exercises",
                style: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle,
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      CupertinoTheme.of(context).primaryContrastingColor,
                      CupertinoColors.lightBackgroundGray,
                    ],
                  ),
                ),
                height: 550,
                child: CupertinoScrollbar(
                  child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(
                        _exercises.length,
                        (index) {
                          return ExerciseTile(
                            title: _exercises[index].name,
                            onTap: () {
                              print(_exercises[index].name);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            AddExerciseSurfaceBottom(
              popUpSurface: AddExercisePopup(
                onExerciseSelected: _addExercise,  // Pass the callback function
              ),
            ),
          ],
        ),
      ),
    );
  }
}

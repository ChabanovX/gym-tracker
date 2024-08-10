import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/add_exercise_surface.dart';
import '../widgets/exercise_tile.dart';
import '../models/exercise.dart';

class TrainingProcess extends StatefulWidget {
  const TrainingProcess({super.key});

  @override
  State<TrainingProcess> createState() => _TrainingProcessState();
}

class _TrainingProcessState extends State<TrainingProcess> {
  List<Exercise> _exercises = [
    // const Exercise(
    //   name: "Bench Press",
    //   sets: 3,
    //   reps: 12,
    // ),
    // const Exercise(
    //   name: "Deadlift",
    //   sets: 5,
    //   reps: 6,
    // ),
    // const Exercise(
    //   name: "Squat",
    //   sets: 3,
    //   reps: 12,
    // ),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: "Back",
        middle: const Text('Bitch Ass Nigga'),
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
                style: CupertinoTheme.of(context)
                    .textTheme
                    .navLargeTitleTextStyle
                    .copyWith(
                        // fontSize: 14,
                        ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Container(
                color: CupertinoTheme.of(context).primaryContrastingColor,
                height: 400,
                child: CupertinoScrollbar(
                  child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(
                        _exercises.length,
                        (index) {
                          return ExerciseTile(
                            title: _exercises[index].name,
                            onTap: () {
                              print("${_exercises[index].name}");
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              child: Center(
                child: CupertinoButton.filled(
                  child: const Text('Add Exercise'),
                  onPressed: () => {
                    showCupertinoModalPopup(
                      context: context,
                      builder: (BuildContext context) => const AddExercise(),
                    ),
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

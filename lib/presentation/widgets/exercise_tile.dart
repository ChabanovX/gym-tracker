import 'package:flutter/cupertino.dart';
import 'package:gymgym/models/exercise_set.dart';
import 'package:gymgym/models/workout_exercise.dart';

class ExerciseTile extends StatelessWidget {
  final WorkoutExercise exercise;

  const ExerciseTile({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        exercise.setSets([
          ExerciseSet(
            reps: 1,
            weight: 1,
          )
        ]);
        print(
          "Added sets for ${exercise.exerciseName}: ${exercise.sets![0].weight}kg x ${exercise.sets![0].reps} reps",
        );
      },
      child: Container(
        height: 70,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: CupertinoTheme.of(context).primaryColor,
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
                  exercise.exerciseName,
                  style:
                      CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: CupertinoColors.white,
                          ),
                ),
              ],
            ),
            Icon(
              CupertinoIcons.forward,
              color: CupertinoTheme.of(context).primaryContrastingColor,
            ),
          ],
        ),
      ),
    );
  }
}

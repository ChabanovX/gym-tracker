import 'package:flutter/cupertino.dart';

import 'stopwatch.dart';

class AddExerciseSurfaceBottom extends StatelessWidget {
  final Widget popUpSurface;
  final Stopwatch stopwatch;

  const AddExerciseSurfaceBottom({
    super.key,
    required this.popUpSurface,
    required this.stopwatch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 50),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: StopwatchWidget(
                stopwatch: stopwatch,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: CupertinoButton(
                child: const Icon(
                  CupertinoIcons.add_circled,
                  size: 64,
                ),
                onPressed: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (BuildContext context) => popUpSurface,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

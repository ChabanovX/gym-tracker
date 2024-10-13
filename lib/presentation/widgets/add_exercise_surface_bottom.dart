import 'package:flutter/cupertino.dart';

import 'stopwatch.dart';

class AddExerciseSurfaceBottom extends StatelessWidget {
  final Widget popUpSurface;
  const AddExerciseSurfaceBottom({super.key, required this.popUpSurface});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Center(
            child: StopwatchPage(),
          ),
        ), // Bottom-left area
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
        ), // Bottom-right area with button in the center
      ],
    );
  }
}

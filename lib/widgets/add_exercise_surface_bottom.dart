import 'package:flutter/cupertino.dart';

class AddExerciseSurfaceBottom extends StatelessWidget {
  final Widget popUpSurface;
  const AddExerciseSurfaceBottom({super.key, required this.popUpSurface});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      "00:00:00",
                      style: CupertinoTheme.of(context)
                          .textTheme
                          .dateTimePickerTextStyle,
                    ),
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
            ),
          ),
        ],
      ),
    );
  }
}
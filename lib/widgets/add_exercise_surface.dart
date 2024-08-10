import 'package:flutter/cupertino.dart';

class AddExercise extends StatelessWidget {
  const AddExercise({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPopupSurface(
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        // height: 750,
        height: 400,
        child: CupertinoButton(
          child: Text("Close"),
          onPressed: () {
            Navigator.of(context).pop("close");
          },
        ),
      ),
    );
  }
}

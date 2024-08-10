import 'package:flutter/cupertino.dart';

import 'training_process.dart';

class TrainPage extends StatelessWidget {
  const TrainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Stop training like a pussy!",
            style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
          ),
          const SizedBox(height: 30),
          Center(
            child: CupertinoButton.filled(
              onPressed: () => {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const TrainingProcess(),
                  ),
                )
              },
              child: const Text("Create a new Train"),
            ),
          ),
        ],
      ),
    );
  }
}

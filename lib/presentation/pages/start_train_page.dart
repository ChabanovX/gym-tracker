import 'package:flutter/cupertino.dart';
import 'training_process.dart';

import '../../style/style.dart';

class TrainPage extends StatelessWidget {
  const TrainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Container(
        decoration: BackgroundStyles.gradientDecoration(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: CupertinoButton(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                onPressed: () => {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const TrainingProcess(),
                    ),
                  )
                },
                color: CupertinoTheme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(20),
                child: const Text(
                  "Start Training",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'training_process.dart';

class TrainPage extends StatelessWidget {
  const TrainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Container(
        // decoration: BackgroundStyles.gradientDecoration(context),
        child: Column(
          children: [
            const Expanded(
              child: Row(
                children: [],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => const TrainingProcess(),
                              ),
                            )
                          },
                          child: Column(
                            children: [
                              const Icon(
                                size: 100,
                                CupertinoIcons.flame_fill,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "START",
                                style: CupertinoTheme.of(context)
                                    .textTheme
                                    .navLargeTitleTextStyle
                                    .copyWith(
                                      fontSize: 15,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'training_process.dart';

import '../../style/style.dart';

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
                          child: const Icon(
                            size: 100,
                            CupertinoIcons.flame_fill,
                          ),
                        ),
                        // const SizedBox(height: 5),
                        // Text(
                        //   "start training",
                        //   style: CupertinoTheme.of(context)
                        //       .textTheme
                        //       .tabLabelTextStyle.copyWith(
                        //         fontSize: 15,
                        //       ),
                        // ),
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

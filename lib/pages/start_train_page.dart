import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'training_process.dart';

class TrainPage extends StatelessWidget {
  const TrainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Container(
        // Adding a subtle gradient background
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              CupertinoColors.systemBackground,
              CupertinoColors.lightBackgroundGray
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Text(
                "Hello, Ivan! 💪",
                style: CupertinoTheme.of(context)
                    .textTheme
                    .navLargeTitleTextStyle
                    .copyWith(
                      fontSize: 28, // Increase font size for more emphasis
                      fontWeight: FontWeight.bold, // Make text bold
                    ),
              ),
            ),
            const SizedBox(
                height:
                    40), // Added more space between the greeting and the button
            Center(
              child: CupertinoButton(
                padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15), // Increased padding for larger button
                onPressed: () => {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const TrainingProcess(),
                    ),
                  )
                },
                color: CupertinoColors
                    .systemPink, // Changed button color to pink for better contrast
                borderRadius: BorderRadius.circular(
                    20), // Rounded corners for modern look
                child: const Text(
                  "Create a new Train",
                  style: TextStyle(
                    fontSize: 18, // Increased text size for the button
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

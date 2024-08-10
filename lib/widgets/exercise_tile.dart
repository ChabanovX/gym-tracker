import 'package:flutter/cupertino.dart';

// Define your custom tile widget
class ExerciseTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  ExerciseTile({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: CupertinoTheme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const Icon(
              CupertinoIcons.forward,
              color: CupertinoColors.systemGrey6,
            ),
          ],
        ),
      ),
    );
  }
}
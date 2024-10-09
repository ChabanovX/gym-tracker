import 'package:flutter/cupertino.dart';

class ExerciseTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const ExerciseTile({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: CupertinoTheme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: Offset(0, 3), // Shadow below the tile
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // Adding an icon on the left side of the exercise name
                Icon(
                  CupertinoIcons.flame_fill, // Example icon, can be replaced
                  color: CupertinoColors.white,
                ),
                const SizedBox(width: 12), // Space between icon and text
                Text(
                  title,
                  style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: CupertinoColors.white,
                      ),
                ),
              ],
            ),
            Icon(
              CupertinoIcons.forward,
              color: CupertinoTheme.of(context).primaryContrastingColor,
            ),
          ],
        ),
      ),
    );
  }
}

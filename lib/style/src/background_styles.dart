import 'package:flutter/cupertino.dart';

abstract class BackgroundStyles {
  static BoxDecoration gradientDecoration(BuildContext context) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          CupertinoTheme.of(context).primaryContrastingColor,
          CupertinoColors.lightBackgroundGray
        ],
      ),
    );
  }

  static BoxDecoration gradientDecorationReversed(BuildContext context) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          CupertinoColors.lightBackgroundGray,
          CupertinoTheme.of(context).primaryContrastingColor
        ],
      ),
    );
  }
}

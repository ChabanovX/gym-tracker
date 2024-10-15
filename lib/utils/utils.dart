import 'package:flutter/cupertino.dart';

void showDialog(
    {required BuildContext context,
    required String title,
    required String content,
    List<Widget>? actions,
    bool barrierDismissible = false}) {
  showCupertinoDialog(
    barrierDismissible: barrierDismissible,
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: actions ??
          [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
    ),
  );
}

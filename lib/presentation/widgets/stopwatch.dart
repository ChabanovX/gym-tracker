import 'package:flutter/cupertino.dart';

class StopwatchWidget extends StatelessWidget {
  final Stopwatch stopwatch;

  const StopwatchWidget({super.key, required this.stopwatch});

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatDuration(stopwatch.elapsed),
      style: CupertinoTheme.of(context).textTheme.dateTimePickerTextStyle,
    );
  }
}

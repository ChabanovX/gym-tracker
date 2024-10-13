import 'dart:async';
import 'package:flutter/cupertino.dart';

class StopwatchPage extends StatefulWidget {
  @override
  _StopwatchPageState createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  late Timer _timer;
  final Stopwatch _stopwatch = Stopwatch();

  @override
  void initState() {
    super.initState();
    _startStopwatch(); // Start the stopwatch when the page is loaded.
  }

  @override
  void dispose() {
    _timer
        .cancel(); // Cancel the timer when the page is disposed to avoid memory leaks.
    super.dispose();
  }

  void _startStopwatch() {
    _stopwatch.start();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

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
      _formatDuration(_stopwatch.elapsed),
      style: CupertinoTheme.of(context).textTheme.dateTimePickerTextStyle,
    );
  }
}

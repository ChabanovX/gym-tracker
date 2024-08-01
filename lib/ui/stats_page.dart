import 'package:flutter/cupertino.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      child: Center(
        child: Text('See Statistics'),
      ),
    );
  }
}

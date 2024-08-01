import 'package:flutter/cupertino.dart';

import 'ui/stats_page.dart';
import 'ui/train_page.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      home: RootPage(),
    );
  }
}

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.add),
            label: "Train",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.eye),
            label: "Statistics",
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return <Widget>[
          TrainPage(),
          StatsPage(),
        ][index];
      },
    );
  }
}

void main() {
  runApp(const MainApp());
}

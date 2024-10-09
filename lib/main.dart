import 'package:flutter/cupertino.dart';

import 'pages/stats_page.dart';
import 'pages/start_train_page.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      theme: CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: CupertinoColors.systemPink,
      ),
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
            icon: Icon(CupertinoIcons.flame),
            label: "Train!",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.calendar_today),
            label: "Statistics",
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return <Widget>[
          TrainPage(),
          StatisticsPage(),
        ][index];
      },
    );
  }
}

void main() {
  runApp(const MainApp());
}

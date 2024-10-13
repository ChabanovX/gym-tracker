import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/workout_bloc/workout_bloc.dart';
import 'blocs/workout_bloc/workout_event.dart';
import 'services/dependency_injection.dart';

import 'presentation/pages/stats_page.dart';
import 'presentation/pages/start_train_page.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<WorkoutBloc>()..add(LoadWorkoutsEvent()),
      child: const CupertinoApp(
        debugShowCheckedModeBanner: false,
        theme: CupertinoThemeData(
          brightness: Brightness.light,
          primaryColor: CupertinoColors.systemPink,
        ),
        home: RootPage(),
      ),
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
  runApp(
    MainApp(),
  );
}

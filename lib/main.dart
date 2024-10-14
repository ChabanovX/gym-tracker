import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymgym/models/duration_adapter.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'blocs/workout_bloc/workout_bloc.dart';
import 'blocs/workout_bloc/workout_event.dart';
import 'services/dependency_injection.dart';
import 'models/workout.dart';

import 'presentation/pages/stats_page.dart';
import 'presentation/pages/start_train_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(WorkoutAdapter());
  Hive.registerAdapter(DurationAdapter());

  // Open Hive boxes
  await Hive.openBox<Workout>('workouts');

  // Set up dependencies injection
  setUpDependencies();

  // TODO: DELETE
  // import '../repositories/workout_repository.dart';
  // var exercises = await getIt<WorkoutRepository>().getAllWorkouts();
  // print(exercises[0].exerciseIds);

  runApp(const MainApp());
}

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

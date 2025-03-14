import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_me/blocs/exercise_service_bloc/exercise_service_event.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/adapter_models/duration_adapter.dart';
import 'models/workout_model/workout.dart';
import 'models/advanced_exercise_model/workout_exercise.dart';
import 'models/exercise_set_model/exercise_set.dart';
import 'blocs/workout_bloc/workout_bloc.dart';
import 'blocs/workout_bloc/workout_event.dart';
import 'blocs/exercise_service_bloc/exercise_service_bloc.dart';
import 'services/dependency_injection.dart';
import 'presentation/pages/stats_page.dart';
import 'presentation/pages/start_train_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(WorkoutAdapter());
  Hive.registerAdapter(WorkoutExerciseAdapter());
  Hive.registerAdapter(ExerciseSetAdapter());
  Hive.registerAdapter(DurationAdapter());

  await Hive.openBox<Workout>('workouts');

  await setUpDependencies();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<WorkoutBloc>()..add(LoadWorkoutsEvent()),
        ),
        BlocProvider(
          create: (_) => getIt<ExerciseServiceBloc>()..add(GetExercisesEvent(fetchType: ExerciseFetchType.all)),
        ),
      ],
      child: const CupertinoApp(
        debugShowCheckedModeBanner: false,
        theme: CupertinoThemeData(
          // brightness: Brightness.light,
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
          const TrainPage(),
          const StatisticsPage(),
        ][index];
      },
    );
  }
}

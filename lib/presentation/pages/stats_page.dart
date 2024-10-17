import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/workout_bloc/workout_bloc.dart';
import '../../blocs/workout_bloc/workout_state.dart';
import '../../blocs/workout_bloc/workout_event.dart';


class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutBloc, WorkoutState>(
      builder: (context, state) {

        int totalWorkouts = 0;
        String totalTimeSpent = '0h 0m'; // Placeholder

        if (state is WorkoutLoadingState) {
          return CupertinoPageScaffold(
            navigationBar: _buildNavigationBar(context),
            child: const Center(child: CupertinoActivityIndicator()),
          );

        } else if (state is WorkoutLoadedState) {
          // Example of usage
          totalWorkouts = state.workouts.length;
          totalTimeSpent = state.workouts.fold<int>(
                  0, (sum, workout) => sum + (workout.duration.inMinutes))
              .let((totalMinutes) =>
                  '${(totalMinutes ~/ 60)}h ${(totalMinutes % 60)}m');

        } else if (state is WorkoutErrorState) {
          return CupertinoPageScaffold(
            navigationBar: _buildNavigationBar(context),
            child: Center(
              child: Text(
                state.message,
                style: const TextStyle(color: CupertinoColors.systemRed),
              ),
            ),
          );
        }

        return CupertinoPageScaffold(
          navigationBar: _buildNavigationBar(context),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary Section
                  Text(
                    'Workout Summary',
                    style: CupertinoTheme.of(context)
                        .textTheme
                        .navTitleTextStyle,
                  ),
                  const SizedBox(height: 10),
                  _buildSummaryTile(
                    title: 'Total Workouts',
                    value: '$totalWorkouts',
                    icon: CupertinoIcons.flame_fill,
                    color: CupertinoColors.systemPink,
                  ),
                  _buildSummaryTile(
                    title: 'Total Time Spent',
                    value: totalTimeSpent,
                    icon: CupertinoIcons.timer_fill,
                    color: CupertinoColors.systemPink,
                  ),
                  const SizedBox(height: 20),

                  // Charts Section
                  Text(
                    'Performance Trends',
                    style: CupertinoTheme.of(context)
                        .textTheme
                        .navTitleTextStyle,
                  ),
                  const SizedBox(height: 10),
                  _buildPlaceholderChart('Weekly Workouts'), // Placeholder for chart
                  _buildPlaceholderChart('Weight Progression'), // Another placeholder chart
                  const SizedBox(height: 20),

                  // Personal Bests Section
                  Text(
                    'Personal Bests',
                    style: CupertinoTheme.of(context)
                        .textTheme
                        .navTitleTextStyle,
                  ),
                  const SizedBox(height: 10),
                  _buildPersonalBestTile(
                    title: 'Heaviest Bench Press',
                    value: '220 lbs',
                  ),
                  _buildPersonalBestTile(
                    title: 'Longest Workout',
                    value: '1h 45m',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  CupertinoNavigationBar _buildNavigationBar(BuildContext context) {
    return const CupertinoNavigationBar(
      previousPageTitle: "Back",
      middle: Text('Statistics'),
    );
  }

  // Helper method to build summary tiles
  Widget _buildSummaryTile({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Placeholder for charts (can be replaced with actual chart widgets)
  Widget _buildPlaceholderChart(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          '$title Chart',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: CupertinoColors.systemGrey2,
          ),
        ),
      ),
    );
  }

  // Personal best tile
  Widget _buildPersonalBestTile({
    required String title,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.activeBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

extension Let<T> on T {
  R let<R>(R Function(T it) op) => op(this);
}

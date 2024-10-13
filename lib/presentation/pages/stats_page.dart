import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import Bloc
import '../../blocs/workout_bloc/workout_bloc.dart'; // Adjust the path as needed
import '../../blocs/workout_bloc/workout_state.dart'; // Adjust the path as needed

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutBloc, WorkoutState>(
      builder: (context, state) {
        // Initialize variables to hold dynamic data
        int totalWorkouts = 0;
        String totalTimeSpent = '0h 0m'; // Placeholder
        // You can add more dynamic variables here as needed

        // Check the current state and extract data accordingly
        if (state is WorkoutLoadingState) {
          // While loading, show a loading indicator
          return CupertinoPageScaffold(
            navigationBar: _buildNavigationBar(),
            child: Center(child: CupertinoActivityIndicator()),
          );
        } else if (state is WorkoutLoadedState) {
          // Extract total workouts
          totalWorkouts = state.workouts.length;

          // Example: Calculate total time spent based on workouts
          // This assumes each workout has a 'duration' field in minutes
          // Modify according to your actual data structure
          totalTimeSpent = state.workouts.fold<int>(
                  0, (sum, workout) => sum + (workout.duration ?? 0))
              .let((totalMinutes) =>
                  '${(totalMinutes ~/ 60)}h ${(totalMinutes % 60)}m');

          // You can add more calculations here for other statistics
        } else if (state is WorkoutErrorState) {
          // If there's an error, display an error message
          return CupertinoPageScaffold(
            navigationBar: _buildNavigationBar(),
            child: Center(
              child: Text(
                state.message,
                style: TextStyle(color: CupertinoColors.systemRed),
              ),
            ),
          );
        }

        // Once data is loaded, build the Statistics Page
        return CupertinoPageScaffold(
          navigationBar: _buildNavigationBar(),
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

  CupertinoNavigationBar _buildNavigationBar() {
    return CupertinoNavigationBar(
      previousPageTitle: "Back",
      middle: const Text('Statistics'),
      trailing: CupertinoButton(
        padding: const EdgeInsets.all(10),
        child: const Icon(
          CupertinoIcons.refresh,
        ),
        onPressed: () {
          // Optionally, you can trigger a reload of statistics
          context.read<WorkoutBloc>().add(LoadWorkoutsEvent());
        },
      ),
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

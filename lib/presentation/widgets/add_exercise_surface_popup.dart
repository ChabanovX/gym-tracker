import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/exercise.dart';

class AddExercisePopup extends StatelessWidget {
  final List<Map<String, String>> exercises = [
    {
      'imageUrl': 'https://media.istockphoto.com/id/1028273740/photo/man-during-bench-press-exercise.jpg?s=612x612&w=0&k=20&c=pTNDqP6UbgTm39u9GHFqDiH13o1cm1l4xYHBdoiSdkg=',
      'name': 'Bench Press'
    },
    {
      'imageUrl': 'https://images.ctfassets.net/3s5io6mnxfqz/34Npc5PKLKJi6HIYvFw9XI/3e45754912cf266e7401cb8074c63239/AdobeStock_386146138_2.jpeg',
      'name': 'Squat'
    },
    {
      'imageUrl': 'https://www.tuffwraps.com/cdn/shop/articles/lifter-doing-deadlift-on-back-day_1600x.png?v=1697076038',
      'name': 'Deadlift'
    },
    {
      "imageUrl": 'https://mirafit.co.uk/media/catalog/product/cache/19ca2e769d01002d3d55f921fa642213/B/i/Bicep-Curl-with-Mirafit-Olympic-Curl-Bar-and-30kg-Tri-Grip-Weight-Set.jpg',
      'name': 'Barbell Curl',
    },
    {
      'imageUrl': 'https://mirafit.co.uk/wp/wp-content/uploads/2024/03/seated-dumbbell-shoulder-press-with-Mirafit-Dumbbells-1024x683.jpg',
      'name': 'Shoulder Press',
    },
    {
      'imageUrl': 'https://media.istockphoto.com/id/1289416128/photo/fit-sporty-lady-exercising-with-hand-weights.jpg?s=612x612&w=0&k=20&c=aeGvHLo9PMlDXRjVls-3Wa34UCSDva6jn7HDZQTBPoQ=',
      'name': 'Lateral Raise',
    },
  ];

  // Add a callback to return the selected exercise
  final Function(Exercise) onExerciseSelected;

  AddExercisePopup({required this.onExerciseSelected, super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPopupSurface(
      isSurfacePainted: true,
      child: SafeArea(
        top: false,
        child: Container(
          height: 660,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CupertinoSearchTextField(
                  placeholder: 'Search exercises...',
                  onChanged: (text) {
                    // Implement search/filter functionality here if needed
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12.0,
                      mainAxisSpacing: 12.0,
                      childAspectRatio: 3 / 4,
                    ),
                    itemCount: exercises.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          // Create a new Exercise object and pass it to the callback
                          onExerciseSelected(
                            Exercise(
                              name: exercises[index]['name']!,
                              sets: 3, // You can customize the sets and reps
                              reps: 10,
                            ),
                          );
                          Navigator.pop(context);  // Close the popup after selection
                        },
                        child: GridTile(
                          footer: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: CupertinoColors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(8),
                              ),
                            ),
                            child: Text(
                              exercises[index]['name']!,
                              textAlign: TextAlign.center,
                              style: CupertinoTheme.of(context)
                                  .textTheme
                                  .navTitleTextStyle
                                  .copyWith(
                                    fontSize: 14,
                                    color: CupertinoColors.white,
                                  ),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              exercises[index]['imageUrl']!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Icon(
                                CupertinoIcons.exclamationmark_circle,
                                size: 40,
                                color: CupertinoColors.systemRed,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

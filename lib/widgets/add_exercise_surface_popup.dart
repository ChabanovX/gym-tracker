import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddExercisePopup extends StatelessWidget {
  // List of image URLs
  final List<String> imageUrls = [
    'https://media.istockphoto.com/id/1028273740/photo/man-during-bench-press-exercise.jpg?s=612x612&w=0&k=20&c=pTNDqP6UbgTm39u9GHFqDiH13o1cm1l4xYHBdoiSdkg=', // Example image URL 1
    'https://images.ctfassets.net/3s5io6mnxfqz/34Npc5PKLKJi6HIYvFw9XI/3e45754912cf266e7401cb8074c63239/AdobeStock_386146138_2.jpeg', // Example image URL 2
    'https://picsum.photos/210',
    'https://picsum.photos/230',
    'https://i1.sndcdn.com/artworks-qTy45fy7QuZsTjQt-8pB5NA-t1080x1080.jpg',
    'https://picsum.photos/250',
    'https://picsum.photos/270',
    'https://picsum.photos/277',
    'https://picsum.photos/273',
    'https://picsum.photos/377',
    'https://picsum.photos/237',
  ];

  AddExercisePopup({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPopupSurface(
      isSurfacePainted: true,
      child: SafeArea(
        child: Container(
          height: 660, // Height of the popup
          // height: 400,
          child: Column(
            children: [
              // Text("!@#"),
              // Text("!@#"),
              // Text("!@#"),
              // Text("!@#"),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // Number of columns
                      crossAxisSpacing: 8.0, // Space between columns
                      mainAxisSpacing: 8.0, // Space between rows
                    ),
                    itemCount: imageUrls.length,
                    itemBuilder: (context, index) {
                      return GridTile(
                        footer: Container(
                          decoration: BoxDecoration(
                            color: CupertinoTheme.of(context)
                                .primaryContrastingColor
                                .withOpacity(0.75),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          margin: EdgeInsets.all(8),
                          // color: CupertinoColors.systemBackground,
                          child: Center(
                            child: Text(
                              "Bench Press",
                              style: CupertinoTheme.of(context)
                                  .textTheme
                                  .navTitleTextStyle.copyWith(
                                    fontSize: 13,
                                  ),
                            ),
                          ),
                        ),
                        child: Image.network(
                          imageUrls[index],
                          fit: BoxFit.cover,
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

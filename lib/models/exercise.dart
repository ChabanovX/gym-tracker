class Exercise {
  final String name;
  final String description;
  final int id;
  final String category;
  final String imagePath;

  Exercise({
    required this.name,
    required this.description,
    required this.id,
    required this.category,
    required this.imagePath,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'],
      description: json['description'],
      id: json['id'],
      category: json['category'],
      imagePath: json['imagePath'],
    );
  }
}

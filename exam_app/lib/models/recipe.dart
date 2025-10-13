class Recipe {
  final int? id;
  final String name;
  final String category;
  final int prepTime;
  final int servings;
  final String ingredients;
  final String steps;
  final String? imagePath;
  final bool isFavorite;

  Recipe({
    this.id,
    required this.name,
    required this.category,
    required this.prepTime,
    required this.servings,
    required this.ingredients,
    required this.steps,
    this.imagePath,
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'prepTime': prepTime,
      'servings': servings,
      'ingredients': ingredients,
      'steps': steps,
      'imagePath': imagePath,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'],
      name: map['name'],
      category: map['category'],
      prepTime: map['prepTime'],
      servings: map['servings'],
      ingredients: map['ingredients'],
      steps: map['steps'],
      imagePath: map['imagePath'],
      isFavorite: map['isFavorite'] == 1,
    );
  }

  Recipe copyWith({
    int? id,
    String? name,
    String? category,
    int? prepTime,
    int? servings,
    String? ingredients,
    String? steps,
    String? imagePath,
    bool? isFavorite,
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      prepTime: prepTime ?? this.prepTime,
      servings: servings ?? this.servings,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      imagePath: imagePath ?? this.imagePath,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

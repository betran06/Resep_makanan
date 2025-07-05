import '../utils/category_enum.dart';

class Recipe {
  final int? id;
  final String title;
  final String description;
  final String image;
  final String ingredients;
  final CategoryType category;

  Recipe({
    this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.ingredients,
    required this.category,
  });

  // Konversi dari Map ke Recipe
  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      image: map['image'],
      ingredients: map['ingredients'],
      category: CategoryType.values[map['category']],
    );
  }

  // Konversi dari Recipe ke Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'ingredients':ingredients,
      'category': category.index,
    };
  }
}

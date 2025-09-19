// lib/data/models/recipe.dart
import 'category_enum.dart';

class Recipe {
  final int? id;
  final String title;
  final String description;
  final String image;
  final String ingredients; // disimpan sebagai teks; bisa di-split saat pakai
  final CategoryType category;

  const Recipe({
    this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.ingredients,
    required this.category,
  });

  /// Factory yang aman terhadap variasi tipe/isi map:
  /// - id bisa int / String
  /// - category bisa index (int/String) atau nama (String)
  factory Recipe.fromMap(Map<String, dynamic> map) {
    final dynamic idRaw = map['id'];
    final int? parsedId = switch (idRaw) {
      int v => v,
      String s => int.tryParse(s),
      _ => null,
    };

    final String safeTitle = (map['title'] ?? '').toString();
    final String safeDesc = (map['description'] ?? '').toString();
    final String safeImage = (map['image'] ?? '').toString();
    final String safeIngredients = (map['ingredients'] ?? '').toString();

    final CategoryType cat = _parseCategory(map['category']);

    return Recipe(
      id: parsedId,
      title: safeTitle,
      description: safeDesc,
      image: safeImage,
      ingredients: safeIngredients,
      category: cat,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'ingredients': ingredients,
      // simpan sebagai index agar kompatibel dengan implementasi DB yang ada
      'category': category.index,
    };
  }

  /// Alias JSON
  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe.fromMap(json);
  Map<String, dynamic> toJson() => toMap();

  /// Helper: buat salinan dengan perubahan sebagian field.
  Recipe copyWith({
    int? id,
    String? title,
    String? description,
    String? image,
    String? ingredients,
    CategoryType? category,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
      ingredients: ingredients ?? this.ingredients,
      category: category ?? this.category,
    );
  }

  /// Helper: pecah ingredients menjadi list (pisah koma atau baris).
  List<String> get ingredientsList {
    final txt = ingredients.trim();
    if (txt.isEmpty) return const [];
    // dukung pemisah newline ATAU koma
    final splitter = txt.contains('\n') ? '\n' : ',';
    return txt
        .split(splitter)
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList(growable: false);
  }

  /// Parser kategori yang fleksibel:
  /// - int: dianggap index enum
  /// - String angka: diparse ke int index
  /// - String nama: dicocokkan dengan nama enum (case-insensitive)
  static CategoryType _parseCategory(dynamic raw) {
    if (raw is int) {
      return _categoryFromIndex(raw);
    }
    if (raw is String) {
      // coba sebagai angka index lebih dulu
      final asInt = int.tryParse(raw);
      if (asInt != null) return _categoryFromIndex(asInt);

      // cocokkan nama enum (mis. "makanan", "minuman", "kue")
      final lower = raw.toLowerCase().trim();
      for (final ct in CategoryType.values) {
        if (ct.name.toLowerCase() == lower) {
          return ct;
        }
      }
    }
    // fallback aman: default ke kategori pertama (atau pilih yang kamu inginkan)
    return CategoryType.values.first;
  }

  static CategoryType _categoryFromIndex(int idx) {
    if (idx >= 0 && idx < CategoryType.values.length) {
      return CategoryType.values[idx];
    }
    return CategoryType.values.first;
  }

  @override
  String toString() =>
      'Recipe(id: $id, title: $title, category: ${category.name})';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Recipe &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.image == image &&
        other.ingredients == ingredients &&
        other.category == category;
  }

  @override
  int get hashCode =>
      Object.hash(id, title, description, image, ingredients, category);
}

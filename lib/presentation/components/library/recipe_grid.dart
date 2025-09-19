// lib/presentation/components/library/recipe_grid.dart
import 'package:flutter/material.dart';
import '../../../data/models/recipe.dart';
import '../../components/recipe/recipe_card.dart';

class RecipeGrid extends StatelessWidget {
  final List<Recipe> items;
  const RecipeGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: .7),
      itemBuilder: (_, i) => RecipeCard(recipe: items[i]),
    );
  }
}

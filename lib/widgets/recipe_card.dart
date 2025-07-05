import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../screens/detailpage.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 4,
      child: ListTile(
        leading: Image.asset(
          'assets/images/${recipe.image}',
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
        title: Text(recipe.title),
        subtitle: Text(recipe.description),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailPage(recipe: recipe),
            ),
          );
        },
      ),
    );
  }
}

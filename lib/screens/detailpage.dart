import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../utils/category_enum.dart';

class DetailPage extends StatelessWidget {
  final Recipe recipe;

  const DetailPage({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recipe.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/images/${recipe.image}', fit: BoxFit.cover),
            const SizedBox(height: 16),
            Text(
              categoryToString(recipe.category),
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              recipe.description,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            const Text(
              "Bahan-bahan:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(recipe.ingredients),
          ],
        ),
      ),
    );
  }
}

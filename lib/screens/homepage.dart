import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/recipe.dart';
import '../utils/category_enum.dart';
import '../widgets/recipe_card.dart'; 

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Recipe> _recipes = [];
  CategoryType? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    final data = await DatabaseHelper.instance.getAllRecipes();

    setState(() {
      if (_selectedCategory != null) {
        _recipes = data.where((r) => r.category == _selectedCategory).toList();
      } else {
        _recipes = data;
      }
    });
  }

  void _onCategoryChanged(CategoryType? category) {
    setState(() {
      _selectedCategory = category;
    });
    _loadRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Resep Makanan & Minuman"),
        actions: [
          DropdownButton<CategoryType?>(
            value: _selectedCategory,
            hint: const Text("Kategori"),
            items: [
              const DropdownMenuItem(value: null, child: Text("Semua")),
              DropdownMenuItem(
                  value: CategoryType.makanan, child: const Text("Makanan")),
              DropdownMenuItem(
                  value: CategoryType.minuman, child: const Text("Minuman")),
            ],
            onChanged: _onCategoryChanged,
          ),
          const SizedBox(width: 16)
        ],
      ),
      body: _recipes.isEmpty
          ? const Center(child: Text("Belum ada resep"))
          : ListView.builder(
              itemCount: _recipes.length,
              itemBuilder: (context, index) {
                final r = _recipes[index];
                return RecipeCard(recipe: r); // Gunakan komponen
              },
            ),
    );
  }
}

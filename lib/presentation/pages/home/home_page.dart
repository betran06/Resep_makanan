// lib/presentation/pages/home/home_page.dart
import 'package:flutter/material.dart';

// Struktur sesuai yang kita sepakati:
import '../../../data/database/database_helper.dart';           // helper DB di folder /database
import '../../../data/models/recipe.dart';                 // model domain di /data/models
import '../../../data/models/category_enum.dart';       // enum kategori di /core/constants
import '../../components/recipe_card.dart';                // komponen UI domain di /presentation/components

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Sumber data asli + hasil filter (visible)
  List<Recipe> _allRecipes = [];
  List<Recipe> _visibleRecipes = [];

  CategoryType? _selectedCategory;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadRecipes();
    _searchController.addListener(_applyFilters); // sinkronkan pencarian real-time (tanpa debounce)
  }

  @override
  void dispose() {
    _searchController.removeListener(_applyFilters);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadRecipes() async {
    final data = await DatabaseHelper.instance.getAllRecipes();

    setState(() {
      _allRecipes = data;
    });
    _applyFilters();
  }

  void _applyFilters() {
    final query = _searchController.text.trim().toLowerCase();

    List<Recipe> list = _allRecipes;

    if (_selectedCategory != null) {
      list = list.where((r) => r.category == _selectedCategory).toList();
    }

    if (query.isNotEmpty) {
      list = list.where((r) {
        final name = (r.title).toLowerCase();
        final desc = (r.description).toLowerCase();
        return name.contains(query) || desc.contains(query);
      }).toList();
    }

    setState(() {
      _visibleRecipes = list;
    });
  }

  void _onCategoryChanged(CategoryType? category) {
    setState(() {
      _selectedCategory = category;
    });
    _applyFilters();
  }

  Widget _buildCategoryChips() {
    return Wrap(
      spacing: 8,
      children: [
        ChoiceChip(
          label: const Text("All"),
          selected: _selectedCategory == null,
          onSelected: (_) => _onCategoryChanged(null),
        ),
        ChoiceChip(
          label: const Text("Makanan"),
          selected: _selectedCategory == CategoryType.makanan,
          onSelected: (_) => _onCategoryChanged(CategoryType.makanan),
        ),
        ChoiceChip(
          label: const Text("Minuman"),
          selected: _selectedCategory == CategoryType.minuman,
          onSelected: (_) => _onCategoryChanged(CategoryType.minuman),
        ),
        ChoiceChip(
          label: const Text("Kue"),
          selected: _selectedCategory == CategoryType.kue,
          onSelected: (_) => _onCategoryChanged(CategoryType.kue),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // BottomNavigation dipindah ke RootScaffold
      backgroundColor: const Color(0xFFFFFAF0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Find Your Food",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'find the food...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: const Color(0xFFFFF2D1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildCategoryChips(),
              const SizedBox(height: 16),
              Expanded(
                child: _visibleRecipes.isEmpty
                    ? const Center(child: Text("Belum ada resep"))
                    : GridView.builder(
                        key: const PageStorageKey('home_grid'), // simpan posisi scroll
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 30,
                          crossAxisSpacing: 30,
                          childAspectRatio: 0.68,
                        ),
                        itemCount: _visibleRecipes.length,
                        itemBuilder: (context, index) {
                          final r = _visibleRecipes[index];
                          return RecipeCard(recipe: r);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

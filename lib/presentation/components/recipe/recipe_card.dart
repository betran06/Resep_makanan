import 'package:flutter/material.dart';
import '../../../data/models/recipe.dart';
import '../../pages/detailpage.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (_) => DetailPage(recipe: recipe)),
      //   );
      // },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFF2D1), // krem
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(
                'assets/images/${recipe.image}',
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    recipe.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      Icon(Icons.access_time, size: 16, color: Colors.orange),
                      Text('30 ms', style: TextStyle(fontSize: 12)),
                      Icon(Icons.restaurant_menu, size: 16, color: Colors.orange),
                      Text('Mudah', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFF2B949),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailPage(recipe: recipe),
                          ),
                        );
                      },
                      child: const Text('see recipe'),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

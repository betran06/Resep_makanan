// lib/data/repositories/library_repository.dart
// import 'package:collection/collection.dart';
import '../models/recipe.dart';

class LibraryRepository {
  LibraryRepository();

  // TODO: ganti dengan query DB sesungguhnya
  Future<List<Recipe>> fetchFavorites() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return []; // return list resep favorit
  }

  Future<List<Recipe>> fetchHistory() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return []; // return list resep terakhir dibuka
  }

  // Contoh struktur koleksi: Map<collectionName, List<Recipe>>
  Future<Map<String, List<Recipe>>> fetchCollections() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return {}; // mis. {'Dessert Sunday': [...], 'Minuman Segar': [...]}
  }

  // Aksi:
  Future<void> toggleFavorite(Recipe recipe, {required bool toFav}) async {
    await Future.delayed(const Duration(milliseconds: 120));
    // simpan ke DB: insert/delete favorit
  }

  // Util sorting (opsional):
  // List<Recipe> sortBy(List<Recipe> items, LibrarySort sort) {
  //   final list = [...items];
  //   switch (sort) {
  //     case LibrarySort.latest:
  //       list.sort((a, b) => (b.updatedAt ?? DateTime(0)).compareTo(a.updatedAt ?? DateTime(0)));
  //       break;
  //     case LibrarySort.mostLoved:
  //       list.sort((a, b) => (b.likes ?? 0).compareTo(a.likes ?? 0));
  //       break;
  //     case LibrarySort.quickCook:
  //       list.sort((a, b) => (a.durationMinutes ?? 0).compareTo(b.durationMinutes ?? 0));
  //       break;
  //   }
  //   return list;
  // }
}

enum LibrarySort { latest, mostLoved, quickCook }

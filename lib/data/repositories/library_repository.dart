// lib/data/repositories/library_repository.dart
// import 'package:collection/collection.dart';
import '../models/recipe.dart';

/// Opsi urut untuk Library (disederhanakan sesuai model Recipe)
enum LibrarySort { latest, alphabetical }

class LibraryRepository {
  /// Callback untuk mengambil semua resep (mis. DatabaseHelper.instance.getAllRecipes).
  final Future<List<Recipe>> Function() getAllRecipes;

  /// Kumpulan ID favorit yang sudah tersimpan (bisa diisi dari SharedPreferences/DB lain).
  final Set<int> favoriteIds;

  /// Riwayat ID resep (urut paling baru di depan).
  final List<int> historyIds;

  /// Koleksi: nama koleksi -> daftar ID resep.
  final Map<String, List<int>> collectionsMap;

  LibraryRepository({
    required this.getAllRecipes,
    this.favoriteIds = const {},
    this.historyIds = const [],
    this.collectionsMap = const {},
  });

  /// Ambil daftar favorit berdasarkan [favoriteIds].
  Future<List<Recipe>> fetchFavorites() async {
    final all = await getAllRecipes();
    final favs = all.where((r) => r.id != null && favoriteIds.contains(r.id!)).toList();
    return favs;
  }

  /// Ambil riwayat berdasarkan [historyIds] (dipertahankan urutannya).
  Future<List<Recipe>> fetchHistory() async {
    final all = await getAllRecipes();
    final byId = {for (final r in all) if (r.id != null) r.id!: r};
    final hist = <Recipe>[];
    for (final id in historyIds) {
      final r = byId[id];
      if (r != null) hist.add(r);
    }
    return hist;
  }

  /// Ambil koleksi: mapping nama -> list Recipe (urut sesuai urutan ID pada collectionsMap).
  Future<Map<String, List<Recipe>>> fetchCollections() async {
    final all = await getAllRecipes();
    final byId = {for (final r in all) if (r.id != null) r.id!: r};

    final result = <String, List<Recipe>>{};
    for (final entry in collectionsMap.entries) {
      final list = <Recipe>[];
      for (final id in entry.value) {
        final r = byId[id];
        if (r != null) list.add(r);
      }
      result[entry.key] = list;
    }
    return result;
  }

  /// Toggle favorit (no-op di repo murni ini).
  /// Simpan/perbarui [favoriteIds] di layer penyimpananmu (SharedPreferences/DB) lalu buat instance baru repo atau panggil refresh di provider.
  Future<void> toggleFavorite(Recipe recipe, {required bool toFav}) async {
    // Intentionally left blank (side-effect disarankan di layer penyimpanan).
    // Implementasi contoh (opsional):
    // if (recipe.id != null) {
    //   if (toFav) { favoriteIds.add(recipe.id!); } else { favoriteIds.remove(recipe.id!); }
    //   await saveToPrefs(favoriteIds);
    // }
  }

  /// Sort util: Terbaru (id desc) atau A-Z (title).
  List<Recipe> sortBy(List<Recipe> items, LibrarySort sort) {
    final list = [...items];
    switch (sort) {
      case LibrarySort.latest:
        // Asumsi id autoincrement: id terbesar = paling baru
        list.sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));
        break;
      case LibrarySort.alphabetical:
        list.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
    }
    return list;
  }
}

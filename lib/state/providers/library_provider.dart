// lib/state/providers/library_provider.dart
import 'package:flutter/foundation.dart';
import '../../data/models/recipe.dart';
import '../../data/repositories/library_repository.dart';

enum LibraryTab { favorites, collections, history }
enum LibraryStatus { idle, loading, success, empty, error }

class LibraryState {
  final LibraryTab tab;
  final LibraryStatus status;
  final LibrarySort sort;
  final String? errorMessage;

  final List<Recipe> favorites;
  final Map<String, List<Recipe>> collections; // nama koleksi -> resep
  final List<Recipe> history;

  const LibraryState({
    this.tab = LibraryTab.favorites,
    this.status = LibraryStatus.idle,
    this.sort = LibrarySort.latest,
    this.errorMessage,
    this.favorites = const [],
    this.collections = const {},
    this.history = const [],
  });

  LibraryState copyWith({
    LibraryTab? tab,
    LibraryStatus? status,
    LibrarySort? sort,
    String? errorMessage,
    List<Recipe>? favorites,
    Map<String, List<Recipe>>? collections,
    List<Recipe>? history,
  }) {
    return LibraryState(
      tab: tab ?? this.tab,
      status: status ?? this.status,
      sort: sort ?? this.sort,
      errorMessage: errorMessage,
      favorites: favorites ?? this.favorites,
      collections: collections ?? this.collections,
      history: history ?? this.history,
    );
  }
}

class LibraryProvider extends ChangeNotifier {
  final LibraryRepository repo;
  LibraryState _state = const LibraryState();

  LibraryProvider(this.repo);

  LibraryState get state => _state;

  Future<void> init() async {
    await switchTab(_state.tab);
  }

  Future<void> switchTab(LibraryTab tab) async {
    _state = _state.copyWith(tab: tab, status: LibraryStatus.loading, errorMessage: null);
    notifyListeners();

    try {
      switch (tab) {
        case LibraryTab.favorites:
          final favs = await repo.fetchFavorites();
          final sorted = repo.sortBy(favs, _state.sort);
          _state = _state.copyWith(
            favorites: sorted,
            status: sorted.isEmpty ? LibraryStatus.empty : LibraryStatus.success,
          );
          break;
        case LibraryTab.collections:
          final cols = await repo.fetchCollections();
          _state = _state.copyWith(
            collections: cols,
            status: cols.isEmpty ? LibraryStatus.empty : LibraryStatus.success,
          );
          break;
        case LibraryTab.history:
          final hist = await repo.fetchHistory();
          _state = _state.copyWith(
            history: hist,
            status: hist.isEmpty ? LibraryStatus.empty : LibraryStatus.success,
          );
          break;
      }
      notifyListeners();
    } catch (e) {
      _state = _state.copyWith(status: LibraryStatus.error, errorMessage: e.toString());
      notifyListeners();
    }
  }

  void changeSort(LibrarySort sort) {
    _state = _state.copyWith(sort: sort);
    // re-apply sort pada tab yang relevan (favorites saja di contoh ini)
    if (_state.tab == LibraryTab.favorites) {
      final sorted = repo.sortBy(_state.favorites, sort);
      _state = _state.copyWith(favorites: sorted);
    }
    notifyListeners();
  }

  Future<void> toggleFavorite(Recipe r, {required bool toFav}) async {
    await repo.toggleFavorite(r, toFav: toFav);
    if (_state.tab == LibraryTab.favorites) {
      // refresh cepat dengan remove/insert lokal (tanpa hit DB)
      final list = [..._state.favorites];
      if (toFav) {
        list.insert(0, r);
      } else {
        list.removeWhere((x) => x.id == r.id);
      }
      _state = _state.copyWith(favorites: repo.sortBy(list, _state.sort),
        status: list.isEmpty ? LibraryStatus.empty : LibraryStatus.success);
      notifyListeners();
    }
  }

  Future<void> refresh() async => switchTab(_state.tab);
}

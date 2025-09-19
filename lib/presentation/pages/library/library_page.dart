// lib/presentation/pages/library/library_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/repositories/library_repository.dart';
import '../../../state/providers/library_provider.dart';

import '../../components/library/empty_state.dart';
import '../../components/library/error_state.dart';
import '../../components/library/loading_skeleton_grid.dart';
import '../../components/library/recipe_grid.dart';
import '../../components/library/sort_bar.dart';

// Tambahan: butuh Recipe untuk typing _CollectionsView
import '../../../data/models/recipe.dart';

// Penting: inject sumber data nyata ke LibraryRepository
// (pakai path DatabaseHelper kamu yang sekarang)
import '../../../data/database/database_helper.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final repo = LibraryRepository(
          getAllRecipes: DatabaseHelper.instance.getAllRecipes,
          // optional: nanti bisa diisi dari SharedPreferences/DB lain
          // favoriteIds: {...},
          // historyIds: [...],
          // collectionsMap: {'Dessert': [1, 2, 3]},
        );
        final provider = LibraryProvider(repo);
        provider.init();
        return provider;
      },
      child: const _LibraryView(),
    );
  }
}

class _LibraryView extends StatelessWidget {
  const _LibraryView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LibraryProvider>();
    final state = provider.state;

    return SafeArea(
      child: Column(
        children: [
          // Tab selector
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: SegmentedButton<LibraryTab>(
              segments: const [
                ButtonSegment(
                  value: LibraryTab.favorites,
                  label: Text('Favorit'),
                  icon: Icon(Icons.favorite),
                ),
                ButtonSegment(
                  value: LibraryTab.collections,
                  label: Text('Koleksi'),
                  icon: Icon(Icons.folder),
                ),
                ButtonSegment(
                  value: LibraryTab.history,
                  label: Text('Riwayat'),
                  icon: Icon(Icons.history),
                ),
              ],
              selected: {state.tab},
              onSelectionChanged: (s) => provider.switchTab(s.first),
            ),
          ),

          if (state.tab == LibraryTab.favorites)
            SortBar(
              current: state.sort,
              onChanged: provider.changeSort,
              onRefresh: provider.refresh,
            ),

          Expanded(
            child: Builder(
              builder: (_) {
                switch (state.status) {
                  case LibraryStatus.loading:
                    return const LoadingSkeletonGrid();
                  case LibraryStatus.error:
                    return ErrorState(
                      message: state.errorMessage ?? 'Terjadi kesalahan.',
                      onRetry: provider.refresh,
                    );
                  case LibraryStatus.empty:
                    return EmptyState(
                      title: state.tab == LibraryTab.favorites
                          ? 'Belum ada favorit'
                          : state.tab == LibraryTab.collections
                              ? 'Belum ada koleksi'
                              : 'Riwayat kosong',
                      subtitle: state.tab == LibraryTab.favorites
                          ? 'Simpan resep dari beranda untuk muncul di sini.'
                          : state.tab == LibraryTab.collections
                              ? 'Buat koleksi untuk mengelompokkan resep.'
                              : 'Resep yang dibuka akan muncul sebagai riwayat.',
                      actionLabel: 'Muat ulang',
                      onAction: provider.refresh,
                    );
                  case LibraryStatus.success:
                  case LibraryStatus.idle:
                    return switch (state.tab) {
                      LibraryTab.favorites => RecipeGrid(items: state.favorites),
                      LibraryTab.collections =>
                          _CollectionsView(collections: state.collections),
                      LibraryTab.history => RecipeGrid(items: state.history),
                    };
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CollectionsView extends StatelessWidget {
  final Map<String, List<Recipe>> collections;
  const _CollectionsView({required this.collections});

  @override
  Widget build(BuildContext context) {
    if (collections.isEmpty) {
      return const SizedBox.shrink();
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: collections.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final key = collections.keys.elementAt(i);
        final List<Recipe> items = collections[key]!;
        return Card(
          clipBehavior: Clip.antiAlias,
          child: ExpansionTile(
            title: Text(key),
            subtitle: Text('${items.length} resep'),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                // Kirim langsung List<Recipe> (bukan List<dynamic>)
                child: RecipeGrid(items: items),
              ),
            ],
          ),
        );
      },
    );
  }
}

// lib/presentation/components/library/loading_skeleton_grid.dart
import 'package:flutter/material.dart';

class LoadingSkeletonGrid extends StatelessWidget {
  const LoadingSkeletonGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final items = List.filled(6, 0);
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: .7),
      itemBuilder: (_, __) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(.5),
          ),
        );
      },
    );
  }
}

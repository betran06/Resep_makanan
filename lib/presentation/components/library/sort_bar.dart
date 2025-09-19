// lib/presentation/components/library/sort_bar.dart
import 'package:flutter/material.dart';
import '../../../data/repositories/library_repository.dart';

class SortBar extends StatelessWidget {
  final LibrarySort current;
  final ValueChanged<LibrarySort> onChanged;
  final VoidCallback? onRefresh;

  const SortBar({
    super.key,
    required this.current,
    required this.onChanged,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          const Text('Urutkan:'),
          const SizedBox(width: 8),
          DropdownButton<LibrarySort>(
            value: current,
            onChanged: (v) => v != null ? onChanged(v) : null,
            items: const [
              DropdownMenuItem(
                value: LibrarySort.latest,
                child: Text('Terbaru'),
              ),
              DropdownMenuItem(
                value: LibrarySort.alphabetical,
                child: Text('A-Z'),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            tooltip: 'Refresh',
            onPressed: onRefresh,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}

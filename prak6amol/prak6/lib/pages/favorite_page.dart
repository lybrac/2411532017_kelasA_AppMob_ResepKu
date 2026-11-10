import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resepku/providers/favorite_provider.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  Future<void> _confirmClear(
    BuildContext context,
    FavoriteProvider favorite,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus semua favorit?'),
        content: Text(
          '${favorite.count} resep akan dihapus dari daftar favorit.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      favorite.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Consumer membungkus Scaffold agar AppBar dan body sama-sama ikut rebuild
    return Consumer<FavoriteProvider>(
      builder: (context, favorite, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Favorit Saya'),
            actions: [
              IconButton(
                tooltip: 'Hapus semua',
                icon: const Icon(Icons.delete_sweep),
                // null = tombol nonaktif ketika daftar kosong
                onPressed: favorite.count == 0
                    ? null
                    : () => _confirmClear(context, favorite),
              ),
            ],
          ),
          body: favorite.count == 0
              ? const Center(
                  child: Text(
                    'Belum ada resep favorit.\nTekan ikon hati di daftar resep.',
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView(
                  children: [
                    for (final recipe in favorite.items)
                      ListTile(
                        title: Text(recipe.name),
                        subtitle: Text(recipe.cuisine),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => favorite.toggle(recipe),
                        ),
                      ),
                  ],
                ),
        );
      },
    );
  }
}

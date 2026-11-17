import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resepku/providers/favorite_provider.dart';
import 'package:resepku/widgets/recipe_image.dart';

/// Latihan 2: halaman Favorit dengan ListView.separated, thumbnail foto,
/// dan Dismissible (geser ke kiri untuk menghapus dari favorit).
///
/// CATATAN: file ini mengasumsikan FavoriteProvider (Modul 6) memiliki
///
/// Sesuaikan nama getter jika di project Kalian berbeda.
/// Jika Kalian mengerjakan Latihan 2 Modul 6 (tombol hapus semua),
/// pindahkan kembali tombol tersebut ke `actions` AppBar di bawah ini.
class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoriteProvider>().items; // getter List<Recipe> dari FavoriteProvider

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorit'),
        // actions: [ ...tombol hapus semua dari Latihan 2 Modul 6... ],
      ),
      body: favorites.isEmpty
          ? const Center(child: Text('Belum ada resep favorit'))
          : ListView.separated(
              itemCount: favorites.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final recipe = favorites[index];
                return Dismissible(
                  // key unik dan stabil: id resep, bukan index
                  key: ValueKey(recipe.id),
                  direction: DismissDirection.endToStart, // geser ke kiri
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) {
                    // simpan messenger sebelum item hilang dari tree
                    final messenger = ScaffoldMessenger.of(context);
                    context.read<FavoriteProvider>().toggle(recipe);
                    messenger
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text('${recipe.name} dihapus dari favorit'),
                        ),
                      );
                  },
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        width: 56,
                        height: 56,
                        child: RecipeImage(url: recipe.image, cacheWidth: 168),
                      ),
                    ),
                    title: Text(recipe.name),
                    subtitle: Text(
                      '${recipe.cuisine} • ${recipe.totalTimeMinutes} menit',
                    ),
                  ),
                );
              },
            ),
    );
  }
}

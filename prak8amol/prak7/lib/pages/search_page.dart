import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resepku/models/recipe.dart';
import 'package:resepku/services/recipe_service.dart';
import 'package:resepku/widgets/error_view.dart';
import 'package:resepku/widgets/recipe_tile.dart';

/// Latihan 1: pencarian resep lewat GET /recipes/search?q=...
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();

  // null = user belum mencari
  Future<List<Recipe>>? _searchFuture;
  String _lastQuery = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Dipanggil saat user menekan Enter, dan oleh tombol "Coba lagi"
  void _search(String value) {
    final query = value.trim();
    if (query.isEmpty) return;
    setState(() {
      _lastQuery = query;
      _searchFuture = context.read<RecipeService>().searchRecipes(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          textInputAction: TextInputAction.search,
          decoration: const InputDecoration(
            hintText: 'Cari resep, misalnya pasta',
            border: InputBorder.none,
          ),
          onSubmitted: _search,
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final future = _searchFuture;
    if (future == null) {
      return const Center(child: Text('Ketik kata kunci lalu tekan Enter.'));
    }
    return FutureBuilder<List<Recipe>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return ErrorView(
            message: 'Pencarian gagal.\n${snapshot.error}',
            onRetry: () => _search(_lastQuery),
          );
        }
        final recipes = snapshot.data ?? [];
        if (recipes.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Tidak ada resep yang cocok dengan "$_lastQuery".',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        return ListView.builder(
          itemCount: recipes.length,
          itemBuilder: (context, index) => RecipeTile(recipe: recipes[index]),
        );
      },
    );
  }
}

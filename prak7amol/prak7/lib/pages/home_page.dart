import 'package:flutter/material.dart';
import 'package:resepku/data/dummy_recipes.dart';
import 'package:resepku/models/recipe.dart';
import 'package:resepku/pages/settings_page.dart';
import 'package:resepku/widgets/favorite_badge_button.dart';
import 'package:resepku/widgets/recipe_grid_card.dart';
import 'package:resepku/widgets/recipe_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isGrid = false; // ephemeral state: hanya HomePage yang membutuhkan

  /// Latihan 1: cuisine yang dipilih. null berarti semua cuisine.
  String? _cuisine;

  /// Daftar cuisine diambil dari data (bukan ditulis manual).
  late final List<String> _cuisines =
      dummyRecipes.map((r) => r.cuisine).toSet().toList();

  /// Data yang sudah difilter sesuai chip yang dipilih.
  List<Recipe> get _filtered => _cuisine == null
      ? dummyRecipes
      : dummyRecipes.where((r) => r.cuisine == _cuisine).toList();

  @override
  Widget build(BuildContext context) {
    final recipes = _filtered;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/images/goodreads.png', height: 32,
            errorBuilder: (context, error, stackTrace) => const SizedBox(width: 32, height: 32),
            ),
            const SizedBox(width: 8),
            const Text('ResepKu'),
          ],
        ),
        actions: [
          IconButton(
            tooltip: _isGrid ? 'Tampilan list' : 'Tampilan grid',
            icon: Icon(_isGrid ? Icons.view_list : Icons.grid_view),
            onPressed: () => setState(() => _isGrid = !_isGrid),
          ),
          const FavoriteBadgeButton(),
          IconButton(
            tooltip: 'Pengaturan',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildChips(),
          // list/grid yang mengisi sisa layar di dalam Column wajib Expanded
          Expanded(
            child: _isGrid ? _buildGrid(recipes) : _buildList(recipes),
          ),
        ],
      ),
    );
  }

  /// Deretan ChoiceChip yang dapat digeser ke samping.
  Widget _buildChips() {
    // ListView horizontal di dalam Column wajib diberi tinggi
    return SizedBox(
      height: 56,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: const Text('Semua'),
              selected: _cuisine == null,
              onSelected: (_) => setState(() => _cuisine = null),
            ),
          ),
          for (final c in _cuisines)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(c),
                selected: _cuisine == c,
                onSelected: (_) => setState(() => _cuisine = c),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildList(List<Recipe> recipes) {
    return ListView.builder(
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        return RecipeTile(recipe: recipes[index]);
      },
    );
  }

  Widget _buildGrid(List<Recipe> recipes) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 3 / 4, // lebar : tinggi
      ),
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        return RecipeGridCard(recipe: recipes[index]);
      },
    );
  }
}

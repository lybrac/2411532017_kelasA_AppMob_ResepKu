import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resepku/models/recipe.dart';
import 'package:resepku/services/recipe_service.dart';

enum _RecipeAction { rename, delete }

/// Latihan 2: menu ubah nama (PUT) dan hapus (DELETE) untuk halaman detail.
/// Letakkan di actions milik AppBar (atau SliverAppBar).
class RecipeActionsMenu extends StatelessWidget {
  const RecipeActionsMenu({super.key, required this.recipe});

  final Recipe recipe;

  Future<void> _rename(BuildContext context) async {
    final service = context.read<RecipeService>();
    final messenger = ScaffoldMessenger.of(context);

    final newName = await showDialog<String>(
      context: context,
      builder: (context) => _RenameDialog(initialName: recipe.name),
    );
    if (newName == null || newName.isEmpty) return;

    try {
      final serverName = await service.updateRecipe(recipe.id, name: newName);
      if (!context.mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text('Server menjawab: nama resep menjadi "$serverName".')),
      );
    } catch (e) {
      if (!context.mounted) return;
      messenger.showSnackBar(SnackBar(content: Text('Gagal mengubah: $e')));
    }
  }

  Future<void> _delete(BuildContext context) async {
    final service = context.read<RecipeService>();
    final messenger = ScaffoldMessenger.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus resep?'),
        content: Text('"${recipe.name}" akan dihapus.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      final deleted = await service.deleteRecipe(recipe.id);
      if (!context.mounted) return;
      if (deleted) {
        messenger.showSnackBar(
          SnackBar(content: Text('"${recipe.name}" dihapus (isDeleted: true).')),
        );
        Navigator.pop(context); // tutup halaman detail
      } else {
        messenger.showSnackBar(
          const SnackBar(content: Text('Server tidak mengonfirmasi penghapusan.')),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      messenger.showSnackBar(SnackBar(content: Text('Gagal menghapus: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_RecipeAction>(
      tooltip: 'Menu resep',
      onSelected: (action) {
        switch (action) {
          case _RecipeAction.rename:
            _rename(context);
          case _RecipeAction.delete:
            _delete(context);
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(value: _RecipeAction.rename, child: Text('Ubah nama')),
        PopupMenuItem(value: _RecipeAction.delete, child: Text('Hapus')),
      ],
    );
  }
}

/// Dialog berisi TextField. Dibuat StatefulWidget agar controller
/// di-dispose bersama dialog.
class _RenameDialog extends StatefulWidget {
  const _RenameDialog({required this.initialName});

  final String initialName;

  @override
  State<_RenameDialog> createState() => _RenameDialogState();
}

class _RenameDialogState extends State<_RenameDialog> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialName);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ubah nama resep'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(labelText: 'Nama baru'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _controller.text.trim()),
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}

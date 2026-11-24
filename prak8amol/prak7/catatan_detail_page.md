# Catatan perubahan pada `lib/pages/detail_page.dart`

Berkas `detail_page.dart` tidak disertakan utuh karena isinya berasal dari
Modul 7 milik masing-masing. Dua perubahan di bawah ini ditambahkan secara manual.
Pilih versi sesuai halaman detail Kalian (ListView atau SliverAppBar/Latihan 3 Modul 7).

---

## 1. Langkah B.5: bagian "Langkah" memasak

### Versi AppBar biasa (ListView)

Tempel tepat setelah perulangan `for` yang menampilkan bahan:

```dart
if (recipe.instructions.isNotEmpty) ...[
  const SizedBox(height: 24),
  Text('Langkah', style: textTheme.titleLarge),
  for (final (index, step) in recipe.instructions.indexed)
    ListTile(
      dense: true,
      leading: CircleAvatar(radius: 12, child: Text('${index + 1}')),
      title: Text(step),
    ),
],
```

### Versi SliverAppBar (CustomScrollView)

Tambahkan di dalam `slivers: [ ... ]`, tepat setelah `SliverList.builder` bahan:

```dart
  if (recipe.instructions.isNotEmpty)
    SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
        child: Text('Langkah', style: textTheme.titleLarge),
      ),
    ),
  SliverList.builder(
    itemCount: recipe.instructions.length,
    itemBuilder: (context, index) => ListTile(
      dense: true,
      leading: CircleAvatar(radius: 12, child: Text('${index + 1}')),
      title: Text(recipe.instructions[index]),
    ),
  ),
  const SliverToBoxAdapter(child: SizedBox(height: 24)),
],
```

---

## 2. Latihan 2: menu ubah nama dan hapus

Tambahkan import:

```dart
import 'package:resepku/widgets/recipe_actions_menu.dart';
```

* **AppBar biasa**: tambahkan `RecipeActionsMenu(recipe: recipe)` pada `actions` milik `AppBar`.
* **SliverAppBar**: tambahkan `RecipeActionsMenu(recipe: recipe)` pada `actions` milik
  `SliverAppBar`, setelah tombol favorit.

Contoh:

```dart
actions: [
  // ... tombol favorit yang sudah ada ...
  RecipeActionsMenu(recipe: recipe),
],
```

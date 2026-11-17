# Modul 7 — ResepKu: cara memasang file ini

Zip ini berisi file BARU/BERUBAH saja. Salin ke project `resepku` dari Modul 6
(timpa jika diminta), lalu terapkan 3 perubahan manual di bawah.

## Yang tinggal disalin (sudah lengkap)
- `assets/`                      -> ke folder utama project (sejajar `lib`)
- `lib/widgets/recipe_image.dart`      (baru)
- `lib/widgets/recipe_grid_card.dart`  (baru)
- `lib/widgets/recipe_tile.dart`
- `lib/pages/home_page.dart`     (sudah termasuk Latihan 1: filter cuisine)
- `lib/pages/favorite_page.dart` (Latihan 2) — lihat catatan asumsi di file

## Perubahan manual 1 — pubspec.yaml (bagian bawah)
```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/images/
  fonts:
    - family: Poppins
      fonts:
        - asset: assets/fonts/Poppins-Regular.ttf
        - asset: assets/fonts/Poppins-Medium.ttf
          weight: 500
        - asset: assets/fonts/Poppins-Bold.ttf
          weight: 700
```

## Perubahan manual 2 — lib/main.dart (tambahkan fontFamily)
```dart
theme: ThemeData(
  colorSchemeSeed: Colors.deepOrange,
  fontFamily: 'Poppins',
),
darkTheme: ThemeData(
  colorSchemeSeed: Colors.deepOrange,
  brightness: Brightness.dark,
  fontFamily: 'Poppins',
),
```
Jangan hapus `themeMode` dan builder footer identitas dari Modul 6.

## Perubahan manual 3 — lib/pages/detail_page.dart (Langkah D.1)
Tambahkan import:
```dart
import 'package:resepku/widgets/recipe_image.dart';
```
Lalu jadikan child pertama ListView, tepat setelah `children: [`:
```dart
ClipRRect(
  borderRadius: BorderRadius.circular(16),
  child: AspectRatio(
    aspectRatio: 16 / 9,
    child: RecipeImage(url: recipe.image),
  ),
),
const SizedBox(height: 16),
```

## Setelah itu
```
flutter pub get
flutter run        # stop lalu run ulang, bukan hot reload
```

## Asumsi terhadap kode Modul 6
- `Recipe` punya: id, name, cuisine, totalTimeMinutes, rating, image
- `FavoriteProvider` punya: isFavorite(recipe), toggle(recipe), getter `favorites`
- `dummyRecipes` ada di `lib/data/dummy_recipes.dart`
Jika nama di project Kalian berbeda, sesuaikan.

## Catatan
- `logo.png` dan `placeholder.png` di zip ini dibuat sederhana sebagai pengganti;
  boleh ditimpa dengan file dari dosen.
- Font Poppins berlisensi SIL Open Font License.
- Latihan 3 (bonus) tidak dikerjakan karena membutuhkan isi detail_page.dart Kalian.

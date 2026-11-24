# Jawaban Laporan — Modul Praktikum 7 (ResepKu)

> Screenshot (Checkpoint 1–3, Latihan 1–2) dan centang tabel uji harus Kalian
> ambil sendiri dari emulator, lengkap dengan footer NIM dan nama.

## Perhitungan Langkah C.3 (layar 360 dp)
Padding grid 8 dp kiri + 8 dp kanan = 16 dp; crossAxisSpacing = 8 dp; 2 kolom.

- Lebar kartu  = (360 − 16 − 8) / 2 = 336 / 2 = **168 dp**
- Tinggi kartu = lebar / childAspectRatio = 168 / (3/4) = 168 × 4/3 = **224 dp**

| Yang dihitung | Hasil |
|---|---|
| Lebar kartu (dp) | 168 |
| Tinggi kartu (dp) | 224 |

## Tabel uji Langkah D.2
| No | Skenario | Sesuai? |
|---|---|---|
| 1 | Buka aplikasi: logo, font Poppins, thumbnail | (isi setelah menguji) |
| 2 | Tombol grid: kartu 2 kolom, ikon berubah jadi list | (isi setelah menguji) |
| 3 | Mode grid, tap hati Margherita: merah, badge bertambah | (isi setelah menguji) |
| 4 | Kembali ke list: hati Margherita tetap merah | (isi setelah menguji) |
| 5 | Tap kartu Alfredo: detail dengan foto besar | (isi setelah menguji) |
| 6 | Mode pesawat: placeholder tampil tanpa error merah | (isi setelah menguji) |

## Pertanyaan Analisis
1. **Status favorit tetap sama.** RecipeGridCard dan RecipeTile memang dua widget
   berbeda, tetapi keduanya tidak menyimpan status favorit sendiri. Keduanya membaca
   status dari satu sumber yang sama, yaitu FavoriteProvider di atas MaterialApp (Modul 6),
   lewat `context.watch<FavoriteProvider>().isFavorite(recipe)`, dan mengubahnya lewat
   `context.read<FavoriteProvider>().toggle(recipe)`. Sedangkan `_isGrid` hanyalah
   ephemeral state di HomePage. Saat tampilan berganti, widget lama dibuang dan widget baru
   dibuat, tetapi data favorit tetap di provider sehingga widget baru langsung menampilkan
   status yang sama.

2. **Jika baris `if (loadingProgress == null) return child;` dihapus**, loadingBuilder
   akan selalu mengembalikan kotak abu-abu berikon (loading state), bahkan setelah unduhan
   selesai. loadingBuilder dipanggil lagi saat unduhan selesai dengan `loadingProgress == null`,
   dan baris itulah yang meneruskan `child` (foto yang sudah jadi). Tanpanya, foto tidak
   pernah tampil dan pengguna terus melihat ikon loading.

3. **Pixel yang di-decode.**
   - Tanpa cacheWidth: 1200 × 800 = **960.000 pixel** (±3,84 MB per foto pada RGBA 4 byte/pixel).
   - Dengan cacheWidth 168: lebar 168, tinggi mengikuti rasio 168 × (800/1200) = 112,
     jadi 168 × 112 = **18.816 pixel** (±75 KB per foto).
   - Perbandingannya sekitar 51 kali lebih hemat. Pada 50 resep (Modul 8), jika semua
     thumbnail berada di memory: ±192 MB tanpa cacheWidth versus ±3,8 MB dengan cacheWidth.
     Tanpa cacheWidth, aplikasi berisiko boros memory, scroll tersendat, hingga ditutup
     sistem karena kehabisan memory.

4. **Logo vs foto resep.** Logo adalah identitas aplikasi yang kecil, tetap, dan harus
   selalu tampil, termasuk saat offline atau koneksi lambat; jika diambil dari internet,
   logo bisa gagal tampil dan setiap pembukaan butuh unduhan. Karena itu logo di-bundle
   sebagai asset. Foto resep jumlahnya banyak dan besar, serta datanya bisa bertambah atau
   berubah dari server; jika dimasukkan ke asset, ukuran APK membengkak dan setiap foto
   baru mengharuskan rilis ulang aplikasi. Maka foto diambil dari internet dengan loading
   dan error state.

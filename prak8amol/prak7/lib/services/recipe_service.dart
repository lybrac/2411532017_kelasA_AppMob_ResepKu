import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:resepku/models/recipe.dart';

/// Semua komunikasi ResepKu dengan REST API dummyjson.com ada di class ini.
/// Widget tidak memanggil http secara langsung.
class RecipeService {
  RecipeService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const _baseUrl = 'https://dummyjson.com';
  static const _timeout = Duration(seconds: 10);
  static const _jsonHeaders = {'Content-Type': 'application/json'};

  /// GET /recipes?limit=50 — mengambil daftar resep.
  Future<List<Recipe>> fetchRecipes({int limit = 50}) async {
    final uri = Uri.parse('$_baseUrl/recipes?limit=$limit');
    final response = await _client.get(uri).timeout(_timeout);
    _checkStatus(response);
    return _decodeRecipeList(response.body);
  }

  // --- Latihan 1: pencarian ---
  /// GET /recipes/search?q=... — mencari resep berdasarkan kata kunci.
  /// replace(queryParameters:) meng-encode spasi dan karakter khusus.
  Future<List<Recipe>> searchRecipes(String query) async {
    final uri = Uri.parse('$_baseUrl/recipes/search')
        .replace(queryParameters: {'q': query});
    final response = await _client.get(uri).timeout(_timeout);
    _checkStatus(response);
    return _decodeRecipeList(response.body);
  }

  /// POST /recipes/add — mengirim resep baru.
  /// dummyjson hanya menyimulasikan penyimpanan: server mengembalikan
  /// data beserta id baru, tetapi resep tidak benar-benar tersimpan.
  Future<Recipe> addRecipe({
    required String name,
    required String cuisine,
    required int cookTimeMinutes,
  }) async {
    final response = await _client
        .post(
          Uri.parse('$_baseUrl/recipes/add'),
          headers: _jsonHeaders,
          body: jsonEncode({
            'name': name,
            'cuisine': cuisine,
            'cookTimeMinutes': cookTimeMinutes,
          }),
        )
        .timeout(_timeout);
    _checkStatus(response);
    return Recipe.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  // --- Latihan 2: ubah dan hapus ---
  /// PUT /recipes/{id} — mengubah nama resep (disimulasikan server).
  /// Mengembalikan nama yang tercantum pada respons server.
  Future<String> updateRecipe(int id, {required String name}) async {
    final response = await _client
        .put(
          Uri.parse('$_baseUrl/recipes/$id'),
          headers: _jsonHeaders,
          body: jsonEncode({'name': name}),
        )
        .timeout(_timeout);
    _checkStatus(response);
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return body['name'] as String? ?? name;
  }

  /// DELETE /recipes/{id} — menghapus resep (disimulasikan server).
  /// Mengembalikan true jika respons berisi isDeleted: true.
  Future<bool> deleteRecipe(int id) async {
    final response =
        await _client.delete(Uri.parse('$_baseUrl/recipes/$id')).timeout(_timeout);
    _checkStatus(response);
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return body['isDeleted'] == true;
  }
  // --- akhir latihan ---

  /// Daftar resep ada di dalam key "recipes" pada objek terluar.
  List<Recipe> _decodeRecipeList(String responseBody) {
    final body = jsonDecode(responseBody) as Map<String, dynamic>;
    final list = body['recipes'] as List<dynamic>;
    return list
        .map((item) => Recipe.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Status 2xx berarti berhasil. Selain itu, lempar exception
  /// agar FutureBuilder masuk ke error state.
  void _checkStatus(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw RecipeServiceException(
        'Server menjawab dengan status ${response.statusCode}',
      );
    }
  }

  void close() => _client.close();
}

class RecipeServiceException implements Exception {
  RecipeServiceException(this.message);

  final String message;

  @override
  String toString() => message;
}

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:resepku/models/recipe.dart';
import 'package:resepku/services/recipe_service.dart';

http.Response _jsonResponse(Object body, int status) => http.Response(
      jsonEncode(body),
      status,
      headers: {'content-type': 'application/json; charset=utf-8'},
    );

void main() {
  group('Recipe.fromJson', () {
    test('membaca rating 5 (int) sebagai 5.0 dan memberi nilai bawaan', () {
      final recipe = Recipe.fromJson({'id': 7, 'name': 'Tes', 'rating': 5});

      expect(recipe.rating, isA<double>());
      expect(recipe.rating, 5.0);
      expect(recipe.cuisine, '-');
      expect(recipe.difficulty, '-');
      expect(recipe.prepTimeMinutes, 0);
      expect(recipe.cookTimeMinutes, 0);
      expect(recipe.servings, 1);
      expect(recipe.caloriesPerServing, 0);
      expect(recipe.image, '');
      expect(recipe.ingredients, isEmpty);
      expect(recipe.instructions, isEmpty);
    });
  });

  group('RecipeService.fetchRecipes', () {
    test('mengembalikan List<Recipe> dari respons palsu', () async {
      final client = MockClient((request) async {
        expect(request.url.toString(), 'https://dummyjson.com/recipes?limit=50');
        return _jsonResponse({
          'recipes': [
            {
              'id': 1,
              'name': 'Nasi Goreng',
              'cuisine': 'Indonesian',
              'rating': 5,
              'ingredients': ['Nasi', 'Telur'],
              'instructions': ['Tumis bumbu.', 'Masukkan nasi.'],
            },
            {'id': 2, 'name': 'Sate'},
          ],
          'total': 2,
          'skip': 0,
          'limit': 50,
        }, 200);
      });
      final service = RecipeService(client: client);

      final recipes = await service.fetchRecipes();

      expect(recipes, hasLength(2));
      expect(recipes.first.name, 'Nasi Goreng');
      expect(recipes.first.rating, 5.0);
      expect(recipes.first.instructions, hasLength(2));
      expect(recipes.last.cuisine, '-'); // nilai bawaan
    });

    test('melempar RecipeServiceException jika status 404', () async {
      final client = MockClient(
        (request) async => http.Response('Not Found', 404),
      );
      final service = RecipeService(client: client);

      await expectLater(
        service.fetchRecipes(),
        throwsA(isA<RecipeServiceException>()),
      );
    });
  });
}

class Recipe {
  final int id;
  final String name;
  final String cuisine;
  final String difficulty;
  final int prepTimeMinutes;
  final int cookTimeMinutes;
  final int servings;
  final int caloriesPerServing;
  final double rating;
  final String image; // URL foto resep
  final List<String> ingredients;
  final List<String> instructions;

  const Recipe({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.difficulty,
    required this.prepTimeMinutes,
    required this.cookTimeMinutes,
    required this.servings,
    required this.caloriesPerServing,
    required this.rating,
    required this.image,
    required this.ingredients,
    this.instructions = const [],
  });

  int get totalTimeMinutes => prepTimeMinutes + cookTimeMinutes;

  /// Membuat Recipe dari satu objek JSON (Map hasil jsonDecode).
  /// Field yang tidak ada di JSON diberi nilai bawaan agar aplikasi tidak crash.
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as int,
      name: json['name'] as String,
      cuisine: json['cuisine'] as String? ?? '-',
      difficulty: json['difficulty'] as String? ?? '-',
      prepTimeMinutes: json['prepTimeMinutes'] as int? ?? 0,
      cookTimeMinutes: json['cookTimeMinutes'] as int? ?? 0,
      servings: json['servings'] as int? ?? 1,
      caloriesPerServing: json['caloriesPerServing'] as int? ?? 0,
      // JSON tidak membedakan 4 dan 4.0: ambil sebagai num lalu ubah ke double
      rating: (json['rating'] as num? ?? 0).toDouble(),
      image: json['image'] as String? ?? '',
      ingredients: List<String>.from(json['ingredients'] as List? ?? const []),
      instructions: List<String>.from(json['instructions'] as List? ?? const []),
    );
  }
}

// lib/models/recipe.dart

class Recipe {
  final String id;
  final String name;
  final List<String> ingredients;
  final String instructions;
  bool isFavorite;

  Recipe({
    required this.id,
    required this.name,
    required this.ingredients,
    required this.instructions,
    this.isFavorite = false,
  });
}

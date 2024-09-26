// lib/screens/details_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/recipe_provider.dart';
import '../models/recipe.dart';

class DetailsScreen extends StatelessWidget {
  static const routeName = '/details';

  @override
  Widget build(BuildContext context) {
    final recipeId = ModalRoute.of(context)!.settings.arguments as String;
    final recipeProvider = Provider.of<RecipeProvider>(context);
    final Recipe recipe = recipeProvider.findById(recipeId);

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Ingredients
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Ingredients:',
                  style: TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 8.0),
              ...recipe.ingredients.map((ingredient) => ListTile(
                    leading: Icon(Icons.check),
                    title: Text(ingredient),
                  )),
              SizedBox(height: 16.0),
              // Instructions
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Instructions:',
                  style: TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                recipe.instructions,
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 24.0),
              // Favorite Button
              ElevatedButton.icon(
                icon: Icon(
                  recipe.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                ),
                label: Text(
                    recipe.isFavorite ? 'Unfavorite' : 'Mark as Favorite'),
                onPressed: () {
                  recipeProvider.toggleFavoriteStatus(recipe.id);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      recipe.isFavorite ? Colors.red : Colors.blue,
                  // Additional styling can be added here
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

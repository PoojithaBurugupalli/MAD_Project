// lib/providers/recipe_provider.dart

import 'package:flutter/material.dart';
import '../models/recipe.dart';

class RecipeProvider with ChangeNotifier {
  final List<Recipe> _recipes = [
    // Existing Recipes
    Recipe(
      id: '1',
      name: 'Spaghetti Bolognese',
      ingredients: [
        '200g spaghetti',
        '100g minced beef',
        '1 onion',
        '2 cloves garlic',
        '400g canned tomatoes',
        'Salt',
        'Pepper',
        'Olive oil',
      ],
      instructions:
          '1. Cook spaghetti according to package instructions.\n'
          '2. In a pan, heat olive oil and sauté onions and garlic until translucent.\n'
          '3. Add minced beef and cook until browned.\n'
          '4. Pour in canned tomatoes, season with salt and pepper, and simmer for 15 minutes.\n'
          '5. Serve sauce over spaghetti.',
    ),
    Recipe(
      id: '2',
      name: 'Chicken Curry',
      ingredients: [
        '500g chicken breast',
        '2 onions',
        '3 cloves garlic',
        '1 tbsp curry powder',
        '400ml coconut milk',
        'Salt',
        'Pepper',
        'Vegetable oil',
      ],
      instructions:
          '1. Cut chicken into cubes.\n'
          '2. In a pot, heat vegetable oil and sauté onions and garlic until fragrant.\n'
          '3. Add chicken and cook until no longer pink.\n'
          '4. Stir in curry powder and cook for 2 minutes.\n'
          '5. Pour in coconut milk, season with salt and pepper, and simmer for 20 minutes.\n'
          '6. Serve with rice.',
    ),

    // New Indian Recipes

    Recipe(
      id: '3',
      name: 'Butter Chicken',
      ingredients: [
        '500g chicken thighs',
        '2 onions, finely chopped',
        '3 cloves garlic, minced',
        '1 tbsp ginger paste',
        '2 tomatoes, pureed',
        '100g butter',
        '200ml cream',
        '2 tsp garam masala',
        '1 tsp turmeric powder',
        '1 tsp chili powder',
        'Salt',
        'Fresh coriander for garnish',
        'Vegetable oil',
      ],
      instructions:
          '1. Marinate chicken with yogurt, turmeric, chili powder, and salt. Refrigerate for at least 1 hour.\n'
          '2. In a pan, heat vegetable oil and sauté onions until golden brown.\n'
          '3. Add garlic and ginger paste, cook for 2 minutes.\n'
          '4. Add pureed tomatoes and cook until the oil separates.\n'
          '5. Stir in garam masala and cook for another minute.\n'
          '6. Add marinated chicken and cook until fully cooked.\n'
          '7. Reduce heat and add butter and cream. Simmer for 5 minutes.\n'
          '8. Garnish with fresh coriander and serve hot with naan or rice.',
    ),
    Recipe(
      id: '4',
      name: 'Chicken Biryani',
      ingredients: [
        '500g chicken pieces',
        '2 cups basmati rice',
        '2 onions, thinly sliced',
        '3 tomatoes, chopped',
        '4 cloves garlic, minced',
        '2 tbsp ginger paste',
        '2 green chilies, slit',
        '1/2 cup yogurt',
        '2 tsp biryani masala',
        '1 tsp turmeric powder',
        '1 tsp red chili powder',
        'Whole spices (2 bay leaves, 4 cloves, 4 cardamom pods, 1 cinnamon stick)',
        'Fresh coriander and mint leaves',
        'Salt',
        'Vegetable oil',
        'Saffron strands soaked in 2 tbsp warm milk (optional)',
      ],
      instructions:
          '1. Wash and soak basmati rice for 30 minutes.\n'
          '2. In a large pot, bring water to a boil, add salt and whole spices. Parboil the rice, drain, and set aside.\n'
          '3. In a separate pan, heat oil and sauté onions until golden brown. Remove half for garnishing.\n'
          '4. Add garlic, ginger paste, and green chilies to the remaining onions. Cook for 2 minutes.\n'
          '5. Add chicken pieces and cook until they start to brown.\n'
          '6. Add tomatoes, yogurt, biryani masala, turmeric, and red chili powder. Cook until the oil separates.\n'
          '7. Layer the parboiled rice over the chicken mixture. Sprinkle saffron milk, chopped coriander, and mint leaves.\n'
          '8. Cover and cook on low heat for 20-25 minutes until the rice is fully cooked.\n'
          '9. Garnish with the reserved fried onions and serve hot with raita.',
    ),
    Recipe(
      id: '5',
      name: 'Paneer Butter Masala',
      ingredients: [
        '250g paneer, cubed',
        '2 onions, pureed',
        '3 tomatoes, pureed',
        '2 tbsp butter',
        '1/2 cup cream',
        '1 tbsp ginger-garlic paste',
        '2 tsp garam masala',
        '1 tsp kasuri methi (dried fenugreek leaves)',
        '1 tsp red chili powder',
        '1 tsp turmeric powder',
        'Salt',
        'Fresh coriander for garnish',
        'Vegetable oil',
      ],
      instructions:
          '1. In a pan, heat oil and sauté ginger-garlic paste until fragrant.\n'
          '2. Add pureed onions and cook until golden brown.\n'
          '3. Add pureed tomatoes, red chili powder, turmeric powder, and salt. Cook until the oil separates.\n'
          '4. Stir in garam masala and kasuri methi.\n'
          '5. Add paneer cubes and mix gently.\n'
          '6. Pour in cream and butter, simmer for 5 minutes.\n'
          '7. Garnish with fresh coriander and serve hot with naan or roti.',
    ),
    Recipe(
      id: '6',
      name: 'Chole Bhature',
      ingredients: [
        // Chole Ingredients
        '2 cups chickpeas (chole), soaked overnight and boiled',
        '2 onions, finely chopped',
        '2 tomatoes, pureed',
        '2 tbsp ginger-garlic paste',
        '2 green chilies, slit',
        '1 tbsp chole masala',
        '1 tsp turmeric powder',
        '1 tsp cumin seeds',
        '1 tsp red chili powder',
        'Salt',
        'Fresh coriander for garnish',
        'Vegetable oil',

        // Bhature Ingredients
        '2 cups all-purpose flour (maida)',
        '1/4 cup semolina (sooji)',
        '1 tsp baking powder',
        '1/2 tsp baking soda',
        '1/2 tsp salt',
        '2 tbsp yogurt',
        '2 tbsp oil',
        'Warm water as needed',
        'Oil for deep frying',
      ],
      instructions:
          '-> For Chole:\n'
          '1. Heat oil in a pan, add cumin seeds and let them splutter.\n'
          '2. Add chopped onions and sauté until golden brown.\n'
          '3. Add ginger-garlic paste and green chilies, cook for 2 minutes.\n'
          '4. Stir in pureed tomatoes, turmeric powder, red chili powder, and salt. Cook until oil separates.\n'
          '5. Add boiled chickpeas and chole masala. Mix well and simmer for 15-20 minutes.\n'
          '6. Garnish with fresh coriander.\n\n'
          '-> For Bhature:\n'
          '1. In a mixing bowl, combine all-purpose flour, semolina, baking powder, baking soda, and salt.\n'
          '2. Add yogurt and oil. Mix to form a crumbly texture.\n'
          '3. Gradually add warm water and knead into a soft dough. Cover and let it rest for at least 2 hours.\n'
          '4. Divide the dough into equal portions and roll each into a ball, then flatten into discs.\n'
          '5. Heat oil in a deep frying pan. Once hot, fry the bhature until puffed and golden brown.\n'
          '6. Serve hot with chole and enjoy.',
    ),
    Recipe(
      id: '7',
      name: 'Masala Dosa',
      ingredients: [
        // For Dosa Batter
        '2 cups parboiled rice',
        '1/2 cup urad dal (split black gram)',
        '1 tsp fenugreek seeds',
        'Salt',
        'Water as needed',

        // For Potato Filling
        '4 large potatoes, boiled and mashed',
        '2 onions, thinly sliced',
        '2 green chilies, slit',
        '1 tsp mustard seeds',
        '1 tsp turmeric powder',
        'A pinch of asafoetida (hing)',
        '10 curry leaves',
        '2 tbsp oil',
        'Salt',
        'Fresh coriander for garnish',
      ],
      instructions:
          '-> For Dosa Batter:\n'
          '1. Rinse and soak rice, urad dal, and fenugreek seeds separately for at least 4 hours.\n'
          '2. Grind the soaked ingredients to a smooth batter, adding water as needed.\n'
          '3. Mix both batters, add salt, and let it ferment overnight or for 8-12 hours.\n\n'
          '-> For Potato Filling:\n'
          '1. Heat oil in a pan, add mustard seeds. Once they splutter, add asafoetida and curry leaves.\n'
          '2. Add sliced onions and green chilies, sauté until onions are translucent.\n'
          '3. Add turmeric powder and mashed potatoes. Mix well.\n'
          '4. Season with salt and garnish with fresh coriander. Set aside.\n\n'
          '-> To Make Masala Dosa:\n'
          '1. Heat a non-stick tava or griddle. Pour a ladleful of dosa batter and spread it in a circular motion to make a thin crepe.\n'
          '2. Drizzle a little oil around the edges and cook until the dosa turns golden brown and crisp.\n'
          '3. Place a portion of the potato filling in the center and fold the dosa over it.\n'
          '4. Serve hot with coconut chutney and sambar.',
    ),
  ];

  List<Recipe> get recipes => [..._recipes];

  List<Recipe> get favoriteRecipes =>
      _recipes.where((recipe) => recipe.isFavorite).toList();

  Recipe findById(String id) {
    return _recipes.firstWhere((recipe) => recipe.id == id);
  }

  void toggleFavoriteStatus(String id) {
    final recipe = findById(id);
    recipe.isFavorite = !recipe.isFavorite;
    notifyListeners();
  }
}

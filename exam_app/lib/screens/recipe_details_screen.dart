import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../models/recipe.dart';
import '../database/database_helper.dart';
import 'add_edit_recipe_screen.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late Recipe currentRecipe;

  @override
  void initState() {
    super.initState();
    currentRecipe = widget.recipe;
  }

  Future<void> _toggleFavorite() async {
    final updated = currentRecipe.copyWith(isFavorite: !currentRecipe.isFavorite);
    await DatabaseHelper.instance.updateRecipe(updated);
    setState(() {
      currentRecipe = updated;
    });
  }

  Future<void> _deleteRecipe() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Recipe'),
        content: Text('Are you sure you want to delete "${currentRecipe.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await DatabaseHelper.instance.deleteRecipe(currentRecipe.id!);
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  void _shareRecipe() {
    final text =
        '${currentRecipe.name}\n\nCategory: ${currentRecipe.category}\nPrep Time: ${currentRecipe.prepTime} min\nServings: ${currentRecipe.servings}\n\nIngredients:\n${currentRecipe.ingredients}\n\nSteps:\n${currentRecipe.steps}';
    Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: currentRecipe.imagePath != null
                  ? Image.file(
                      File(currentRecipe.imagePath!),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.orange.shade400, Colors.red.shade400],
                            ),
                          ),
                          child: Icon(
                            Icons.restaurant_menu,
                            size: 100,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        );
                      },
                    )
                  : Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.orange.shade400, Colors.red.shade400],
                        ),
                      ),
                      child: Icon(
                        Icons.restaurant_menu,
                        size: 100,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  currentRecipe.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: currentRecipe.isFavorite ? Colors.red : Colors.white,
                ),
                onPressed: _toggleFavorite,
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: _shareRecipe,
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddEditRecipeScreen(recipe: currentRecipe),
                    ),
                  );
                  // Reload recipe after edit
                  final recipes = await DatabaseHelper.instance.getAllRecipes();
                  final updated = recipes.firstWhere((r) => r.id == currentRecipe.id);
                  setState(() {
                    currentRecipe = updated;
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: _deleteRecipe,
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          currentRecipe.name,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          currentRecipe.category,
                          style: TextStyle(
                            color: Colors.orange.shade800,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _InfoChip(
                        icon: Icons.access_time,
                        label: '${currentRecipe.prepTime} minutes',
                      ),
                      const SizedBox(width: 16),
                      _InfoChip(
                        icon: Icons.people,
                        label: '${currentRecipe.servings} servings',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Ingredients',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: currentRecipe.ingredients
                            .split('\n')
                            .where((ing) => ing.trim().isNotEmpty)
                            .map((ing) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('• ', style: TextStyle(fontSize: 18)),
                                      Expanded(child: Text(ing.trim())),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Instructions',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  ...currentRecipe.steps
                      .split('\n')
                      .where((step) => step.trim().isNotEmpty)
                      .map((step) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(step.trim()),
                      ),
                    );
                  }),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade700),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
    );
  }
}
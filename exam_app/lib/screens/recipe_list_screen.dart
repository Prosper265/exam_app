import 'package:exam_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:exam_app/screens/recipe_details_screen.dart';
import '../models/recipe.dart';
import '../database/database_helper.dart';
import '../widgets/recipe_card.dart';
import 'add_edit_recipe_screen.dart';

class RecipeListScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

  const RecipeListScreen({
    super.key,
    required this.onThemeToggle,
    required this.isDarkMode,
  });

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  List<Recipe> recipes = [];
  List<Recipe> filteredRecipes = [];
  String searchQuery = '';
  String selectedCategory = 'All';
  String sortBy = 'name';
  bool showFilters = false;

  final List<String> categories = [
    'All',
    'Breakfast',
    'Lunch',
    'Dinner',
    'Dessert',
    'Snack',
    'Beverage'
  ];

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    final allRecipes = await DatabaseHelper.instance.getAllRecipes();
    setState(() {
      recipes = allRecipes;
      _filterRecipes();
    });
  }

  void _filterRecipes() {
    List<Recipe> filtered = recipes;

    if (selectedCategory != 'All') {
      filtered = filtered.where((r) => r.category == selectedCategory).toList();
    }

    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((r) {
        return r.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
            r.ingredients.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    // Sort
    if (sortBy == 'name') {
      filtered.sort((a, b) => a.name.compareTo(b.name));
    } else if (sortBy == 'time') {
      filtered.sort((a, b) => a.prepTime.compareTo(b.prepTime));
    } else if (sortBy == 'favorites') {
      filtered.sort((a, b) => (b.isFavorite ? 1 : 0) - (a.isFavorite ? 1 : 0));
    }

    setState(() {
      filteredRecipes = filtered;
    });
  }

  Future<void> _toggleFavorite(Recipe recipe) async {
    final updated = recipe.copyWith(isFavorite: !recipe.isFavorite);
    await DatabaseHelper.instance.updateRecipe(updated);
    _loadRecipes();
  }

  Future<void> _deleteRecipe(Recipe recipe) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Recipe'),
        content: Text('Are you sure you want to delete "${recipe.name}"?'),
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
      await DatabaseHelper.instance.deleteRecipe(recipe.id!);
      _loadRecipes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.restaurant_menu, color: Colors.white),
            SizedBox(width: 8),
            Text('My Recipe Book', style: TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.onThemeToggle,
            color: Colors.white,
          ),

          //logout 
          AuthService().currentUser != null ? IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              //show a dialog to confirm logout
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Logout', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                await AuthService().signOut();
              }
            },
              
            color: Colors.white,
          ) : const SizedBox.shrink(),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search recipes or ingredients...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                        _filterRecipes();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                    setState(() {
                      showFilters = !showFilters;
                    });
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(context).cardColor,
                  ),
                ),
              ],
            ),
          ),

          // Filters
          if (showFilters)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Sort by:', style: Theme.of(context).textTheme.titleSmall),
                      DropdownButton<String>(
                        value: sortBy,
                        isExpanded: true,
                        items: const [
                          DropdownMenuItem(value: 'name', child: Text('Name (A-Z)')),
                          DropdownMenuItem(value: 'time', child: Text('Prep Time')),
                          DropdownMenuItem(value: 'favorites', child: Text('Favorites First')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            sortBy = value!;
                            _filterRecipes();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Category Chips
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        selectedCategory = category;
                        _filterRecipes();
                      });
                    },
                    backgroundColor: Colors.grey.shade200,
                    selectedColor: Colors.orange,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                );
              },
            ),
          ),

          // Recipe Grid
          Expanded(
            child: filteredRecipes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.restaurant_menu, size: 80, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          'No recipes found',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        const Text('Try adjusting your search or filters'),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: filteredRecipes.length,
                    itemBuilder: (context, index) {
                      final recipe = filteredRecipes[index];
                      return RecipeCard(
                        recipe: recipe,
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecipeDetailScreen(recipe: recipe),
                            ),
                          );
                          _loadRecipes();
                        },
                        onFavoriteToggle: () => _toggleFavorite(recipe),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditRecipeScreen(),
            ),
          );
          _loadRecipes();
        },
        backgroundColor: Colors.orange,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Recipe', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

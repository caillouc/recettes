import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:diacritic/diacritic.dart';

import 'package:recettes/recipe_view.dart';
import 'package:recettes/return_state.dart';
import 'package:recettes/custom_icon.dart';
import 'package:recettes/recipe.dart';
import 'package:recettes/main.dart';

class RecipeList extends StatefulWidget {
  final bool onlyFavorites;
  final ReturnState returnState;
  final RecipeCategory categoryFilter;
  final List<String> keywordsFilter;

  const RecipeList({
    Key? key,
    required this.returnState,
    this.onlyFavorites = false,
    this.categoryFilter = RecipeCategory.other,
    this.keywordsFilter = const [],
  }) : super(key: key);

  @override
  State<RecipeList> createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  List<String> _favorites = [];
  final List<String> _pendingRemove = [];
  List<Recipe> _recipesToDisplay = [];
  List<String> _keywords = [];
  late Future<SharedPreferences> _prefs;
  final Map<String, Timer> _removeTimers = {};

  @override
  void initState() {
    super.initState();
    _prefs = SharedPreferences.getInstance();
    _keywords = widget.keywordsFilter;
  }

  void toogleFav(Recipe recipe) {
  HapticFeedback.heavyImpact();
  bool isFav = _favorites.contains(recipe.id) && !_pendingRemove.contains(recipe.id);
    if (isFav) {
      removeSavedFavorite(recipe.id);
      if (widget.onlyFavorites) {
        setState(() {
          _pendingRemove.add(recipe.id);
        });
        _removeTimers[recipe.id] = Timer(const Duration(seconds: 3), () {
          setState(() {
            _favorites.remove(recipe.id);
            _pendingRemove.remove(recipe.id);
          });
        });
      } else {
        setState(() {
          _favorites.remove(recipe.id);
        });
      }
    } else {
      saveFavorite(recipe.id);
      if (widget.onlyFavorites) {
        _removeTimers[recipe.id]?.cancel();
        setState(() {
          _pendingRemove.remove(recipe.id);
        });
      }
      setState(() {
        _favorites.add(recipe.id);
      });
    }
  }

  void onRecipePressed(Recipe recipe) {
    widget.returnState.needReturn();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RecipeView(
          recipe: recipe,
          isFavorite: _favorites.contains(recipe.id),
          returnState: widget.returnState,
        ),
      ),
    );
  }

  int _filterScore(Recipe recipe, List<String> keywordsFilter) {
    int score = 0;
    String searchTitle = recipe.title.toLowerCase();
    String searchDescription = recipe.description.toLowerCase();
    searchTitle = removeDiacritics(searchTitle);
    searchDescription = removeDiacritics(searchDescription);

    for (String k in keywordsFilter) {
      k = k.toLowerCase(); 
      k = removeDiacritics(k);
      if (searchTitle.contains(k)) {
        score += 3;
      } else if (searchDescription.contains(k)) {
        score += 1;
      } else {
        return 0;
      }
    }
    return score;
  }

  Widget recipeTile(Recipe recipe) {
    bool isFav = _favorites.contains(recipe.id);
    return AnimatedOpacity(
      opacity: _pendingRemove.contains(recipe.id) ? 0.0 : 1.0,
      duration: Duration(seconds: _pendingRemove.contains(recipe.id) ? 3 : 0),
      child: ListTile(
        title: Text(
          recipe.title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          recipe.subtitle,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        tileColor: const Color(0xfff7f2fa),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        leading: recipe.category.getIcon(),
        onTap: () {
          onRecipePressed(recipe);
        },
        // make trailing a favorite button
        trailing: IconButton(
          icon: isFav
              ? CustomIcon.favorite.getColorSolidIcon()
              : CustomIcon.favorite.getBlackOutlinedIcon(),
          onPressed: () {
            toogleFav(recipe);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop){
          widget.returnState.returnPressed();
        }
      },
      child: Card(
        shadowColor: Colors.transparent,
        color: Theme.of(context).scaffoldBackgroundColor,
        margin: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _keywords.isNotEmpty
                ? const SizedBox(height: 10)
                : const SizedBox(),
            _keywords.isEmpty
                ? const SizedBox()
                : Wrap(
                    children: _keywords
                        .map(
                          (keyword) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                            child: Chip(
                              label: Text(keyword, style: const TextStyle(fontSize: 25.0),),
                              deleteIcon: const Icon(Icons.cancel),
                              onDeleted: () {
                                setState(() {
                                  _keywords.remove(keyword);
                                });
                                if (_keywords.isEmpty) {
                                  Navigator.of(context).pop();
                                }
                              },
                            ),
                          ),
                        )
                        .toList(),
                  ),
            _keywords.isNotEmpty
                ? const Divider()
                : const SizedBox(),
            Expanded(
              child: FutureBuilder(
                future: _prefs,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text('Error loading preferences'));
                  }
        
                  final prefs = snapshot.data!;
                  _favorites = prefs.getStringList('favorites') ?? [];
                  if (widget.onlyFavorites) {
                    _recipesToDisplay = recipes
                        .where((recipe) => _favorites.contains(recipe.id) || _pendingRemove.contains(recipe.id))
                        .toList();
                    _recipesToDisplay.sort((a, b) => a.title.compareTo(b.title));
                  } else if (widget.categoryFilter != RecipeCategory.other) {
                    _recipesToDisplay = recipes
                        .where((recipe) => recipe.category == widget.categoryFilter)
                        .toList();
                    _recipesToDisplay.sort((a, b) => a.title.compareTo(b.title));
                  } else if (_keywords.isNotEmpty) {
                    _recipesToDisplay = recipes
                        .where((recipe) => _filterScore(recipe, _keywords) > 0)
                        .toList();
                    // sort recipeToDisplay by filterScore and then by title
                    _recipesToDisplay.sort((a, b) {
                      int scoreA = _filterScore(a, _keywords);
                      int scoreB = _filterScore(b, _keywords);
                      if (scoreA != scoreB) {
                        return scoreB - scoreA;
                      }
                      return a.title.compareTo(b.title);
                    });
                  } else {
                    _recipesToDisplay = recipes;
                    _recipesToDisplay.sort((a, b) => a.title.compareTo(b.title));
                  }
        
                  if (_recipesToDisplay.isEmpty) {
                    String message = "";
                    if (widget.onlyFavorites) {
                      message = 'Vous n\'avez pas de favoris';
                    } else if (_keywords.isNotEmpty) {
                      message = 'Pas de recette pour les mots-clés recherchés';
                    } else {
                      message = 'Pas de recette (Je suis curieux de savoir comment vous avez fait pour arriver ici)';
                    }
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(50.0),
                        child: Text(
                          message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _recipesToDisplay.length * 2 -
                        1, // Double the item count to include separators
                    itemBuilder: (BuildContext context, int index) {
                      // For even indices, return recipeTile
                      if (index.isEven) {
                        return recipeTile(_recipesToDisplay[index ~/ 2]);
                      } else {
                        // For odd indices, return a separator
                        return const SizedBox(
                            height: 8); // Adjust separator height as needed
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

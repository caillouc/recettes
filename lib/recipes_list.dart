import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:diacritic/diacritic.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:recettes/recipe_view.dart';
import 'package:recettes/custom_icon.dart';
import 'package:recettes/recipe.dart';
import 'package:recettes/main.dart';

class RecipeList extends StatefulWidget {
  final bool onlyFavorites;
  final RecipeCategory categoryFilter;
  final List<String> keywordsFilter;
  final bool history;

  const RecipeList({
    Key? key,
    this.onlyFavorites = false,
    this.categoryFilter = RecipeCategory.other,
    this.keywordsFilter = const [],
    this.history = false,
  }) : super(key: key);

  @override
  State<RecipeList> createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  List<String> _history = [];
  final List<String> _pendingRemove = [];
  List<Recipe> _recipesToDisplay = [];
  List<String> _keywords = [];
  late Future<SharedPreferences> _prefs;
  final Map<String, Timer> _removeTimers = {};
  final int _removeDelay = 1500;

  @override
  void initState() {
    super.initState();
    favoriteRecipes.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    _prefs = SharedPreferences.getInstance();
    _keywords = widget.keywordsFilter;
  }

  void toogleFav(Recipe recipe) {
    HapticFeedback.heavyImpact();
    bool isFav =
        favoriteRecipes.isFavorite(recipe.id) && !_pendingRemove.contains(recipe.id);
    if (isFav) {
      if (widget.onlyFavorites) {
        favoriteRecipes.removeFavorite(recipe.id);
        setState(() {
          _pendingRemove.add(recipe.id);
        });
        _removeTimers[recipe.id] = Timer(Duration(milliseconds: _removeDelay), () {
          setState(() {
            _pendingRemove.remove(recipe.id);
          });
        });
      } else {
        favoriteRecipes.removeFavorite(recipe.id);
      }
    } else {
      favoriteRecipes.addFavorite(recipe.id);
      if (widget.onlyFavorites) {
        _removeTimers[recipe.id]?.cancel();
        setState(() {
          _pendingRemove.remove(recipe.id);
        });
      }
    }
  }

  void onRecipePressed(Recipe recipe) {
    returnState.needReturn();
    if (_history.length > 50) {
      setState(() {
        _history.removeAt(0);
      });
    }
    
    if (_history.contains(recipe.id)) {
      setState(() {
        _history.remove(recipe.id);
      });
    }
    setState(() {
      _history.add(recipe.id);
    });
    SharedPreferences.getInstance().then((prefs) {
      prefs.setStringList('history', _history);
    });
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RecipeView(
          recipe: recipe,
        ),
      ),
    );
  }

  int _filterScore(Recipe recipe, List<String> keywordsFilter) {
    int score = 0;
    String searchTitle = recipe.title.toLowerCase();
    String searchSubTitle = recipe.subtitle.toLowerCase();
    String searchDescription = recipe.description.toLowerCase();
    searchTitle = removeDiacritics(searchTitle);
    searchSubTitle = removeDiacritics(searchSubTitle);
    searchDescription = removeDiacritics(searchDescription);

    for (String k in keywordsFilter) {
      k = k.toLowerCase();
      k = removeDiacritics(k);
      if (k.endsWith('s') && k.length > 1) {
        k = k.substring(0, k.length - 1);
      } else if (k.endsWith('x') && k.length > 1) {
        k = k.substring(0, k.length - 1);
      }
      if (searchTitle.contains(k)) {
        score += 3;
      } else if (searchDescription.contains(k) || searchSubTitle.contains(k)) {
        score += 1;
      } else {
        return 0;
      }
    }
    return score;
  }

  Widget recipeTile(Recipe recipe) {
    bool isFav = favoriteRecipes.isFavorite(recipe.id);
    return AnimatedOpacity(
      opacity: _pendingRemove.contains(recipe.id) ? 0.0 : 1.0,
      duration:
          Duration(milliseconds: _pendingRemove.contains(recipe.id) ? _removeDelay : 0),
      child: ListTile(
        title: AutoSizeText(
          maxLines: 2,
          recipe.title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: AutoSizeText(
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
        if (didPop) {
          returnState.returnPressed();
        }
      },
      child: Card(
        shadowColor: Colors.transparent,
        color: Theme.of(context).scaffoldBackgroundColor,
        margin: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            _keywords.isEmpty
                ? AutoSizeText(
                    maxLines: 1,
                    widget.onlyFavorites
                        ? 'Favoris'
                        : widget.history
                            ? 'Historique'
                            : widget.categoryFilter == RecipeCategory.other
                                ? 'Toutes les recettes'
                                : widget.categoryFilter.getName(),
                    style: const TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                  )
                : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      children: _keywords
                          .map(
                            (keyword) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 5.0),
                              child: Chip(
                                label: AutoSizeText(
                                  keyword,
                                  style: const TextStyle(fontSize: 25.0),
                                ),
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
                ),
            const Divider(),
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
                  _history = prefs.getStringList('history') ?? [];
                  if (widget.onlyFavorites) {
                    _recipesToDisplay = recipes
                        .where((recipe) =>
                            favoriteRecipes.isFavorite(recipe.id) ||
                            _pendingRemove.contains(recipe.id))
                        .toList();
                    _recipesToDisplay.sort((a, b) => a.title.compareTo(b.title));
                  } else if (widget.history) {
                    _recipesToDisplay = recipes
                        .where((recipe) => _history.contains(recipe.id))
                        .toList();
                    _recipesToDisplay.sort((a, b) {
                      int indexA = _history.indexOf(a.id);
                      int indexB = _history.indexOf(b.id);
                      return indexB - indexA;
                    });
                  } else if (widget.categoryFilter != RecipeCategory.other) {
                    _recipesToDisplay = recipes
                        .where(
                            (recipe) => recipe.category == widget.categoryFilter)
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
                    // sort recipeToDisplay by title then by subtitle
                    _recipesToDisplay.sort((a, b) {
                      if (a.title != b.title) {
                        return a.title.compareTo(b.title);
                      }
                      return a.subtitle.compareTo(b.subtitle);
                    });
                  }
        
                  if (_recipesToDisplay.isEmpty) {
                    String message = "";
                    if (widget.onlyFavorites) {
                      message = 'Vous n\'avez pas de favoris';
                    } else if (widget.history) {
                      message = 'Vous n\'avez pas encore cliqué sur une recette';
                    } else if (_keywords.isNotEmpty) {
                      message = 'Pas de recette pour les mots-clés recherchés';
                    } else {
                      message =
                          'Pas de recette (Je suis curieux de savoir comment vous avez fait pour arriver ici)';
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
                  return Material(
                    child: Scrollbar(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: _recipesToDisplay.length * 2 -
                            1, // Double the item count to include separators
                        itemBuilder: (BuildContext context, int index) {
                          // For even indices, return recipeTile
                          if (index.isEven) {
                            return recipeTile(_recipesToDisplay[index ~/ 2]);
                          } else {
                            // For odd indices, return a separator
                            return const SizedBox(height: 8);
                          }
                        },
                      ),
                    ),
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

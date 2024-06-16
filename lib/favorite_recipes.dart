import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteRecipes extends ChangeNotifier{
  List<String> favorites = [];

  void initFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    favorites = prefs.getStringList('favorites') ?? [];
    notifyListeners();
  }

  bool isFavorite(String recipeId) {
    return favorites.contains(recipeId);
  }

  void addFavorite(String recipeId) {
    favorites.add(recipeId);
    _saveFavorite(recipeId);
    notifyListeners();
  }

  void removeFavorite (String recipeId) {
    favorites.remove(recipeId);
    _removeSavedFavorite(recipeId);
    notifyListeners();
  }


  void _saveFavorite(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];
    favorites.add(id);
    prefs.setStringList('favorites', favorites);
  }

  void _removeSavedFavorite(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];
    favorites.remove(id);
    prefs.setStringList('favorites', favorites);
  }
}
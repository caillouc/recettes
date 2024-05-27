import 'package:flutter/material.dart';
import 'package:recettes/custom_icon.dart';

enum RecipeCategory {
  viande,
  poisson,
  legume,
  dessert,
  pain,
  apero,
  other;

  String getName() {
    switch (this) {
      case RecipeCategory.viande:
        return 'Viande';
      case RecipeCategory.poisson:
        return 'Poisson';
      case RecipeCategory.legume:
        return 'Légume';
      case RecipeCategory.dessert:
        return 'Dessert';
      case RecipeCategory.pain:
        return 'Pain';
      case RecipeCategory.apero:
        return 'Apéro';
      case RecipeCategory.other:
        return 'Autre';
    }
  }

  Color getColor() {
    switch (this) {
      case RecipeCategory.viande:
        return Colors.red;
      case RecipeCategory.poisson:
        return Colors.blue;
      case RecipeCategory.legume:
        return Colors.green;
      case RecipeCategory.dessert:
        return Colors.purple;
      case RecipeCategory.pain:
        return Colors.brown;
      case RecipeCategory.apero:
        return Colors.orange;
      case RecipeCategory.other:
        return Colors.black;
    }
  }

  Widget getIcon() {
    switch (this) {
      case RecipeCategory.viande:
        return CustomIcon.meat.getColorOutlinedIcon();
      case RecipeCategory.poisson:
        return CustomIcon.fish.getColorOutlinedIcon();
      case RecipeCategory.legume:
        return CustomIcon.carrot.getColorOutlinedIcon();
      case RecipeCategory.dessert:
        return CustomIcon.dessert.getColorOutlinedIcon();
      case RecipeCategory.pain:
        return CustomIcon.bread.getColorOutlinedIcon();
      case RecipeCategory.apero:
        return CustomIcon.apero.getColorOutlinedIcon();
      case RecipeCategory.other:
        return CustomIcon.other.getColorOutlinedIcon();
    }
  }
}

class Recipe {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final RecipeCategory category;

  const Recipe( {
      required this.id,
      required this.title,
      required this.subtitle,
      required this.description,
      required this.category});
}

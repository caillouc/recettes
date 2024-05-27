import 'package:flutter/material.dart';
import 'package:recettes/custom_icon.dart';

import 'package:recettes/return_state.dart';
import 'package:recettes/recipe.dart';
import 'package:recettes/main.dart';

class RecipeView extends StatefulWidget {
  final Recipe recipe;
  final bool isFavorite;
  final ReturnState returnState;

  const RecipeView({Key? key, required this.recipe, required this.isFavorite, required this.returnState})
      : super(key: key);

  @override
  State<RecipeView> createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        widget.returnState.returnPressed();
      },
      child: Card(
        shadowColor: Colors.transparent,
        margin: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.recipe.title,
                          style: const TextStyle(
                            fontSize: 35.0,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.visible,
                          softWrap: true,
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          widget.recipe.subtitle,
                          style: const TextStyle(
                            fontSize: 20.0,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: isFavorite
                        ? CustomIcon.favorite.getColorSolidBigIcon()
                        : CustomIcon.favorite.getColorOutlinedBigIcon(),
                    onPressed: () {
                      if (isFavorite) {
                        removeSavedFavorite(widget.recipe.id);
                      } else {
                        saveFavorite(widget.recipe.id);
                      }
                      setState(
                        () {
                          isFavorite = !isFavorite;
                        },
                      );
                      // Toggle favorite status here
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  widget.recipe.category.getIcon(),
                  const SizedBox(width: 8.0),
                  Text(
                    widget.recipe.category.getName(),
                    style: const TextStyle(fontSize: 20.0),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  // Set color to present the recipe as a piece of code
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 208, 208, 208),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    widget.recipe.description,
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

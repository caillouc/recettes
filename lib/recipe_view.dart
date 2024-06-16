import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:recettes/custom_icon.dart';
import 'package:recettes/recipe.dart';
import 'package:recettes/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecipeView extends StatefulWidget {
  final Recipe recipe;

  const RecipeView(
      {Key? key,
      required this.recipe})
      : super(key: key);

  @override
  State<RecipeView> createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  late double _scaleFactor = 1.0;
  double _baseScaleFactor = 1.0;
  late bool _snackBarActive;

  @override
  void initState() {
    super.initState();
    favoriteRecipes.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        _scaleFactor = prefs.getDouble('scaleFactor') ?? 1.0;
      });
    });
    _snackBarActive = false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        returnState.returnPressed();
      },
      child: Card(
        shadowColor: Colors.transparent,
        margin: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: AutoSizeText(
                      widget.recipe.title,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 35.0,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.visible,
                      softWrap: true,
                    ),
                  ),
                  IconButton(
                    icon: favoriteRecipes.isFavorite(widget.recipe.id)
                        ? CustomIcon.favorite.getColorSolidBigIcon()
                        : CustomIcon.favorite.getColorOutlinedBigIcon(),
                    onPressed: () {
                      HapticFeedback.heavyImpact();
                      if (favoriteRecipes.isFavorite(widget.recipe.id)) {
                        favoriteRecipes.removeFavorite(widget.recipe.id);
                      } else {
                        favoriteRecipes.addFavorite(widget.recipe.id);
                      }
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  widget.recipe.category.getIcon(),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: AutoSizeText(
                      maxLines: 1,
                      widget.recipe.subtitle,
                      style: const TextStyle(
                        fontSize: 20.0,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  SizedBox(
                    height: 30.0,
                    width: 30.0,
                    child: IconButton(
                      padding: const EdgeInsets.all(0.0),
                      iconSize: 30.0,
                      icon: const Icon(
                        Icons.help_outline,
                      ),
                      onPressed: () {
                        // if snackbar is not already on
                        if (_snackBarActive) {
                          return;
                        }
                        _snackBarActive = true;
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Pincez pour zoomer, Tapez deux fois pour réinitialiser',
                                  style: TextStyle(fontSize: 15.0),
                                ),
                                duration: Duration(seconds: 3),
                              ),
                            )
                            .closed
                            .then((reason) {
                          setState(() {
                            _snackBarActive = false;
                          });
                        });
                      },
                    ),
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
                  child: GestureDetector(
                    onScaleStart: (details) {
                      _baseScaleFactor = _scaleFactor;
                    },
                    onScaleEnd: (details) {
                      SharedPreferences.getInstance().then((prefs) {
                        prefs.setDouble('scaleFactor', _scaleFactor);
                      });
                    },
                    onScaleUpdate: (details) {
                      setState(() {
                        _scaleFactor =
                            (_baseScaleFactor * details.scale).clamp(0.8, 3.0);
                      });
                    },
                    onDoubleTap: () => setState(() {
                      _scaleFactor = 1.0;
                      SharedPreferences.getInstance().then((prefs) {
                        prefs.setDouble('scaleFactor', _scaleFactor);
                      });
                    }),
                    child: SelectionArea(
                      child: Text(
                        widget.recipe.description,
                        style: TextStyle(
                          fontSize: 16.0 * _scaleFactor,
                        ),
                      ),
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

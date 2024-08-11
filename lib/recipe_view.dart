import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:recettes/custom_icon.dart';
import 'package:recettes/recipe.dart';
import 'package:recettes/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';

class RecipeView extends StatefulWidget {
  final Recipe recipe;

  const RecipeView({super.key, required this.recipe});

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
      onPopInvokedWithResult: (didPop, result) {
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
                      style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.visible,
                      softWrap: true,
                    ),
                  ),
                  IconButton(
                    icon: favoriteRecipes.isFavorite(widget.recipe.id)
                        ? CustomIcon.favorite.getColorSolidBigIcon(context)
                        : CustomIcon.favorite.getColorOutlinedBigIcon(context),
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
                  widget.recipe.category.getIcon(context),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: AutoSizeText(
                      maxLines: 1,
                      widget.recipe.subtitle,
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        fontSize: 20.0,
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
                                  'Pincez pour zoomer\nTapez deux fois pour réinitialiser',
                                  style: TextStyle(fontSize: 18.0),
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
                  const SizedBox(width: 10.0),
                  SizedBox(
                    height: 30.0,
                    width: 30.0,
                    child: IconButton(
                      padding: const EdgeInsets.all(0.0),
                      iconSize: 30.0,
                      icon: const Icon(
                        Icons.ios_share,
                      ),
                      onPressed: () {
                        Share.share("${widget.recipe.title} \n\n ${widget.recipe.description}", subject: widget.recipe.title);
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
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: const BorderRadius.all(Radius.circular(20))),
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
                    child: Text(
                      widget.recipe.description,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 16.0 * _scaleFactor,
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

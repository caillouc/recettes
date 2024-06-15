import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:recettes/category_button.dart';
import 'package:recettes/custom_text_field.dart';
import 'package:recettes/return_state.dart';
import 'package:recettes/recipe.dart';

class HomePage extends StatelessWidget {
  final ReturnState returnState;

  const HomePage({Key? key, required this.returnState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.transparent,
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: AutoSizeText(
                maxLines: 1,
                'Recettes GM',
                style: TextStyle(
                  fontSize: 50.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 50.0),
            CustomTextField(returnState: returnState),
            const SizedBox(height: 16.0),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CategoryButton(
                        category: RecipeCategory.viande,
                        returnState: returnState,
                      ),
                      const SizedBox(height: 16.0),
                      CategoryButton(
                        category: RecipeCategory.legume,
                        returnState: returnState,
                      ),
                      const SizedBox(height: 16.0),
                      CategoryButton(
                        category: RecipeCategory.apero,
                        returnState: returnState,
                      ),
                    ],
                  ),
                  const SizedBox(width: 16.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CategoryButton(
                        category: RecipeCategory.poisson,
                        returnState: returnState,
                      ),
                      const SizedBox(height: 16.0),
                      CategoryButton(
                        category: RecipeCategory.dessert,
                        returnState: returnState,
                      ),
                      const SizedBox(height: 16.0),
                      CategoryButton(
                        category: RecipeCategory.pain,
                        returnState: returnState,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

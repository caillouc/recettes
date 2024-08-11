import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:recettes/category_button.dart';
import 'package:recettes/custom_text_field.dart';
import 'package:recettes/recipe.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      shadowColor: Colors.transparent,
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: AutoSizeText(
                maxLines: 1,
                'Recettes GM',
                style: TextStyle(
                  fontSize: 50.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 50.0),
            CustomTextField(),
            SizedBox(height: 16.0),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CategoryButton(
                        category: RecipeCategory.viande,
                      ),
                      SizedBox(height: 16.0),
                      CategoryButton(
                        category: RecipeCategory.legume,
                      ),
                      SizedBox(height: 16.0),
                      CategoryButton(
                        category: RecipeCategory.apero,
                      ),
                    ],
                  ),
                  SizedBox(width: 16.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CategoryButton(
                        category: RecipeCategory.poisson,
                      ),
                      SizedBox(height: 16.0),
                      CategoryButton(
                        category: RecipeCategory.dessert,
                      ),
                      SizedBox(height: 16.0),
                      CategoryButton(
                        category: RecipeCategory.pain,
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

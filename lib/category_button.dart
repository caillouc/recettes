import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:recettes/recipe.dart';
import 'package:recettes/main.dart';
import 'package:recettes/recipes_list.dart';

class CategoryButton extends StatelessWidget {
  final RecipeCategory category;

  const CategoryButton({Key? key, required this.category})
      : super(key: key);

  @override
  build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth * 0.4,
      height: screenWidth * 0.2,
      child: ElevatedButton(
        onPressed: () {
          returnState.needReturn();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => RecipeList(
                categoryFilter: category,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(color: category.getColor(), width: 2.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 8.0),
            category.getIcon(context), // Assuming getIcon() returns IconData
            const SizedBox(width: 8.0),
            AutoSizeText(
              category.getName(),
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8.0),
          ],
        ),
      ),
    );
  }
}

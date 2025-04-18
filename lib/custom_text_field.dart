import 'package:flutter/material.dart';

import 'package:recettes/recipes_list.dart';
import 'package:recettes/main.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({super.key});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _submitSearch() {
    if (_textEditingController.text.trim().isEmpty) {
      _textEditingController.clear();
      return;
    }
    List<String> keywords = _textEditingController.text.trim().split(' ');
    // remove duplicates and empty strings and keep the 10 first keywords
    keywords = keywords.toSet().where((element) => element.isNotEmpty).take(10).toList();
    returnState.needReturn();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RecipeList(
          keywordsFilter: keywords,
        ),
      ),
    );
  }

  @override
  build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Search button
        SizedBox(
          height: 50.0,
          width: 50.0,
          child: IconButton(
            icon: const Icon(Icons.search),
            onPressed: _submitSearch,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
                side: BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: _textEditingController,
            onSubmitted: (_) => _submitSearch(),
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
              ),
              border: const OutlineInputBorder(),
              hintText: 'Tapez vos ingrédients',
              labelText: 'On mange quoi ?',
              labelStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
              // add clear icon
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _textEditingController.clear();
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
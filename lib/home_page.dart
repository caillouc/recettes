import 'package:flutter/material.dart';
import 'package:recettes/return_state.dart';
import 'package:recettes/recipe.dart';
import 'package:recettes/recipes_list.dart';

class HomePage extends StatefulWidget {
  final ReturnState returnState;

  const HomePage({Key? key, required this.returnState}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  Widget _categoryButton(RecipeCategory category) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth * 0.4,
      height: 100.0,
      child: ElevatedButton(
        onPressed: () {
          widget.returnState.needReturn();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => RecipeList(
                returnState: widget.returnState,
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
          foregroundColor: Colors.black,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            category.getIcon(), // Assuming getIcon() returns IconData
            const SizedBox(width: 8.0),
            Text(
              category.getName(),
              style: const TextStyle(
                fontSize: 18.0, // Increase text size
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitSearch() {
    if (_textEditingController.text.trim().isEmpty) {
      _textEditingController.clear();
      return;
    }
    List<String> keywords = _textEditingController.text.trim().split(' ');
    widget.returnState.needReturn();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RecipeList(
          returnState: widget.returnState,
          keywordsFilter: keywords,
        ),
      ),
    );
  }

  Widget _customTextField() {
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
                side: const BorderSide(color: Colors.amber, width: 2.0),
              ),
              foregroundColor: Colors.black,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: _textEditingController,
            onSubmitted: (_) => _submitSearch(),
            decoration: InputDecoration(
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.amber, width: 2.0),
              ),
              border: const OutlineInputBorder(),
              hintText: 'Tappez vos ingrédients',
              labelText: 'On mange quoi ?',
              labelStyle: const TextStyle(color: Colors.grey),
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
              child: Text(
                'Recettes GM',
                style: TextStyle(
                  fontSize: 50.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 50.0),
            _customTextField(),
            const SizedBox(height: 16.0),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _categoryButton(RecipeCategory.viande),
                      const SizedBox(height: 16.0),
                      _categoryButton(RecipeCategory.legume),
                      const SizedBox(height: 16.0),
                      _categoryButton(RecipeCategory.apero),
                    ],
                  ),
                  const SizedBox(width: 16.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _categoryButton(RecipeCategory.poisson),
                      const SizedBox(height: 16.0),
                      _categoryButton(RecipeCategory.dessert),
                      const SizedBox(height: 16.0),
                      _categoryButton(RecipeCategory.pain),
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

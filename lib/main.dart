import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:recettes/home_page.dart';
import 'package:recettes/recipes_list.dart';
import 'package:recettes/return_state.dart';
import 'package:recettes/recipe.dart';
import 'package:recettes/custom_icon.dart';

void main() {
  runApp(const RecetteApp());
}

List<Recipe> recipes = List.empty();

class RecetteApp extends StatelessWidget {
  const RecetteApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MediaQuery.withNoTextScaling(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Recettes GM',
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.amber,
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.amber,
            foregroundColor: Colors.black,
          ),
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  int _currentPageIndex = 0;
  final ReturnState _returnState = ReturnState();
  late BuildContext _navigatorContext;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _returnState.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    fetchRecipesFromJson().then((value) {
      recipes = value;
    });
    _pageController = PageController(initialPage: _currentPageIndex);
  }

  Future<List<Recipe>> fetchRecipesFromJson() async {
    // Read the JSON file
    String jsonString = await rootBundle.loadString('assets/recipes.json');

    // Parse JSON data
    List<dynamic> jsonList = json.decode(jsonString);

    // Convert JSON data into Recipe objects
    List<Recipe> recipes = jsonList.map((json) {
      return Recipe(
        id: json['id'],
        title: json['name'],
        subtitle: json['subtitle'],
        description: json['content'],
        category: getRecipeCategory(json['category']),
      );
    }).toList();

    return recipes;
  }

  RecipeCategory getRecipeCategory(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'viande':
        return RecipeCategory.viande;
      case 'poisson':
        return RecipeCategory.poisson;
      case 'legume':
        return RecipeCategory.legume;
      case 'dessert':
        return RecipeCategory.dessert;
      case 'pain':
        return RecipeCategory.pain;
      case 'apero':
        return RecipeCategory.apero;
      default:
        return RecipeCategory.other;
    }
  }

  void _onDestinationSelected(int index) {
    HapticFeedback.selectionClick();
    if (_currentPageIndex != index) {
      if (!_returnState.returnNeeded()){
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        _pageController.jumpToPage(index);
      }
    }
    _onPageChanged(index);
  }

  void _onPageChanged(int index) {
    if (_currentPageIndex != index) {
      setState(() {
        _currentPageIndex = index;
      });
    }
    while (Navigator.of(_navigatorContext).canPop()) {
      Navigator.of(_navigatorContext).pop();
    }

    _returnState.reset();
  }

  Widget _buildNavigator(Widget page) {
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) {
            _navigatorContext = context;
            return page;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: _onDestinationSelected,
        indicatorColor: Colors.amber,
        selectedIndex: _currentPageIndex,
        destinations: <Widget>[
          NavigationDestination(
            icon: CustomIcon.home.getBlackOutlinedIcon(),
            selectedIcon: CustomIcon.home.getBlackSolidIcon(),
            label: 'Home',
          ),
          NavigationDestination(
            icon: CustomIcon.list.getBlackOutlinedIcon(),
            selectedIcon: CustomIcon.list.getBlackSolidIcon(),
            label: 'Toutes les recettes',
          ),
          NavigationDestination(
            icon: CustomIcon.favorite.getBlackOutlinedIcon(),
            selectedIcon: CustomIcon.favorite.getBlackSolidIcon(),
            label: 'Favoris',
          ),
        ],
      ),
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          // disable swipe when needReturn is true
          physics: _returnState.returnNeeded()
              ? const NeverScrollableScrollPhysics()
              : const AlwaysScrollableScrollPhysics(),
          onPageChanged: _onPageChanged,
          children: <Widget>[
            _buildNavigator(HomePage(returnState: _returnState)),
            _buildNavigator(RecipeList(returnState: _returnState)),
            _buildNavigator(RecipeList(returnState: _returnState, onlyFavorites: true)),
          ],
        ),
      ),
      floatingActionButton: _returnState.returnNeeded()
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(_navigatorContext).pop();
              },
              child: const Icon(Icons.arrow_back),
            )
          : null,
      resizeToAvoidBottomInset: false,
    );
  }
}

void saveFavorite(String id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> favorites = prefs.getStringList('favorites') ?? [];
  favorites.add(id);
  prefs.setStringList('favorites', favorites);
}

void removeSavedFavorite(String id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> favorites = prefs.getStringList('favorites') ?? [];
  favorites.remove(id);
  prefs.setStringList('favorites', favorites);
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recettes/favorite_recipes.dart';

import 'dart:convert';

import 'package:recettes/home_page.dart';
import 'package:recettes/recipes_list.dart';
import 'package:recettes/return_state.dart';
import 'package:recettes/recipe.dart';
import 'package:recettes/custom_icon.dart';
import 'package:recettes/settings_state.dart';
import 'package:recettes/settings.dart';

void main() {
  runApp(const RecetteApp());
}

List<Recipe> recipes = List.empty();
final ReturnState returnState = ReturnState();
final FavoriteRecipes favoriteRecipes = FavoriteRecipes();
final SettingsState settings = SettingsState();

class RecetteApp extends StatefulWidget {
  const RecetteApp({super.key});

  @override
  State<RecetteApp> createState() => _RecetteAppState();
}

class _RecetteAppState extends State<RecetteApp> {

  @override
  void initState() {
    super.initState();
    favoriteRecipes.initFavorites();
    settings.init();
    settings.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MediaQuery.withNoTextScaling(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Recettes GM',
        // add dark mode
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.amber,
            dynamicSchemeVariant: DynamicSchemeVariant.monochrome,
            brightness: Brightness.light,
          ),
          textTheme: Typography.blackMountainView,
          primaryColor: Colors.amber,
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.amber,
            foregroundColor: Colors.black,
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.amber,
              dynamicSchemeVariant: DynamicSchemeVariant.monochrome,
              brightness: Brightness.dark),
          textTheme: Typography.whiteMountainView,
          primaryColor: Colors.amber,
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.amber,
            foregroundColor: Colors.black,
          ),
        ),
        themeMode: settings.getThemeMode(),
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
  late BuildContext _navigatorContext;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    returnState.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    settings.addListener(() {
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
      setState(() {
        _currentPageIndex = index;
      });

      // do the animation
      _pageController.jumpToPage(index);
    }

    while (Navigator.of(_navigatorContext).canPop()) {
      Navigator.of(_navigatorContext).pop();
    }

    returnState.reset();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPageIndex = index;
    });
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
      floatingActionButtonLocation: returnState.returnNeeded()
          ? FloatingActionButtonLocation.endFloat
          : FloatingActionButtonLocation.startFloat,
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: _onDestinationSelected,
        indicatorColor: Theme.of(context).primaryColor,
        selectedIndex: _currentPageIndex,
        destinations: settings.showHistory() ? <Widget>[
          NavigationDestination(
            icon: CustomIcon.home.getBlackOutlinedIcon(context),
            selectedIcon: CustomIcon.home.getBlackSolidIcon(context),
            label: 'Home',
          ),
          NavigationDestination(
            icon: CustomIcon.list.getBlackOutlinedIcon(context),
            selectedIcon: CustomIcon.list.getBlackSolidIcon(context),
            label: 'Recettes',
          ),
          NavigationDestination(
            icon: CustomIcon.history.getBlackOutlinedIcon(context),
            selectedIcon: CustomIcon.history.getBlackSolidIcon(context),
            label: 'Historique',
          ),
          NavigationDestination(
            icon: CustomIcon.favorite.getBlackOutlinedIcon(context),
            selectedIcon: CustomIcon.favorite.getBlackSolidIcon(context),
            label: 'Favoris',
          ),
        ] : <Widget>[
          NavigationDestination(
            icon: CustomIcon.home.getBlackOutlinedIcon(context),
            selectedIcon: CustomIcon.home.getBlackSolidIcon(context),
            label: 'Home',
          ),
          NavigationDestination(
            icon: CustomIcon.list.getBlackOutlinedIcon(context),
            selectedIcon: CustomIcon.list.getBlackSolidIcon(context),
            label: 'Recettes',
          ),
          NavigationDestination(
            icon: CustomIcon.favorite.getBlackOutlinedIcon(context),
            selectedIcon: CustomIcon.favorite.getBlackSolidIcon(context),
            label: 'Favoris',
          ),
        ],
      ),
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          // disable swipe when needReturn is true
          physics: returnState.returnNeeded()
              ? const NeverScrollableScrollPhysics()
              : const AlwaysScrollableScrollPhysics(),
          onPageChanged: _onPageChanged,
          children: settings.showHistory()
              ? <Widget>[
                  _buildNavigator(const HomePage()),
                  _buildNavigator(const RecipeList()),
                  _buildNavigator(const RecipeList(history: true)),
                  _buildNavigator(const RecipeList(onlyFavorites: true)),
                ]
              : [
                  _buildNavigator(const HomePage()),
                  _buildNavigator(const RecipeList()),
                  _buildNavigator(const RecipeList(onlyFavorites: true)),
                ],
        ),
      ),
      floatingActionButton: returnState.returnNeeded()
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(_navigatorContext).pop();
              },
              child: const Icon(Icons.arrow_back),
            )
          : _currentPageIndex == 0
              ? FloatingActionButton.small(
                  backgroundColor: Theme.of(context).primaryColor,
                  onPressed: () {
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return const Settings();
                      },
                    );
                  },
                  child: const Icon(Icons.settings),
                )
              : null,
      resizeToAvoidBottomInset: false,
    );
  }
}

# Recipes App

A new Flutter that nicely displays recipes in a mobile app. Theses recipes can be loaded thanks to a `json` file. 

## Features 

* Research recipes by keywords
* Organize recipes by categories
* Save your favorite recipes
* History of visited recipes
* Easy simple interface to display the recipe itself

## Example

An example of the recipes app can be found on the app strore ([Recette GM](https://apps.apple.com/app/id6503914351)). The app is crazy expensive on purpose, I did not want my family's recipes to be accessible by everyone (my relatives and friends can use a promo code). 

## How to use

Simply add a `assets/recipes.json` file with your recipes. The file should be formated as follow : 

```json
[
    {
        "name": "Name Of Your Recipes",
        "subtitle": "Any Subtitle",
        "category": "category",
        "id": "unique id for the recipe",
        "content": "The content of the recipes itsefl"
    },
    {
        "name": "Spaghetti Carbonara",
        "subtitle": "Chat GPT generated recipes",
        "category": "Pasta",
        "id": "0000001",
        "content": "Ingredients\n\n200g spaghetti\n- 100g pancetta or guanciale, diced\n- 2 large eggs\n- 50g Pecorino Romano cheese, grated\n- 50g Parmesan cheese, grated\n- 2 cloves garlic, peeled and left whole\n- Salt and black pepper to taste\n- Fresh parsley, chopped (optional)\n\n\nInstructions\n\nCook the Spaghetti:\nBring a large pot of salted water to a boil. Add spaghetti and cook until al dente. Reserve 1 cup of pasta water, then drain.\nrepare the Pancetta:\nHeat a skillet over medium heat. Add diced pancetta and whole garlic cloves. Cook until pancetta is crispy, about 5-7 minutes. Remove garlic cloves.\n\n- Mix Cheese and Eggs:\nIn a bowl, whisk eggs, Pecorino Romano, and Parmesan until combined.\n\n- Combine and Serve:\nAdd spaghetti to the skillet with pancetta. Remove from heat, pour in egg mixture, and stir continuously. Add reserved pasta water if needed. Season with salt and pepper. Serve immediately, garnished with extra cheese and parsley.\n\n\nTips\n\n- Remove skillet from heat before adding egg mixture to prevent scrambling.\n- Use guanciale for richer flavor.\n- Freshly ground black pepper is essential."
    }
]
```

In order to customize the app to your need you might need to : 
* Translate displayed text in english
* Change the title in `lib/home_page.dart`
* Change the categories to your need in `lib/recipe.dart`
* Upalod your icons (mine are not free so I cannot publish them), or use flutter's
* Add your `assets/recipes.json`

Now, you should be mostly good ! 

> Feel free to open an issue, for any questions/suggestions

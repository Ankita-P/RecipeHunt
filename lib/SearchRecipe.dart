import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class Recipe{
  final int RecipeID;
  final String RecipeName;
  final String RecipeImage;
  final int usedIngredients;
  final int missedIngredients;
  final int RecipeLikes;

  Recipe({this.RecipeID, this.RecipeName, this.RecipeImage, this.usedIngredients, this.missedIngredients, this.RecipeLikes});

  factory Recipe.fromJSON(Map<String, dynamic> json) {
    return Recipe(RecipeID: json['id'], RecipeName: json['title'], RecipeImage: json['image'], usedIngredients: json['usedIngredientCount'], missedIngredients: json['missedIngredientCount'], RecipeLikes: json['likes']);
  }
}

class SearchRecipe extends StatelessWidget {

  List<String> data = [];


  SearchRecipe({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Hunt',
      home: MySearchList(this.data),
    );
  }
}

// Define a custom Form widget.
class MySearchList extends StatefulWidget {
  List<String> ingredientsList;
  MySearchList(List<String> data)
  {
    this.ingredientsList = data;
  }
  @override
  _MySearchListState createState() => _MySearchListState(this.ingredientsList);
}

class _MySearchListState extends State<MySearchList> {
  List<Recipe> recipeList = [];
  List<String> selectedIngredients = [];
  _MySearchListState(List<String> list)
  {
    this.selectedIngredients = list;
  }

  @override
  void initState() {
    getRecipes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recipe Hunt"),
      ),
      body: Column(
        children: <Widget>[
          new Text(
              "Based on the ingredients you picked, we found these matching recipes!",
          ),
          new Container(
            child: new ListView.builder(padding: const EdgeInsets.all(8),
                shrinkWrap: true,
                itemCount: recipeList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 50,
                    color: Colors.transparent,
                    child: Center(child: Text("${recipeList[index].RecipeName}")),
                  );
                }
            ),
            ),

        ],
      )
    );
  }

  Future<List<Recipe>> getRecipes() async {

    String ingredients = this.selectedIngredients.join(",");
    print(ingredients);
    String url =
        "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/findByIngredients?number=5&ranking=1&ignorePantry=false&ingredients="+ingredients;
    Map<String, String> headers = {
      'x-rapidapi-host': 'spoonacular-recipe-food-nutrition-v1.p.rapidapi.com',
      'x-rapidapi-key': '318926f9a6msh9a7ae0daa088839p1d3650jsn0140476fdbd4'
    };

    final response = await http.get(url, headers: headers);
  this.setState((){
    List jsonResponse = json.decode(response.body);
    print(jsonResponse);
    recipeList = jsonResponse
        .map((ingredients) => new Recipe.fromJSON(ingredients))
        .toList();
  });

  print(recipeList[1].RecipeName);

    return recipeList;
  }
}
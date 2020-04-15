import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:progress_indicators/progress_indicators.dart';
import 'package:recipehunt/ShowRecipe.dart';


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
    return WillPopScope(
      onWillPop: (){
        Navigator.pop(context);
      },
      child: Scaffold(
        body: MySearchList(this.data),
      ),
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
    final TextStyle textstyle =
    TextStyle(fontFamily: 'Dosis', fontSize: 18.0);
    while(recipeList.length == 0)
    {
      return Scaffold(
          appBar: AppBar(
            title: new Center(child: new Text("Recipe Hunt")),
            backgroundColor: Colors.lightGreen,
            leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.white,),
              onPressed: () {
                Navigator.pop(context);
              },),
          ),
          body: Center(
            child: JumpingText('Loading..')
          )
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: new Center( child: Text("Recipe Hunt")),
        backgroundColor: Colors.lightGreen,
      ),
      body: new Container(
        child: new SingleChildScrollView(
              child: new ConstrainedBox(
                constraints: new BoxConstraints(),
                child: new

              Column(
                children: <Widget>[
                  new Container(
                    padding: EdgeInsets.all(8.0),
                    margin: EdgeInsets.all(8.0),
                    child: new Text(
                      "Based on the ingredients you picked, we found these matching recipes!",
                      style: textstyle,
                    ),
                  ),

                  new ListView.builder(padding: const EdgeInsets.all(8),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: recipeList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return new CustomListItemTwo(
                          recipeID: recipeList[index].RecipeID,
                          thumbnail: Container(
                            margin: EdgeInsets.only(left: 5.0),
                            decoration: const BoxDecoration(color: Colors.transparent),
                            child: Image.network('${recipeList[index].RecipeImage}'),
                          ),
                          title: '${recipeList[index].RecipeName}',
                          usedIngredients: '${recipeList[index].usedIngredients}',
                          missedIngredients: '${recipeList[index].missedIngredients}',
                          likes: '${recipeList[index].RecipeLikes}',
                        );
                      }
                  ),
                ],
              ),
              )
            )
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

class _ArticleDescription extends StatelessWidget {
  _ArticleDescription({
    Key key,
    this.title,
    this.usedIngredients,
    this.missedIngredients,
    this.imageURL,
    this.recipeLikes,
  }) : super(key: key);

  final String title;
  final String usedIngredients;
  final String missedIngredients;
  final String imageURL;
  final String recipeLikes;

  @override
  Widget build(BuildContext context) {
    final TextStyle listHeadingStyle =
    TextStyle(fontFamily: 'Dosis', fontSize: 14.0, fontWeight: FontWeight.bold,);
    final TextStyle listStyle =
    TextStyle(fontFamily: 'Dosis', fontSize: 12.0, fontWeight: FontWeight.bold,color: Colors.black54);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '$title',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: listHeadingStyle
              ),
              const Padding(padding: EdgeInsets.only(bottom: 5.0)),
              Text(
                'Used Ingredients: $usedIngredients',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: listStyle
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                'Missing Ingredients: $missedIngredients',
                style: listStyle
              ),
              Text(
                '$recipeLikes ★',
                style: listStyle
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomListItemTwo extends StatelessWidget {
  CustomListItemTwo({
    Key key,
    this.recipeID,
    this.thumbnail,
    this.title,
    this.usedIngredients,
    this.missedIngredients,
    this.likes,
  }) : super(key: key);

  final int recipeID;
  final Widget thumbnail;
  final String title;
  final String usedIngredients;
  final String missedIngredients;
  final String likes;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: Colors.lightGreen,
        highlightColor: Colors.black12,
      onTap: (){

          final result =  Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ShowRecipe(
                    data: recipeID,
                  )));
          print(result);
      },
        child:Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: SizedBox(
          height: 100,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1.0,
                child: thumbnail,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
                  child: _ArticleDescription(
                    title: title,
                    usedIngredients: usedIngredients,
                    missedIngredients: missedIngredients,
                    recipeLikes: likes,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    )
    );
  }

}

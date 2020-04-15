  import 'dart:convert';

  import 'package:flutter/cupertino.dart';
  import 'package:flutter/material.dart';
  import 'package:http/http.dart' as http;
  import 'dart:io';
  import 'package:progress_indicators/progress_indicators.dart';
  class ShowRecipe extends StatelessWidget {

    int data = 0;


    ShowRecipe({Key key, this.data}) : super(key: key);

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: MyRecipe(this.data),
      );
    }
  }

  // Define a custom Form widget.
  class MyRecipe extends StatefulWidget {
    int recipeID = 0;

    MyRecipe(int data) {
//      print(recipeID);
      this.recipeID = data;
    }

    @override
    _MyRecipeState createState() => _MyRecipeState(this.recipeID);
  }

  class _MyRecipeState extends State<MyRecipe> {
    RecipeDetails recipeInfo = new RecipeDetails();
    int selectedRecipeID = 0;

    _MyRecipeState(int id) {
      this.selectedRecipeID = id;
    }

    @override
    void initState() {
      getRecipes();
      super.initState();
    }

    void getRecipes() async {


      String url =
          "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/$selectedRecipeID/information";
      Map<String, String> headers = {
        'x-rapidapi-host': 'spoonacular-recipe-food-nutrition-v1.p.rapidapi.com',
        'x-rapidapi-key': '318926f9a6msh9a7ae0daa088839p1d3650jsn0140476fdbd4'
      };

      final response = await http.get(url, headers: headers);
      this.setState((){
        var jsonResponse = json.decode(response.body);
        print(jsonResponse);

//        recipeInfo = jsonResponse
//            .map((ingredients) => new RecipeDetails.fromJSON(jsonResponse))
//            .toList();

        recipeInfo.recipeTitle = jsonResponse["title"];
        recipeInfo.recipeImage = jsonResponse["image"];
        recipeInfo.servings = jsonResponse["servings"];
        recipeInfo.timeToCook = jsonResponse["readyInMinutes"];
        print(recipeInfo);
        recipeInfo.ingredientsList = jsonResponse['extendedIngredients'];
        recipeInfo.instructionsList = jsonResponse['analyzedInstructions'][0]['steps'];
        recipeInfo.ingredientsCount = recipeInfo.ingredientsList.length;
      });


      print(recipeInfo.recipeTitle);
      print(recipeInfo.instructionsList[1]['step']);
//      return recipeList;
    }


    @override
    Widget build(BuildContext context) {
      final TextStyle listHeadingStyle =
      TextStyle(fontFamily: 'Dosis', fontSize: 18.0, fontWeight: FontWeight.bold,);
      final TextStyle listStyle =
      TextStyle(fontFamily: 'Dosis', fontSize: 14.0,color: Colors.black);
      final InputDecoration decoration = InputDecoration(
        border: OutlineInputBorder(),
      );


      while(recipeInfo.recipeTitle == null)
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
          title: new Center(child: new Text("Recipe Hunt")),
          backgroundColor: Colors.lightGreen,
          leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.pop(context);
          },),
        ),
        body:
           SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: new ConstrainedBox(
              constraints: BoxConstraints(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    margin: EdgeInsets.all(8.0),
                    child: Center(
                      child: new Text(recipeInfo.recipeTitle??'****',
                        style: listHeadingStyle,
                      ),
                    ),
                  ),
                  new Container(
                    margin: EdgeInsets.all(8.0),
                    child: recipeInfo.recipeImage == null ? new Image.asset('assets/images/cookingpot.png') : new Image.network(recipeInfo.recipeImage),
                  ),
                  new Container(
                    padding: EdgeInsets.all(10.0),
                      color: Colors.black12,
                      child: Row(

                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                       child: Row(children: <Widget>[
                      Text('${recipeInfo.ingredientsCount??'***'}', style: TextStyle(fontFamily: 'Dosis', fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.bold)),
                      Text(" ingredients", style: listStyle,)
                      ]
                  )
                      ),
                      Container(
                        child: Row(children: <Widget>[
                          Text("${recipeInfo.servings??'***'}", style: TextStyle(fontFamily: 'Dosis', fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.bold)),
                          Text(" servings", style: listStyle,)
                        ]
                        )
                      ),
                      Container(
                        child: Row(children: <Widget>[
                          Text("${recipeInfo.timeToCook??'***'}", style: TextStyle(fontFamily: 'Dosis', fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.bold)),
                          Text(" minutes", style: listStyle,)
                        ]
                        )
                      )
                    ],
                  )
                  ),
                  new Container(
                    padding: EdgeInsets.all(8.0),
                    margin: EdgeInsets.all(8.0),
                    child: Center(
                      child: new Text('INGREDIENTS',
                        style: listHeadingStyle,
                      ),
                    ),
                  ),
                  
                  new ListView.builder(padding: const EdgeInsets.all(8),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: recipeInfo.ingredientsCount??1,
                      itemBuilder: (BuildContext context, int index) {
                        return new Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                            child: new Text('${String.fromCharCode(0x2022)} ${recipeInfo.ingredientsList[index]['originalString']??'***'}', style: listStyle,)
                        );
                      }
                  ),
                  new Container(
                    padding: EdgeInsets.all(8.0),
                    margin: EdgeInsets.all(8.0),
                    child: Center(
                      child: new Text('INSTRUCTIONS',
                        style: listHeadingStyle,
                      ),
                    ),
                  ),
                  new ListView.builder(padding: const EdgeInsets.all(8),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: recipeInfo.instructionsList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return new Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                            child: new Text('${String.fromCharCode(0x2022)} ${recipeInfo.instructionsList[index]['step']??'***'}', style: listStyle,)
                        );
                      }
                  ),
                ],
              ),
            ),
        ),
      );
    }

  }

  class RecipeDetails{
    String recipeTitle="";
    String recipeImage="";
    int servings=0;
    int ingredientsCount =0;
    int timeToCook=0;
    List ingredientsList = [];
    List instructionsList = [];

    RecipeDetails({this.recipeTitle, this.recipeImage, this.servings, this.timeToCook});

    factory RecipeDetails.fromJSON(Map<String, dynamic> json) {
      return RecipeDetails(recipeTitle: json['title'], recipeImage: json['image'], timeToCook: json['readyInMinutes'], servings: json['servings']);
    }
  }
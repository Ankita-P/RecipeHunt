import 'dart:convert';

import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:recipehunt/Info.dart';

import 'SearchRecipe.dart';

void main() => runApp(MyMainApp());

class Ingredients {
  final String ingredientName;
  final String imageName;

  Ingredients({this.ingredientName, this.imageName});

  factory Ingredients.fromJSON(Map<String, dynamic> json) {
    return Ingredients(ingredientName: json['name'], imageName: json['image']);
  }
}

class MyMainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Hunt',
      home: MySearchForm(),
    );
  }
}

// Define a custom Form widget.
class MySearchForm extends StatefulWidget {
  @override
  _MySearchFormState createState() => _MySearchFormState();
}

// Define a corresponding State class.
// This class holds data related to the Form.
class _MySearchFormState extends State<MySearchForm> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  String textValue = 'a';
  List<Ingredients> futureIngredients =[];
  var _itemSelection = new List<bool>(10);
  String selectedValues = "";

  var namesGrowable = new List<String>();

  @override
  void initState() {
    super.initState();
    fetchList('a');
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Recipe Hunt'),
        ),
        backgroundColor: Colors.lightGreen,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  final result =  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AppInfo()));
                  print(result);
                },
                child: Icon(
                  Icons.info_outline,
                  size: 26.0,
                ),
              )
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: searchRecipes,
        child: Text('Next'),
      ),
      body:Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: new AssetImage('assets/images/screen11.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: <Widget>[
              new Container(
                padding: EdgeInsets.all(8.0),
                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.black12
                ),
                child: new TextField(
                  decoration: InputDecoration(
                      hintText: 'Search Ingredients',
                      icon: new Icon(Icons.search)
                  ),
                  onChanged: (text){
                    fetchList(text);
                  },
                ),
              ),
              new Container(
                padding: EdgeInsets.all(8.0),
                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                width: MediaQuery.of(context).copyWith().size.width,
                color: Colors.white,
                child: new Column(
                  children: <Widget>[
                    new Text('Selected Ingredients'),
                    new Container(
                        padding: EdgeInsets.all(8.0),
                      child: Text(namesGrowable.join(", "))
                    )
                  ],
                ),
              ),
              new Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: futureIngredients.length??0,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 2),
                          color: _itemSelection[index]
                              ? Colors.lightGreen[100]
                              : Colors.white70,
                          child: ListTile(
                              leading: Container(
                                width: 50,
                                height: 50,
                                child: Image.network(
                                  "https://spoonacular.com/cdn/ingredients_100x100/${futureIngredients[index].imageName}",
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                              title:
                              Text(futureIngredients[index].ingredientName),
                              onTap: () {
                                if (namesGrowable.contains(
                                    futureIngredients[index].ingredientName)) {
                                  namesGrowable.remove(
                                      futureIngredients[index].ingredientName);
                                  selectedValues.replaceAll(
                                      '${futureIngredients[index].ingredientName}',
                                      "");
                                  selectedValues = "";
                                  selectedValues = namesGrowable.join(",");

                                  print(namesGrowable);
                                  print(selectedValues);
                                  setState(() => _itemSelection[index] =
                                  !_itemSelection[index]);
                                } else {
                                  namesGrowable.add(
                                      futureIngredients[index].ingredientName);

                                  selectedValues = "";
                                  selectedValues = namesGrowable.join(", ");
                                  print(namesGrowable);
                                  setState(() => _itemSelection[index] =
                                  !_itemSelection[index]);
                                }
                              }),
                        );

                      }
                  )
              )
            ],
          )
      ),
    );
  }

  void searchRecipes() {
//    var route = new MaterialPageRoute(
//      builder: (BuildContext context) =>
//      new SecondRoute(key: namesGrowable),
//    );
//    Navigator.of(context).push(route);

    final result =  Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SearchRecipe(
              data: namesGrowable,
            )));
    print(result);
  }

  Future<List<Ingredients>> fetchList(String text) async {
    String url =
        "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/food/ingredients/autocomplete?number=10&intolerances=-&query=" +
            text;
    Map<String, String> headers = {
      'x-rapidapi-host': 'spoonacular-recipe-food-nutrition-v1.p.rapidapi.com',
      'x-rapidapi-key': '318926f9a6msh9a7ae0daa088839p1d3650jsn0140476fdbd4'
    };

    final response = await http.get(url, headers: headers);

    this.setState(() {
      List jsonResponse = json.decode(response.body);
      print(jsonResponse);
      futureIngredients = jsonResponse
          .map((ingredients) => new Ingredients.fromJSON(ingredients))
          .toList();
    });
    _itemSelection = new List.generate(futureIngredients.length, (i) => false);
    return futureIngredients;
  }
}

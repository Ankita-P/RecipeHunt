import 'dart:convert';

import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'SearchRecipe.dart';

void main() => runApp(MyApp());

class Ingredients {
  final String ingredientName;
  final String imageName;

  Ingredients({this.ingredientName, this.imageName});

  factory Ingredients.fromJSON(Map<String, dynamic> json) {
    return Ingredients(ingredientName: json['name'], imageName: json['image']);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Hunt',
      home: MyCustomForm(),
    );
  }
}

// Define a custom Form widget.
class MyCustomForm extends StatefulWidget {
@override
_MyCustomFormState createState() => _MyCustomFormState();
}

// Define a corresponding State class.
// This class holds data related to the Form.
class _MyCustomFormState extends State<MyCustomForm> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  String textValue = 'a';
  List<Ingredients> futureIngredients;
  var _itemSelection = new List<bool>(10);

  var namesGrowable = new List<String>();

  @override
  void initState() {
    super.initState();
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
        title: Text('Recipe Hunt'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: searchRecipes,
        child: Text('Next'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SearchBar<Ingredients>(
            hintText: "Search Ingredients",
            minimumChars: 1,
            onSearch: fetchList,
            onItemFound: (Ingredients post, int index) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 2),
                color: _itemSelection[index] ? Colors.blue : Colors.transparent,
                child: ListTile(
                  title: Text(post.ingredientName),
                  subtitle: Text(post.imageName),
                  onTap: () {
                    namesGrowable.add(futureIngredients[index].ingredientName);
                    print(namesGrowable);
                    setState(
                        () => _itemSelection[index] = !_itemSelection[index]);
                  },
                ),
              );
            },
          ),

        ),
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
      futureIngredients = jsonResponse
          .map((ingredients) => new Ingredients.fromJSON(ingredients))
          .toList();
    });
    _itemSelection = new List.generate(futureIngredients.length, (i) => false);
    return futureIngredients;
  }
}

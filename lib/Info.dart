import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recipehunt/ShowRecipe.dart';


class AppInfo extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyAppInfo(),
    );
  }
}

// Define a custom Form widget.
class MyAppInfo extends StatefulWidget {

  @override
  _MyAppInfoState createState() => _MyAppInfoState();
}

class _MyAppInfoState extends State<MyAppInfo> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final TextStyle textstyle =
    TextStyle(fontFamily: 'Dosis', fontSize: 18.0);
    final InputDecoration decoration = InputDecoration(
      border: OutlineInputBorder(),
    );

    return WillPopScope(
      onWillPop: (){
        Navigator.pop(context);
      },
      child: new Scaffold(
        appBar: AppBar(
          title: new Text("Recipe Hunt"),
          backgroundColor: Colors.lightGreen,
          leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.white,),
            onPressed: () {
              Navigator.pop(context);
            },),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: new ConstrainedBox(
              constraints: BoxConstraints(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Column(
                      children: <Widget>[
                        new Container(
                          width: 150,
                          height: 150,
                          child: new Image.asset('assets/images/app_logo.png'),
                        ),
                        new Padding(padding: EdgeInsets.all(8.0),
                          child: new Text('Recipe Hunt',
                            style: TextStyle(fontFamily: 'Dosis',
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0,
                            color: Colors.lightGreen),
                          ),
                        ),
                        new Padding(padding: EdgeInsets.all(8.0),
                        child: new Text('Developer: Ankita Patil',
                          style: textstyle,
                        ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          width: MediaQuery.of(context).copyWith().size.width,
                          margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
                          color: Colors.black12,
                          child: Text("About", style: textstyle),
                        ),
                        new Container(
                            padding: EdgeInsets.all(8.0),
                            width: MediaQuery.of(context).copyWith().size.width,
                            margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
                          child: new Column(
                          children: <Widget>[
                            new Padding(padding: EdgeInsets.all(8.0), child: new Text('Recipe Hunt is a flutter based app that targets a widely asked question - What\'s for lunch? or What\'s for dinner?', style: textstyle)),
                            new Padding(padding: EdgeInsets.all(8.0), child: new Text('Using this app, you can put together a fantastic meal with the food items you have at the moment and save yourself some time to do other things!', style: textstyle)),
                            new Padding(padding: EdgeInsets.all(8.0), child: new Text('Go on, try the app! If you like it, leave a review here!', style: textstyle))
                          ],
                        )
                        )
                      ],
                    )
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

  }

}

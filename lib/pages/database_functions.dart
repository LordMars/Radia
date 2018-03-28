import 'package:flutter/material.dart';
import '../utils/databaseFunctions.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return new MaterialApp(
      title: 'Radia',
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Radia'),
        ),
        body: new Center(
          child: new MaterialButton(
              onPressed: (){
                test();
              },
            child: new Text('Create database objects'),
          )
        ),
      ),
    );
  }
}
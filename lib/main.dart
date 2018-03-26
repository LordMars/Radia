import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import './pages/landing_page.dart';

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
          child: new Text('Welcome to Radia'),
        ),
      ),
    );
  }
}
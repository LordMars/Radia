import 'package:flutter/material.dart';
import 'dart:async';
import './pages/main_page.dart';
import './pages/login_page.dart';
import './pages/signup_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return new MaterialApp(
      title: 'Radia',
      routes: <String, WidgetBuilder>{
        '/signup': (BuildContext context) => new SignupPage(),
        '/login': (BuildContext context) => new LoginPage(),
      },
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Radia'),
        ),
        body: new Center(
          child: new Column(
            children:[
              new Text('Welcome to Radia'),
              new GoToLogin(),
            ]
          ),
        ),
      ),
    );
  }
}

class GoToLogin extends RaisedButton{
  @override
  Widget build(BuildContext context){
    return new RaisedButton(
      elevation: 10.0,
      highlightElevation: 5.0,
      child: new Text('Get Started!'),
      onPressed: (){
        Navigator.push(
          context,
          new MaterialPageRoute(
            //builder: (context) => new LoginPage()
            builder: (context) => new HomePage()
          ),
        );
      }
    );
  }
}
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import './pages/login_page.dart';
import './pages/signup_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget{

  Future<List<String>> findSavedPhone() async{
    String uid = '';
    String phone = '';
    SharedPreferences preferences = await SharedPreferences.getInstance();
    uid = preferences.getString('uid');
    phone = preferences.getString('phone');
    return <String>[ uid, phone];
  }

  @override
  Widget build(BuildContext context){
    return new MaterialApp(
      title: 'Radia',
      routes: <String, WidgetBuilder>{
        '/signup': (BuildContext context) => new SignupPage(),
        '/login': (BuildContext context){
          findSavedPhone().then((info){
            return new LoginPage(info[0], info[1]);
          });
        },
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
            builder: (context) => new LoginPage('','')
          ),
        );
      }
    );
  }
}
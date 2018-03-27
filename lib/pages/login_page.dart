import 'package:flutter/material.dart';
import './main_page.dart';

class LoginPage extends StatelessWidget{
    @override
    Widget build(BuildContext context){
      return new Material(
        color: Colors.greenAccent,
        child: new GoToMain(),
      );
    }
}

class GoToMain extends RaisedButton{
  @override
  Widget build(BuildContext context){
    return new RaisedButton(
      elevation: 10.0,
      highlightElevation: 5.0,
      child: new Text('Login'),
      onPressed: (){
        Navigator.push(
          context,
          mainSwitch(),
        );
      }
    );
  }
}

MaterialPageRoute mainSwitch(){
          //login logic goes here. determines if following code is allowed
          return new MaterialPageRoute(
            builder: (context) => new HomePage()
          );
}
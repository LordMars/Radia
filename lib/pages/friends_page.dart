import 'package:flutter/material.dart';
import './main_page.dart';

class FriendPage extends StatelessWidget{
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
      child: new Text('Home'),
      onPressed: (){
        Navigator.pop(context);
      }
    );
  }
}

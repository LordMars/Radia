import 'package:flutter/material.dart';
import './chat_page.dart';
import './friends_page.dart';

class HomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return new Material(
      child: new Row(
        children: <Widget>[
          new GoToFriends(),
          new GoToChat(),
        ],)
      );
  }
}

//button that leads to the friends list
class GoToFriends extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return new RaisedButton(
      child: new Text('Friends List'),
      onPressed:  (){
        Navigator.push(
          context,
          friendSwitch(),
        );
      }
    );
  }
}

//button that leads to the chat page
class GoToChat extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return new RaisedButton(
      child: new Text('Chat page'),
      onPressed:  (){
        Navigator.push(
          context,
          chatSwitch(),
        );
      }
    );
  }
}

MaterialPageRoute chatSwitch(){
          //login logic goes here. determines if following code is allowed
          return new MaterialPageRoute(
            builder: (context) => new ChatsPage()
          );
}

MaterialPageRoute friendSwitch(){
          //login logic goes here. determines if following code is allowed
          return new MaterialPageRoute(
            builder: (context) => new FriendPage()
          );
}
import 'package:flutter/material.dart';
import './chat_page.dart';
import './friends_page.dart';

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';


class HomePage extends StatefulWidget{
  @override
  _HomePageState createState() => new _HomePageState();

}

class _HomePageState extends State<HomePage> {

  Map<String,double> _currentLocation;
  StreamSubscription<Map<String,double>> _locationSubscription;
  Location _location = new Location();

  bool currentWidget = true;

  Image image;

  @override
  initState() {
    super.initState();
    initPlatformState();
    _locationSubscription =
        _location.onLocationChanged.listen((Map<String,double> result) {
          setState(() {
            _currentLocation = result;
          });
        });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    Map<String,double> location;
    // Platform messages may fail, so we use a try/catch PlatformException.


    try {
      location = await _location.getLocation;
    } on PlatformException {
      location = null;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted)
      return;

    setState(() {
      _currentLocation = location;
    });

  }

  @override
  Widget build(BuildContext context){
      // Temporary API key included in url
      image = new Image.network("https://maps.googleapis.com/maps/api/staticmap?center=${_currentLocation["latitude"]},${_currentLocation["longitude"]}&zoom=15&size=270x448&scale=2&key=AIzaSyDaTLHqDQpGuN-IOTmgbUHYRS-oRE5PM0I");
      currentWidget = !currentWidget;


    return new Material(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Stack(
              children: <Widget>[ image,
                                  //Do we still even want these?
                                  // new GoToFriends(),
                                  //new GoToChat(),
                                ]
          ),
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
            builder: (context) => new ChatPage()
          );
}

MaterialPageRoute friendSwitch(){
          //login logic goes here. determines if following code is allowed
          return new MaterialPageRoute(
            builder: (context) => new FriendPage()
          );
}